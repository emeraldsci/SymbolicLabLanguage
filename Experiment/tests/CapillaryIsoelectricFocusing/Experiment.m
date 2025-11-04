(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentCapillaryIsoelectricFocusing*)

DefineTests[ExperimentCapillaryIsoelectricFocusing,
	{
		Example[
			{Basic,"Generates and returns a protocol object when given samples:"},
			ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]}],
			ObjectP[Object[Protocol, CapillaryIsoelectricFocusing]]
		],
		Example[
			{Basic,"Generates and returns a protocol object when given an unlisted sample:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID]],
			ObjectP[Object[Protocol, CapillaryIsoelectricFocusing]]
		],
		Example[
			{Basic,"Generates and returns a protocol object when given a Model-less sample:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample, "ExperimentCIEF model-less Test sample 5 (100 uL) "<>$SessionUUID]],
			ObjectP[Object[Protocol, CapillaryIsoelectricFocusing]]
		],
		Example[
			{Additional,"Input as {Position,Container}:"},
			ExperimentCapillaryIsoelectricFocusing[{"A1",Object[Container,Vessel,"Unit test container 1 for ExperimentCIEF tests "<>$SessionUUID]}],
			ObjectP[Object[Protocol, CapillaryIsoelectricFocusing]]
		],
		Example[
			{Additional,"Input as a mixture of all kinds of sample types: "},
			ExperimentCapillaryIsoelectricFocusing[{{"A1", Object[Container,Vessel,"Unit test container 1 for ExperimentCIEF tests "<>$SessionUUID]},Object[Sample,"ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]}],
			ObjectP[Object[Protocol, CapillaryIsoelectricFocusing]]
		],
		(* --- OptionTests --- *)
		Example[
			{Options,Instrument,"Specify a capillary electrophoresis instrument that will be used by the protocol. The instrument accepts a capillary cartridge loaded with electrolytes and sequentially analyzes samples by separating proteins according to their isoelectric point in a pH gradient:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				Instrument->Model[Instrument, ProteinCapillaryElectrophoresis, "Maurice"],
				Output->Options];
			Lookup[options,Instrument],
			ObjectReferenceP[Model[Instrument,ProteinCapillaryElectrophoresis,"Maurice"]],
			Variables:>{options}
		],
		Example[
			{Options,Cartridge,"Specify a capillary electrophoresis cartridge loaded on the instrument for Capillary IsoElectric Focusing (cIEF) experiments. The cartridge holds a single capillary and electrolyte buffers (sources of hydronium and hydroxyl ions). The cIEF cartridge can run 100 injections in up to 20 batches under optimal conditions, and up to 200 injections in total:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				Cartridge->Model[Container,ProteinCapillaryElectrophoresisCartridge, "cIEF"],
				Output->Options];
			Lookup[options,Cartridge],
			ObjectReferenceP[Model[Container,ProteinCapillaryElectrophoresisCartridge, "cIEF"]],
			Variables:>{options}
		],
		Example[
			{Options,SampleTemperature,"Specify a sample tray temperature at which samples are maintained while awaiting injection:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				SampleTemperature->Ambient,
				Output->Options];
			Lookup[options,SampleTemperature],
			25Celsius,
			Variables:>{options}
		],
		Example[
			{Options,NumberOfReplicates,"Specify a number of times each sample will be injected. For example, when NumberOfReplicates is set to 2, each sample will be run twice consecutively:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				NumberOfReplicates->2,
				Output->Options];
			Lookup[options,NumberOfReplicates],
			2,
			Variables:>{options}
		],
		Example[{Options,InjectionTable,"Specify the order of sample, Standard, and Blank samples loading and populate Blanks/Standards accordingly:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				InjectionTable->{
					{Blank, Model[Sample, "Milli-Q water"],10Microliter},
					{Sample,Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],4Microliter},
					{Sample,Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID],4Microliter},
					{Blank,	Model[Sample, "Milli-Q water"],5Microliter},
					{Standard, Model[Sample,StockSolution, "Resuspended cIEF System Suitability Peptide Panel"],3Microliter}
				},
				Output->Options];
			Lookup[options,Standards],
			ObjectReferenceP[Model[Sample,StockSolution, "Resuspended cIEF System Suitability Peptide Panel"]],
			Variables:>{options}
		],
		Example[{Options,InjectionTable,"Infer the order of sample, Standard, and Blank sample loading based on Samples/Blanks/Standards and their frequency:"},
			options = ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				InjectionTable->Automatic,
				StandardFrequency->Last,
				Blanks->Model[Sample,"Milli-Q water"],BlankFrequency->FirstAndLast,
				SampleVolume->4Microliter,
				BlankVolume->{10Microliter, 5Microliter},
				StandardVolume -> 3Microliter,
				Output->Options];
			Lookup[options,InjectionTable],
			{
				{Blank, ObjectReferenceP[Model[Sample, "Milli-Q water"]],10Microliter},
				{Blank,	ObjectReferenceP[Model[Sample, "Milli-Q water"]], 5Microliter},
				{Sample,ObjectReferenceP[Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID]],4Microliter},
				{Sample,ObjectReferenceP[Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]],4Microliter},
				{Blank,	ObjectReferenceP[Model[Sample, "Milli-Q water"]],5Microliter},
				{Blank,	ObjectReferenceP[Model[Sample, "Milli-Q water"]],10Microliter},
				{Standard, ObjectReferenceP[Model[Sample,StockSolution, "Resuspended cIEF System Suitability Peptide Panel"]],3Microliter}
			},
			Variables:>{options}
		],
		Example[
			{Options,Anolyte,"Specify a anode electrolyte solution loaded on the cartridge that is the source of hydronium ion for the capillary in cIEF experiments. Two milliliters of anolyte solution will be loaded onto the cartridge for every batch of up to 100 injection:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				Anolyte->Model[Sample, "0.08M Phosphoric Acid in 0.1% Methyl Cellulose"],
				Output->Options];
			Lookup[options,Anolyte],
			ObjectReferenceP[Model[Sample, "0.08M Phosphoric Acid in 0.1% Methyl Cellulose"]],
			Variables:>{options}
		],
		Example[
			{Options,Catholyte,"Specify a electrolyte solution loaded on the cartridge that is the source of hydroxyl ions for the capillary in cIEF experiments. Two milliliters of catholyte solution will be loaded onto the cartridge for every batch of up to 100 injection:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				Catholyte->Model[Sample, "0.1M Sodium Hydroxide in 0.1% Methyl Cellulose"],
				Output->Options];
			Lookup[options,Catholyte],
			ObjectReferenceP[Model[Sample, "0.1M Sodium Hydroxide in 0.1% Methyl Cellulose"]],
			Variables:>{options}
		],
		Example[
			{Options,ElectroosmoticConditioningBuffer,"Specify a ElectroosmoticConditioningBuffer solution is used to wash the capillary between injections to decrease electroosmotic flow. Two milliliters of 0.5% Methyl Cellulose solution will be loaded on the instrument for every batch of up to 100 injections:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				ElectroosmoticConditioningBuffer->Model[Sample, "0.5% Methyl Cellulose"],
				Output->Options];
			Lookup[options,ElectroosmoticConditioningBuffer],
			ObjectReferenceP[Model[Sample, "0.5% Methyl Cellulose"]],
			Variables:>{options}
		],
		Example[
			{Options,FluorescenceCalibrationStandard,"Specify a FluorescenceCalibrationStandard solution is used to set the baseline for NativeFluorescence detection. Five hundred microliters of a commercial standard are loaded on the instrument for every batch of up to 100 injections:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				FluorescenceCalibrationStandard->Model[Sample, "cIEF Fluorescence Calibration Standard"],
				Output->Options];
			Lookup[options,FluorescenceCalibrationStandard],
			ObjectReferenceP[Model[Sample, "cIEF Fluorescence Calibration Standard"]],
			Variables:>{options}
		],
		Example[
			{Options,WashSolution,"Specify a WashSolution is used to rinse the capillary after use. Two milliliters of WashSolution are loaded on the instrument:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				WashSolution->Model[Sample, "Milli-Q water"],
				Output->Options];
			Lookup[options,WashSolution],
			ObjectReferenceP[Model[Sample, "Milli-Q water"]],
			Variables:>{options}
		],
		Example[
			{Options,PlaceholderContainer,"Specify a PlaceholderContainer is an empty vial used to dry the capillary after wash:"},
			protocol=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				PlaceholderContainer->Model[Container, Vessel, "2 mL clear glass GC vial"]];
			First[Download[protocol,PlaceholderContainer[Object]]],
			ObjectReferenceP[Model[Container, Vessel, "2 mL clear glass GC vial"]],
			Variables:>{protocol}
		],
		Example[
			{Options,OnBoardMixing,"Specify whether samples should be mixed with the MasterMix before loading to the instrument or while performing the assay. OnBoardMixing should be used for sensitive samples. OnBoardMixing can be applied using up to 2 MasterMix vials, with up to 48 injections for each. When using OnBoardMixing, Sample tubes should contain samples in 25 microliters. Before injecting each sample, the instrument will add and mix 100 microliters of MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				OnBoardMixing->True,
				Output->Options];
			Lookup[options,OnBoardMixing],
			True,
			Variables:>{options},
			Messages:>{Warning::OnBoardMixingVolume}
		],
		Example[
			{Options,CartridgeStorageCondition,"Specify a non-default storage condition for the Cartridge after the protocol is completed. If left unset, Cartridge will be stored according to their current StorageCondition:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				CartridgeStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,CartridgeStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,AnolyteStorageCondition,"Specify a non-default storage condition for the Anolyte solution after the protocol is completed. If left unset, Cartridge will be stored according to their current StorageCondition:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				AnolyteStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,AnolyteStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,CatholyteStorageCondition,"Specify a non-default storage condition for the Catholyte solution after the protocol is completed. If left unset, Cartridge will be stored according to their current StorageCondition:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				CatholyteStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,CatholyteStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,ElectroosmoticConditioningBufferStorageCondition,"Specify a non-default storage condition for the ElectroosmoticConditioningBuffer after the protocol is completed. If left unset, Cartridge will be stored according to their current StorageCondition:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				ElectroosmoticConditioningBufferStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,ElectroosmoticConditioningBufferStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,FluorescenceCalibrationStandardStorageCondition,"Specify a non-default storage condition for the FluorescenceCalibrationStandard after the protocol is completed. If left unset, Cartridge will be stored according to their current StorageCondition:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				FluorescenceCalibrationStandardStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,FluorescenceCalibrationStandardStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,WashSolutionStorageCondition,"Specify a non-default storage condition for the WashSolution after the protocol is completed. If left unset, Cartridge will be stored according to their current StorageCondition:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				WashSolutionStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,WashSolutionStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,SampleVolume,"Specify the volume drawn from the sample to the assay tube. Each tube contains a Sample, DenaturationReagent, Ampholytes, IsoelectricPointMarkers, Spacers, and ElectroosmoticBlocker:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				SampleVolume->20Microliter,
				Output->Options];
			Lookup[options,SampleVolume],
			20Microliter,
			Variables:>{options}
		],
		Example[
			{Options,TotalVolume,"Specify the final volume in the assay tube prior to loading onto the capillary. Each tube contains a Sample, DenaturationReagent, Ampholytes, IsoelectricPointMarkers, Spacers, and ElectroosmoticBlocker:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				TotalVolume->100Microliter,
				Output->Options];
			Lookup[options,TotalVolume],
			100Microliter,
			Variables:>{options}
		],
		Example[
			{Options,PremadeMasterMix,"Specify if a premade MasterMix should be used or, alternatively, the MasterMix should be made as part of this protocol. The MasterMix contains the reagents required for cIEF experiments, i.e., DenaturationReagent, Ampholytes, IsoelectricPointMarkers, Spacers, and ElectroosmoticBlocker:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				PremadeMasterMix->True, PremadeMasterMixReagent-> Object[Sample,"ExperimentCIEF Test reagent "<>$SessionUUID],
				Output->Options];
			Lookup[options,PremadeMasterMix],
			True,
			Variables:>{options}
		],
		Example[
			{Options,PremadeMasterMix,"Specify if a premade MasterMix should be used by specifying the reagent:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				PremadeMasterMixReagent-> Object[Sample,"ExperimentCIEF Test reagent "<>$SessionUUID],
				Output->Options];
			Lookup[options,PremadeMasterMix],
			True,
			Variables:>{options}
		],
		Example[
			{Options,PremadeMasterMixReagent,"Specify a premade master mix used for cIEF experiment, containing DenaturationReagent, Ampholytes, IsoelectricPointMarkers, Spacers, and ElectroosmoticBlocker:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				PremadeMasterMixReagent->Model[Sample, StockSolution, "2X Wide-Range cIEF Premade Master Mix"],
				Output->Options];
			Lookup[options,PremadeMasterMixReagent],
			ObjectReferenceP[Model[Sample, StockSolution, "2X Wide-Range cIEF Premade Master Mix"]],
			Variables:>{options}
		],
		Example[
			{Options,PremadeMasterMixDiluent,"Specify a solution used to dilute the premade master mix used to its working concentration:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				PremadeMasterMixReagent-> Object[Sample,"ExperimentCIEF Test reagent "<>$SessionUUID], PremadeMasterMixDiluent->Model[Sample,"Milli-Q water"],
				Output->Options];
			Lookup[options,PremadeMasterMixDiluent],
			ObjectReferenceP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[
			{Options,PremadeMasterMixReagentDilutionFactor,"Specify a factor by which the premade MasterMix should be diluted by in the final assay tube:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				PremadeMasterMixReagent-> Object[Sample,"ExperimentCIEF Test reagent "<>$SessionUUID], PremadeMasterMixReagentDilutionFactor->2,
				Output->Options];
			Lookup[options,PremadeMasterMixReagentDilutionFactor],
			2,
			Variables:>{options}
		],
		Example[
			{Options,PremadeMasterMixReagentDilutionFactor,"Specify a factor by which the premade MasterMix should be diluted by in the final assay tube:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				PremadeMasterMixReagent-> Object[Sample,"ExperimentCIEF Test reagent "<>$SessionUUID], PremadeMasterMixReagentDilutionFactor->2,
				Output->Options];
			Lookup[options,PremadeMasterMixVolume],
			50Microliter,
			Variables:>{options}
		],
		Example[
			{Options,PremadeMasterMixVolume,"Specify a volume of the premade MasterMix required to reach its final concentration:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				PremadeMasterMixReagent-> Object[Sample,"ExperimentCIEF Test reagent "<>$SessionUUID], PremadeMasterMixVolume->40Microliter,
				Output->Options];
			Lookup[options,PremadeMasterMixVolume],
			40Microliter,
			Variables:>{options}
		],
		Example[
			{Options,PremadeMasterMixVolume,"Specify a volume of the premade MasterMix and calculate its final concentration:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				PremadeMasterMixReagent-> Object[Sample,"ExperimentCIEF Test reagent "<>$SessionUUID], PremadeMasterMixVolume->40Microliter,
				Output->Options];
			Lookup[options,PremadeMasterMixReagentDilutionFactor],
			2.5,
			Variables:>{options}
		],
		Example[
			{Options,Diluent,"Specify a solution used to top volume in assay tube to total volume and dilute components to working concentration:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				Diluent->Model[Sample,"Milli-Q water"],
				Output->Options];
			Lookup[options,Diluent],
			ObjectReferenceP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[
			{Options,Ampholytes,"Specify a composition of amphoteric molecules in the MasterMix that form the pH gradient:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				Ampholytes->{{Model[Sample,"Pharmalyte pH 5-8"]},{Model[Sample,"Pharmalyte pH 3-10"]}},
				Output->Options];
			Lookup[options,Ampholytes],
			{{ObjectReferenceP[Model[Sample,"Pharmalyte pH 5-8"]]},{ObjectReferenceP[Model[Sample,"Pharmalyte pH 3-10"]]}},
			Variables:>{options}
		],
		Example[
			{Options,AmpholyteTargetConcentrations,"Specify a concentration (Vol/Vol) of amphoteric molecules in the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				AmpholyteTargetConcentrations->{{1VolumePercent},{1VolumePercent}},
				Output->Options];
			Lookup[options,AmpholyteTargetConcentrations],
			{1VolumePercent},
			Variables:>{options}
		],
		Example[
			{Options,AmpholyteTargetConcentrations,"Specify a concentration (Vol/Vol) of amphoteric molecules in the MasterMix and calculate the volume accordingly:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				AmpholyteTargetConcentrations->{{1VolumePercent},{1VolumePercent}},
				Output->Options];
			Lookup[options,AmpholyteVolume],
			{1Microliter},
			Variables:>{options}
		],
		Example[
			{Options,AmpholyteVolume,"Specify a volume of amphoteric molecule stocks to add to the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				AmpholyteVolume->{{5Microliter},{5Microliter}},
				Output->Options];
			Lookup[options,AmpholyteVolume],
			{5Microliter},
			Variables:>{options}
		],
		Example[
			{Options,AmpholyteVolume,"Specify a volume of amphoteric molecule stocks to add to the MasterMix and calculate its final concentration:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				AmpholyteVolume->5Microliter,
				Output->Options];
			Lookup[options,AmpholyteTargetConcentrations],
			{5VolumePercent},
			Variables:>{options}
		],
		Example[
			{Options,IsoelectricPointMarkers,"Specify Reference analytes to include in the MasterMix that facilitate the interpolation of sample pI:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IsoelectricPointMarkers->{{Model[Sample,StockSolution,"Resuspended cIEF pI Marker - 4.05" ],Model[Sample,StockSolution,"Resuspended cIEF pI Marker - 10.17" ]},{Model[Sample,StockSolution,"Resuspended cIEF pI Marker - 6.14" ],Model[Sample,StockSolution,"Resuspended cIEF pI Marker - 8.40" ]}},
				Output->Options];
			Lookup[options,IsoelectricPointMarkers],
			{{ObjectReferenceP[Model[Sample,StockSolution,"Resuspended cIEF pI Marker - 4.05" ]],ObjectReferenceP[Model[Sample,StockSolution,"Resuspended cIEF pI Marker - 10.17" ]]},{ObjectReferenceP[Model[Sample,StockSolution,"Resuspended cIEF pI Marker - 6.14" ]],ObjectReferenceP[Model[Sample,StockSolution,"Resuspended cIEF pI Marker - 8.40" ]]}},
			Variables:>{options}
		],
		Example[
			{Options,IsoelectricPointMarkersTargetConcentrations,"Specify a final concentration (Vol/Vol) of pI markers in the assay tube:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IsoelectricPointMarkersTargetConcentrations->{{1VolumePercent,2VolumePercent},{3VolumePercent,4VolumePercent}},
				Output->Options];
			Lookup[options,IsoelectricPointMarkersTargetConcentrations],
			{{1VolumePercent,2VolumePercent},{3VolumePercent,4VolumePercent}},
			Variables:>{options}
		],
		Example[
			{Options,IsoelectricPointMarkersTargetConcentrations,"Specify a final concentration (Vol/Vol) of pI markers in the assay tube and calculate their volume:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IsoelectricPointMarkersTargetConcentrations->{{1VolumePercent,2VolumePercent},{3VolumePercent,4VolumePercent}},
				Output->Options];
			Lookup[options,IsoelectricPointMarkersVolume],
			{{1Microliter,2Microliter},{3Microliter,4Microliter}},
			Variables:>{options}
		],
		Example[
			{Options,IsoelectricPointMarkersVolume,"Specify a volume of pI marker stocks to add to the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IsoelectricPointMarkersVolume->{{1Microliter,2Microliter},{3Microliter,4Microliter}},
				Output->Options];
			Lookup[options,IsoelectricPointMarkersVolume],
			{{1Microliter,2Microliter},{3Microliter,4Microliter}},
			Variables:>{options}
		],
		Example[
			{Options,IsoelectricPointMarkersVolume,"Specify a volume of pI marker stocks to add to the MasterMix and calculate their final concentration:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IsoelectricPointMarkersVolume->{{1Microliter,2Microliter},{3Microliter,4Microliter}},
				Output->Options];
			Lookup[options,IsoelectricPointMarkersTargetConcentrations],
			{{1VolumePercent,2VolumePercent},{3VolumePercent,4VolumePercent}},
			Variables:>{options}
		],
		Example[
			{Options,ElectroosmoticFlowBlocker,"Specify Electroosmotic flow blocker to include in the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				ElectroosmoticFlowBlocker->Model[Sample,"1% Methyl Cellulose"],
				Output->Options];
			Lookup[options,ElectroosmoticFlowBlocker],
			ObjectReferenceP[Model[Sample,"1% Methyl Cellulose"]],
			Variables:>{options}
		],
		Example[
			{Options,ElectroosmoticFlowBlockerTargetConcentrations,"Specify a concentration of ElectroosmoticFlowBlocker in the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				ElectroosmoticFlowBlockerTargetConcentrations->0.5MassPercent,
				Output->Options];
			Lookup[options,ElectroosmoticFlowBlockerTargetConcentrations],
			0.5MassPercent,
			Variables:>{options}
		],
		Example[
			{Options,ElectroosmoticFlowBlockerTargetConcentrations,"Specify a concentration of ElectroosmoticFlowBlocker in the MasterMix and calculate the required volume:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				ElectroosmoticFlowBlockerTargetConcentrations->0.5MassPercent,
				Output->Options];
			Lookup[options,ElectroosmoticFlowBlockerVolume],
			50Microliter,
			Variables:>{options}
		],
		Example[
			{Options,ElectroosmoticFlowBlockerVolume,"Specify a volume of ElectroosmoticBlocker stock to add to the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				ElectroosmoticFlowBlockerVolume->40Microliter,
				Output->Options];
			Lookup[options,ElectroosmoticFlowBlockerVolume],
			40Microliter,
			Variables:>{options}
		],
		Example[
			{Options,ElectroosmoticFlowBlockerVolume,"Specify a volume of ElectroosmoticBlocker stock to add to the MasterMix and calculate its final concentration:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				ElectroosmoticFlowBlockerVolume->40Microliter,
				Output->Options];
			Lookup[options,ElectroosmoticFlowBlockerTargetConcentrations],
			0.4MassPercent,
			Variables:>{options}
		],
		Example[
			{Options,Denature,"Specify if a DenaturationReagent should be added to the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				Denature->True,
				Output->Options];
			Lookup[options,Denature],
			True,
			Variables:>{options}
		],
		Example[
			{Options,DenaturationReagent,"Specify a denaturing agent, e.g., Urea or SimpleSol, to be added to the MasterMix to prevent protein precipitation:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				DenaturationReagent->Model[Sample,StockSolution,"10M Urea"],
				Output->Options];
			Lookup[options,DenaturationReagent],
			ObjectReferenceP[Model[Sample,StockSolution,"10M Urea"]],
			Variables:>{options}
		],
		Example[
			{Options,DenaturationReagent,"Specify a denaturing agent, e.g., Urea or SimpleSol, to be added to the MasterMix to prevent protein precipitation:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				DenaturationReagent->Model[Sample,"SimpleSol"],
				Output->Options];
			Lookup[options,DenaturationReagent],
			ObjectReferenceP[Model[Sample,"SimpleSol"]],
			Variables:>{options}
		],
		Example[
			{Options,DenaturationReagentTargetConcentration,"Specify a final concentration of the denaturing agent in the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				DenaturationReagent->Model[Sample,StockSolution,"10M Urea"], DenaturationReagentTargetConcentration->2Molar,
				Output->Options];
			Lookup[options,DenaturationReagentTargetConcentration],
			2Molar,
			Variables:>{options}
		],
		Example[
			{Options,DenaturationReagentTargetConcentration,"Specify a final concentration of the denaturing agent in the MasterMix and calculate the required volume:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				DenaturationReagent->Model[Sample,StockSolution,"10M Urea"], DenaturationReagentTargetConcentration->2Molar,
				Output->Options];
			Lookup[options,DenaturationReagentVolume],
			20Microliter,
			Variables:>{options}
		],
		Example[
			{Options,DenaturationReagentVolume,"Specify a volume of the denaturing agent required to reach its final concentration in the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				DenaturationReagent->Model[Sample,StockSolution,"10M Urea"], DenaturationReagentVolume->20Microliter,
				Output->Options];
			Lookup[options,DenaturationReagentVolume],
			20Microliter,
			Variables:>{options}
		],
		Example[
			{Options,DenaturationReagentVolume,"Specify a volume of the denaturing agent required to reach its final concentration in the MasterMix and calculate its final concentration:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				DenaturationReagent->Model[Sample,StockSolution,"10M Urea"], DenaturationReagentVolume->20Microliter,
				Output->Options];
			Lookup[options,DenaturationReagentTargetConcentration],
			2.Molar,
			Variables:>{options}
		],
		Example[
			{Options,DenaturationReagentTargetConcentration,"Specify a final concentration of the denaturing agent in the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				DenaturationReagent->Model[Sample,"SimpleSol"], DenaturationReagentTargetConcentration->20VolumePercent,
				Output->Options];
			Lookup[options,DenaturationReagentTargetConcentration],
			20VolumePercent,
			Variables:>{options}
		],
		Example[
			{Options,DenaturationReagentTargetConcentration,"Specify a final concentration of the denaturing agent in the MasterMix and calculate the required volume:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				DenaturationReagent->Model[Sample,"SimpleSol"], DenaturationReagentTargetConcentration->20VolumePercent,
				Output->Options];
			Lookup[options,DenaturationReagentVolume],
			20Microliter,
			Variables:>{options}
		],
		Example[
			{Options,DenaturationReagentVolume,"Specify a volume of the denaturing agent required to reach its final concentration in the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				DenaturationReagent->Model[Sample,"SimpleSol"], DenaturationReagentVolume->20Microliter,
				Output->Options];
			Lookup[options,DenaturationReagentVolume],
			20Microliter,
			Variables:>{options}
		],
		Example[
			{Options,DenaturationReagentVolume,"Specify a volume of the denaturing agent required to reach its final concentration in the MasterMix and calculate its final concentration:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				DenaturationReagent->Model[Sample,"SimpleSol"], DenaturationReagentVolume->20Microliter,
				Output->Options];
			Lookup[options,DenaturationReagentTargetConcentration],
			20VolumePercent,
			Variables:>{options}
		],
		Example[
			{Options,IncludeAnodicSpacer,"Specify if an anodic spacer should be added to the MasterMix. Both acidic and alkaline carrier ampholytes may be lost in the electrolyte reservoirs due to diffusion and isotachophoresis, decreasing the resolution and detection of proteins at the extremes of the pH gradient. To reduce the loss of amopholytes, Spacers (ampholites with very low or very high pIs) can be added to buffer the loss of analytes of interest. Traditionally, Iminodiacetic acid (pI 2.2) and Arginine (pI 10.7) are added as Spacers:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeAnodicSpacer->True,
				Output->Options];
			Lookup[options,IncludeAnodicSpacer],
			True,
			Variables:>{options}
		],
		Example[
			{Options,AnodicSpacer,"Specify Acidic ampholyte to include in the MasterMix.  When analyzing a protein with very acidic pI (e.g. Pepsin), one might choose to add an AnodicSpacer such as Arginine (pI 10.7), to prevent loss of signal to the anolyte reservoir:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				AnodicSpacer->Model[Sample,StockSolution, "200mM Iminodiacetic acid"],
				Output->Options];
			Lookup[options,AnodicSpacer],
			ObjectReferenceP[Model[Sample,StockSolution, "200mM Iminodiacetic acid"]],
			Variables:>{options}
		],
		Example[
			{Options,AnodicSpacerTargetConcentration,"Specify a final concentration of AnodicSpacer in the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				AnodicSpacerTargetConcentration->10Millimolar,
				Output->Options];
			Lookup[options,AnodicSpacerTargetConcentration],
			10Millimolar,
			Variables:>{options}
		],
		Example[
			{Options,AnodicSpacerTargetConcentration,"Specify a final concentration of AnodicSpacer in the MasterMix and calculate the required volume:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				AnodicSpacerTargetConcentration->10Millimolar,
				Output->Options];
			Lookup[options,AnodicSpacerVolume],
			5Microliter,
			Variables:>{options}
		],
		Example[
			{Options,AnodicSpacerVolume,"Specify a volume of AnodicSpacer stock to add to the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				AnodicSpacerVolume->10Microliter,
				Output->Options];
			Lookup[options,AnodicSpacerVolume],
			10Microliter,
			Variables:>{options}
		],
		Example[
			{Options,AnodicSpacerVolume,"Specify a volume of AnodicSpacer stock to add to the MasterMix and calculate its final concentration:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				AnodicSpacerVolume->10Microliter,
				Output->Options];
			Lookup[options,AnodicSpacerTargetConcentration],
			20.Millimolar,
			Variables:>{options}
		],
		Example[
			{Options,IncludeCathodicSpacer,"Specify if a cathodic spacer should be added to the MasterMix. Both acidic and alkaline carrier ampholytes may be lost in the electrolyte reservoirs due to diffusion and isotachophoresis, decreasing the resolution and detection of proteins at the extremes of the pH gradient. To reduce the loss of amopholytes, Spacers (ampholites with very low or very high pIs) can be added to buffer the loss of analytes of interest. Traditionally, Iminodiacetic acid (pI 2.2) and Arginine (pI 10.7) are added as Spacers:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeCathodicSpacer->True,
				Output->Options];
			Lookup[options,IncludeCathodicSpacer],
			True,
			Variables:>{options}
		],
		Example[
			{Options,CathodicSpacer,"Specify Basic ampholyte spacer to include in the MasterMix. When analyzing a protein with very basic pI (e.g. Cytochrome C), one might choose to add a CathodicSpacer such as Arginine (pI 10.7), to prevent loss of signal to the catholyte reservoir:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				CathodicSpacer->Model[Sample,StockSolution, "500mM Arginine"],
				Output->Options];
			Lookup[options,CathodicSpacer],
			ObjectReferenceP[Model[Sample,StockSolution, "500mM Arginine"]],
			Variables:>{options}
		],
		Example[
			{Options,CathodicSpacerTargetConcentration,"Specify a concentration of Cathodic spacer in the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				CathodicSpacerTargetConcentration->10Millimolar,
				Output->Options];
			Lookup[options,CathodicSpacerTargetConcentration],
			10Millimolar,
			Variables:>{options}
		],
		Example[
			{Options,CathodicSpacerTargetConcentration,"Specify a concentration of Cathodic spacer in the MasterMix and calculate the required volume:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				CathodicSpacerTargetConcentration->10Millimolar,
				Output->Options];
			Lookup[options,CathodicSpacerVolume],
			2Microliter,
			Variables:>{options}
		],
		Example[
			{Options,CathodicSpacerVolume,"Specify a volume of Cathodic spacer stocks to add to the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				CathodicSpacerVolume->10Microliter,
				Output->Options];
			Lookup[options,CathodicSpacerVolume],
			10Microliter,
			Variables:>{options}
		],
		Example[
			{Options,CathodicSpacerVolume,"Specify a volume of Cathodic spacer stocks to add to the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				CathodicSpacerVolume->10Microliter,
				Output->Options];
			Lookup[options,CathodicSpacerTargetConcentration],
			50.Millimolar,
			Variables:>{options}
		],
		Example[
			{Options,AmpholytesStorageCondition,"Specify a non-default storage condition for ampholyte stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				AmpholytesStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,AmpholytesStorageCondition],
			{Refrigerator},
			Variables:>{options}
		],
		Example[
			{Options,IsoelectricPointMarkersStorageCondition,"Specify a non-default storage condition for IsoelectricPointMarker stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IsoelectricPointMarkersStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,IsoelectricPointMarkersStorageCondition],
			{Refrigerator,Refrigerator},
			Variables:>{options}
		],
		Example[
			{Options,DenaturationReagentStorageCondition,"Specify a non-default storage condition for DenaturationReagent stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				DenaturationReagentStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,DenaturationReagentStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,AnodicSpacerStorageCondition,"Specify a non-default storage condition for AnodicSpacer stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				AnodicSpacerStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,AnodicSpacerStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,CathodicSpacerStorageCondition,"Specify a non-default storage condition for CathodicSpacer stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				CathodicSpacerStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,CathodicSpacerStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,ElectroosmoticFlowBlockerStorageCondition,"Specify a non-default storage condition for CathodicSpacer stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				ElectroosmoticFlowBlockerStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,ElectroosmoticFlowBlockerStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,DiluentStorageCondition,"Specify a non-default storage condition for Diluent of this experiment after the protocol is completed. If left unset, Diluent will be stored according to their current StorageCondition:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				DiluentStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,DiluentStorageCondition],
			Refrigerator,
			Variables:>{options}
		],

		Example[
			{Options,DenaturationReagentStorageCondition,"Specify a non-default storage condition for DenaturationReagent stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				DenaturationReagentStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,DenaturationReagentStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,AnodicSpacerStorageCondition,"Specify a non-default storage condition for AnodicSpacer stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				AnodicSpacerStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,AnodicSpacerStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,CathodicSpacerStorageCondition,"Specify a non-default storage condition for CathodicSpacer stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				CathodicSpacerStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,CathodicSpacerStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,ElectroosmoticFlowBlockerStorageCondition,"Specify a non-default storage condition for CathodicSpacer stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				ElectroosmoticFlowBlockerStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,ElectroosmoticFlowBlockerStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,DiluentStorageCondition,"Specify a non-default storage condition for Diluent of this experiment after the protocol is completed. If left unset, Diluent will be stored according to their current StorageCondition:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				DiluentStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,DiluentStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,SamplesInStorageCondition,"Specify a non-default storage condition for SamplesIn of this experiment after the protocol is completed. If left unset, Diluent will be stored according to their current StorageCondition:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				SamplesInStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,SamplesInStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,LoadTime,"Specify Time to load samples in MasterMix into the capillary by vacuum:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				LoadTime->55Second,
				Output->Options];
			Lookup[options,LoadTime],
			55Second,
			Variables:>{options}
		],
		Example[
			{Options,VoltageDurationProfile,"Specify Series of voltages and durations to apply onto the capillary for separation. Supports up to 20 steps where each step is 0-600 minutes, and 0-5000 volts:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				VoltageDurationProfile->{{1500Volt, 1Minute}, {3000Volt, 10Minute}},
				Output->Options];
			Lookup[options,VoltageDurationProfile],
			{{1500Volt, 1Minute}, {3000Volt, 10Minute}},
			Variables:>{options}
		],
		Example[
			{Options,ImagingMethods,"Specify Whole capillary imaging by Either UVAbsorbance (280 nm) alone or both UVAbsorbance and Native Fluorescence (Ex 280 nm, Em 320-450nm):"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				ImagingMethods->AbsorbanceAndFluorescence,
				Output->Options];
			Lookup[options,ImagingMethods],
			AbsorbanceAndFluorescence,
			Variables:>{options}
		],
		Example[
			{Options,NativeFluorescenceExposureTime,"Specify Exposure duration for NativeFluorescence detection:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				NativeFluorescenceExposureTime->{3Second, 5Second, 10Second, 20Second},
				Output->Options];
			Lookup[options,NativeFluorescenceExposureTime],
			{3Second, 5Second, 10Second, 20Second},
			Variables:>{options}
		],
		Example[
			{Options,UVDetectionWavelength,"Specify a wavelength used for UVAbsorbtion detection:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				UVDetectionWavelength->280Nanometer,
				Output->Options];
			Lookup[options,UVDetectionWavelength],
			280Nanometer,
			Variables:>{options}
		],
		Example[
			{Options,NativeFluorescenceDetectionExcitationWavelengths,"Specify a Excitation wavelength used for NativeFluorescence:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				NativeFluorescenceDetectionExcitationWavelengths->280Nanometer,
				Output->Options];
			Lookup[options,NativeFluorescenceDetectionExcitationWavelengths],
			280Nanometer,
			Variables:>{options}
		],
		Example[
			{Options,NativeFluorescenceDetectionEmissionWavelengths,"Specify a Emission range used for NativeFluorescence:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				NativeFluorescenceDetectionEmissionWavelengths->{320Nanometer, 405Nanometer},
				Output->Options];
			Lookup[options,NativeFluorescenceDetectionEmissionWavelengths],
			{320Nanometer, 405Nanometer},
			Variables:>{options}
		],
		Example[
			{Options,IncludeStandards,"Standards: Specify if standards should be included in this experiment. Standards are used to both ensure reproducibility within and between Experiments and as a reference to interpolate the isoelectric point of unknown analytes in samples:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,
				Output->Options];
			Lookup[options,IncludeStandards],
			True,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,Standards,"Standards: Specify what standards to include:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				Standards->Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				Output->Options];
			Lookup[options,Standards],
			ObjectReferenceP[Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID]],
			Variables:>{options}
		],
		Example[
			{Options,StandardVolume,"Standards: Specify the volume drawn from the standard to the assay tube. Each tube contains a Sample, DenaturationReagent, Ampholytes, IsoelectricPointMarkers, Spacers, and ElectroosmoticBlocker:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				StandardVolume->20Microliter,
				Output->Options];
			Lookup[options,StandardVolume],
			20Microliter,
			Variables:>{options}
		],
		Example[
			{Options,StandardFrequency,"Standards: Specify how many injections per standard should be included in this experiment. Sample, Standard, and Blank injection order are resolved according to InjectionTable:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True, StandardFrequency->FirstAndLast,
				Output->Options];
			Lookup[options,StandardFrequency],
			FirstAndLast,
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardTotalVolume,"Standards: Specify the final volume in the assay tube, including standard and MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True, StandardTotalVolume->100Microliter,
				Output->Options];
			Lookup[options,StandardTotalVolume],
			100Microliter,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardPremadeMasterMix,"Standards: Specify if a premade master mix should be used or, alternatively, the master mix should be made as part of this protocol. The master mix contains the reagents required for cIEF experiments, i.e., DenaturationReagent, Ampholytes, IsoelectricPointMarkers, Spacers, and ElectroosmoticBlocker:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardPremadeMasterMix->True,
				Output->Options];
			Lookup[options,StandardPremadeMasterMix],
			True,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardPremadeMasterMixReagent,"Standards: Specify a premade master mix used for cIEF experiment, containing DenaturationReagent, Ampholytes, IsoelectricPointMarkers, Spacers, and ElectroosmoticBlocker:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardPremadeMasterMix->True,StandardPremadeMasterMixReagent->Model[Sample, StockSolution, "2X Wide-Range cIEF Premade Master Mix"],
				Output->Options];
			Lookup[options,StandardPremadeMasterMixReagent],
			ObjectReferenceP[Model[Sample, StockSolution, "2X Wide-Range cIEF Premade Master Mix"]],
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardPremadeMasterMixDiluent,"Standards: Specify a solution used to dilute the premade master mix used to its working concentration:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardPremadeMasterMixReagent->Object[Sample,"ExperimentCIEF Test reagent "<>$SessionUUID],StandardPremadeMasterMixDiluent->Model[Sample,"Milli-Q water"],
				Output->Options];
			Lookup[options,StandardPremadeMasterMixDiluent],
			ObjectReferenceP[Model[Sample,"Milli-Q water"]],
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardPremadeMasterMixReagentDilutionFactor,"Standards: Specify a factor by which the premade MasterMix should be diluted by in the final assay tube:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardPremadeMasterMixReagent->Object[Sample,"ExperimentCIEF Test reagent "<>$SessionUUID],StandardPremadeMasterMixReagentDilutionFactor->2.5,
				Output->Options];
			Lookup[options,StandardPremadeMasterMixReagentDilutionFactor],
			2.5,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardPremadeMasterMixReagentDilutionFactor,"Standards: Specify a factor by which the premade MasterMix should be diluted by in the final assay tube and calculate its volume:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardPremadeMasterMixReagent->Object[Sample,"ExperimentCIEF Test reagent "<>$SessionUUID],StandardPremadeMasterMixReagentDilutionFactor->2.5,
				Output->Options];
			Lookup[options,StandardPremadeMasterMixVolume],
			40.Microliter,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardPremadeMasterMixVolume,"Standards: Specify a volume of the premade MasterMix required to reach its final concentration:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardPremadeMasterMixReagent->Object[Sample,"ExperimentCIEF Test reagent "<>$SessionUUID],StandardPremadeMasterMixVolume->50Microliter,
				Output->Options];
			Lookup[options,StandardPremadeMasterMixVolume],
			50Microliter,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardPremadeMasterMixVolume,"Standards: Specify a volume of the premade MasterMix required and calculate its final concentration:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardPremadeMasterMixReagent->Object[Sample,"ExperimentCIEF Test reagent "<>$SessionUUID],StandardPremadeMasterMixVolume->50Microliter,
				Output->Options];
			Lookup[options,StandardPremadeMasterMixReagentDilutionFactor],
			2.,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardDiluent,"Standards: Specify a solution used to top volume in assay tube to total volume and dilute components to working concentration:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardDiluent->Model[Sample,"Milli-Q water"],
				Output->Options];
			Lookup[options,StandardDiluent],
			ObjectReferenceP[Model[Sample,"Milli-Q water"]],
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardAmpholytes,"Standards: Specify a composition of amphoteric molecules in the MasterMix that form the pH gradient:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardAmpholytes->{{Model[Sample,"Pharmalyte pH 5-8"],Model[Sample,"Pharmalyte pH 3-10"]}},
				Output->Options];
			Lookup[options,StandardAmpholytes],
			{ObjectReferenceP[Model[Sample,"Pharmalyte pH 5-8"]],ObjectReferenceP[Model[Sample,"Pharmalyte pH 3-10"]]},
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardAmpholyteTargetConcentrations,"Standards: Specify a concentration (Vol/Vol) of amphoteric molecules in the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardAmpholyteTargetConcentrations->{{1VolumePercent}},
				Output->Options];
			Lookup[options,StandardAmpholyteTargetConcentrations],
			{1VolumePercent},
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardAmpholyteTargetConcentrations,"Standards: Specify a concentration (Vol/Vol) of amphoteric molecules in the MasterMix and calculate their volume:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardAmpholyteTargetConcentrations->{{1VolumePercent}},
				Output->Options];
			Lookup[options,StandardAmpholyteVolume],
			{1Microliter},
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardAmpholyteVolume,"Standards: Specify a volume of amphoteric molecule stocks to add to the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardAmpholyteVolume->{{2Microliter}},
				Output->Options];
			Lookup[options,StandardAmpholyteVolume],
			{2Microliter},
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardAmpholyteVolume,"Standards: Specify a volume of amphoteric molecule stocks to add to the MasterMix and calculate its final concentration:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardAmpholyteVolume->{{2Microliter}},
				Output->Options];
			Lookup[options,StandardAmpholyteTargetConcentrations],
			{2VolumePercent},
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardIsoelectricPointMarkers,"Standards: Specify Reference analytes to include in the MasterMix that facilitate the interpolation of standard pI:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardIsoelectricPointMarkers->{{Model[Sample,StockSolution, "Resuspended cIEF pI Marker - 4.05" ],Model[Sample,StockSolution, "Resuspended cIEF pI Marker - 10.17" ]}},
				Output->Options];
			Lookup[options,StandardIsoelectricPointMarkers],
			{ObjectReferenceP[Model[Sample,StockSolution, "Resuspended cIEF pI Marker - 4.05" ]],ObjectReferenceP[Model[Sample,StockSolution, "Resuspended cIEF pI Marker - 10.17" ]]},
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardIsoelectricPointMarkersTargetConcentrations,"Standards: Specify a final concentration (Vol/Vol) of pI markers in the assay tube:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardIsoelectricPointMarkersTargetConcentrations->{{1VolumePercent,2VolumePercent}},
				Output->Options];
			Lookup[options,StandardIsoelectricPointMarkersTargetConcentrations],
			{1VolumePercent,2VolumePercent},
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardIsoelectricPointMarkersTargetConcentrations,"Standards: Specify a final concentration (Vol/Vol) of pI markers in the assay tube and calculate hte final volume:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardIsoelectricPointMarkersTargetConcentrations->{{1VolumePercent,2VolumePercent}},
				Output->Options];
			Lookup[options,StandardIsoelectricPointMarkersVolume],
			{1Microliter,2Microliter},
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardIsoelectricPointMarkersVolume,"Standards: Specify a volume of pI marker stocks to add to the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardIsoelectricPointMarkersVolume->{{2Microliter,4Microliter}},
				Output->Options];
			Lookup[options,StandardIsoelectricPointMarkersVolume],
			{2Microliter,4Microliter},
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardIsoelectricPointMarkersVolume,"Standards: Specify a volume of pI marker stocks to add to the MasterMix and calculate its final concentration:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardIsoelectricPointMarkersVolume->{{2Microliter,4Microliter}},
				Output->Options];
			Lookup[options,StandardIsoelectricPointMarkersTargetConcentrations],
			{2VolumePercent,4VolumePercent},
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardElectroosmoticFlowBlocker,"Standards: Specify Electroosmotic flow blocker to include in the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardElectroosmoticFlowBlocker->Model[Sample,"1% Methyl Cellulose"],
				Output->Options];
			Lookup[options,StandardElectroosmoticFlowBlocker],
			ObjectReferenceP[Model[Sample,"1% Methyl Cellulose"]],
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardElectroosmoticFlowBlockerTargetConcentrations,"Standards: Specify a concentration of ElectroosmoticFlowBlocker in the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardElectroosmoticFlowBlockerTargetConcentrations->0.5MassPercent,
				Output->Options];
			Lookup[options,StandardElectroosmoticFlowBlockerTargetConcentrations],
			0.5MassPercent,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardElectroosmoticFlowBlockerTargetConcentrations,"Standards: Specify a concentration of ElectroosmoticFlowBlocker in the MasterMix and calculate its volume:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardElectroosmoticFlowBlockerTargetConcentrations->0.5MassPercent,
				Output->Options];
			Lookup[options,StandardElectroosmoticFlowBlockerVolume],
			50Microliter,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardElectroosmoticFlowBlockerVolume,"Standards: Specify a volume of ElectroosmoticBlocker stock to add to the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardElectroosmoticFlowBlockerVolume->20Microliter,
				Output->Options];
			Lookup[options,StandardElectroosmoticFlowBlockerVolume],
			20Microliter,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardElectroosmoticFlowBlockerVolume,"Standards: Specify a volume of ElectroosmoticBlocker stock to add to the MasterMix and calculate its concentration:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardElectroosmoticFlowBlockerVolume->20Microliter,
				Output->Options];
			Lookup[options,StandardElectroosmoticFlowBlockerTargetConcentrations],
			0.2MassPercent,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardDenature,"Standards: Specify if a DenaturationReagent should be added to the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardDenature->True,
				Output->Options];
			Lookup[options,StandardDenature],
			True,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardDenaturationReagent,"Standards: Specify a denaturing agent, e.g., Urea, to be added to the MasterMix to prevent protein precipitation:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardDenaturationReagent->Model[Sample,StockSolution,"10M Urea"],
				Output->Options];
			Lookup[options,StandardDenaturationReagent],
			ObjectReferenceP[Model[Sample,StockSolution,"10M Urea"]],
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardDenaturationReagent,"Standards: Specify a denaturing agent, e.g., SimpleSol, to be added to the MasterMix to prevent protein precipitation:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardDenaturationReagent->Model[Sample,"SimpleSol"],
				Output->Options];
			Lookup[options,StandardDenaturationReagent],
			ObjectReferenceP[Model[Sample,"SimpleSol"]],
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardDenaturationReagentTargetConcentration,"Standards: Specify a final concentration of the denaturing agent in the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardDenaturationReagent->Model[Sample,StockSolution,"10M Urea"],StandardDenaturationReagentTargetConcentration->2Molar,
				Output->Options];
			Lookup[options,StandardDenaturationReagentTargetConcentration],
			2Molar,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardDenaturationReagentTargetConcentration,"Standards: Specify a final concentration of the denaturing agent in the MasterMix and calculate its volume:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardDenaturationReagent->Model[Sample,StockSolution,"10M Urea"],StandardDenaturationReagentTargetConcentration->2Molar,
				Output->Options];
			Lookup[options,StandardDenaturationReagentVolume],
			20Microliter,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardDenaturationReagentTargetConcentration,"Standards: Specify a final concentration of the denaturing agent in the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardDenaturationReagent->Model[Sample,"SimpleSol"],StandardDenaturationReagentTargetConcentration->20VolumePercent,
				Output->Options];
			Lookup[options,StandardDenaturationReagentTargetConcentration],
			20VolumePercent,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardDenaturationReagentTargetConcentration,"Standards: Specify a final concentration of the denaturing agent in the MasterMix and calculate its volume:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardDenaturationReagent->Model[Sample,"SimpleSol"],StandardDenaturationReagentTargetConcentration->20VolumePercent,
				Output->Options];
			Lookup[options,StandardDenaturationReagentVolume],
			20Microliter,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardDenaturationReagentVolume,"Standards: Specify a volume of the denaturing agent required to reach its final concentration in the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardDenaturationReagent->Model[Sample,StockSolution,"10M Urea"],StandardDenaturationReagentVolume->10Microliter,
				Output->Options];
			Lookup[options,StandardDenaturationReagentVolume],
			10Microliter,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardDenaturationReagentVolume,"Standards: Specify a volume of the denaturing agent required to reach its final concentration in the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardDenaturationReagent->Model[Sample,StockSolution,"10M Urea"],StandardDenaturationReagentVolume->10Microliter,
				Output->Options];
			Lookup[options,StandardDenaturationReagentTargetConcentration],
			1.Molar,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardDenaturationReagentVolume,"Standards: Specify a volume of the denaturing agent required to reach its final concentration in the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardDenaturationReagent->Model[Sample,"SimpleSol"],StandardDenaturationReagentVolume->10Microliter,
				Output->Options];
			Lookup[options,StandardDenaturationReagentVolume],
			10Microliter,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardDenaturationReagentVolume,"Standards: Specify a volume of the denaturing agent required to reach its final concentration in the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardDenaturationReagent->Model[Sample,"SimpleSol"],StandardDenaturationReagentVolume->10Microliter,
				Output->Options];
			Lookup[options,StandardDenaturationReagentTargetConcentration],
			10VolumePercent,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardIncludeAnodicSpacer,"Standards: Specify if an anodic spacer should be added to the MasterMix. Both acidic and alkaline carrier ampholytes may be lost in the electrolyte reservoirs due to diffusion and isotachophoresis, decreasing the resolution and detection of proteins at the extremes of the pH gradient. To reduce the loss of amopholytes, Spacers (ampholites with very low or very high pIs) can be added to buffer the loss of analytes of interest. Traditionally, Iminodiacetic acid (pI 2.2) is added as an AnodicSpacer:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardIncludeAnodicSpacer->True,
				Output->Options];
			Lookup[options,StandardIncludeAnodicSpacer],
			True,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardAnodicSpacer,"Standards: Specify Acidic ampholyte to include in the MasterMix.  When analyzing a protein with very acidic pI (e.g. Pepsin), one might choose to add an AnodicSpacer such as Arginine (pI 10.7), to prevent loss of signal to the anolyte reservoir:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardAnodicSpacer->Model[Sample,StockSolution, "200mM Iminodiacetic acid"],
				Output->Options];
			Lookup[options,StandardAnodicSpacer],
			ObjectReferenceP[Model[Sample,StockSolution, "200mM Iminodiacetic acid"]],
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardAnodicSpacerTargetConcentration,"Standards: Specify a final concentration of AnodicSpacer in the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardAnodicSpacerTargetConcentration->10Millimolar,
				Output->Options];
			Lookup[options,StandardAnodicSpacerTargetConcentration],
			10Millimolar,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardAnodicSpacerTargetConcentration,"Standards: Specify a final concentration of AnodicSpacer in the MasterMix and calculate its volume:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardAnodicSpacerTargetConcentration->10Millimolar,
				Output->Options];
			Lookup[options,StandardAnodicSpacerVolume],
			5Microliter,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardAnodicSpacerVolume,"Standards: Specify a volume of AnodicSpacer stock to add to the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardAnodicSpacerVolume->10Microliter,
				Output->Options];
			Lookup[options,StandardAnodicSpacerVolume],
			10Microliter,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardAnodicSpacerVolume,"Standards: Specify a volume of AnodicSpacer stock to add to the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardAnodicSpacerVolume->10Microliter,
				Output->Options];
			Lookup[options,StandardAnodicSpacerTargetConcentration],
			20.Millimolar,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardIncludeCathodicSpacer,"Standards: Specify if a cathodic spacer should be added to the MasterMix. Both acidic and alkaline carrier ampholytes may be lost in the electrolyte reservoirs due to diffusion and isotachophoresis, decreasing the resolution and detection of proteins at the extremes of the pH gradient. To reduce the loss of amopholytes, Spacers (ampholites with very low or very high pIs) can be added to buffer the loss of analytes of interest. Traditionally, Iminodiacetic acid (pI 2.2) and Arginine (pI 10.7) are added as Spacers:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardIncludeCathodicSpacer->True,
				Output->Options];
			Lookup[options,StandardIncludeCathodicSpacer],
			True,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardCathodicSpacer,"Standards: Specify Basic ampholyte spacer to include in the MasterMix. When analyzing a protein with very basic pI (e.g. Cytochrome C), one might choose to add a CathodicSpacer such as Arginine (pI 10.7), to prevent loss of signal to the catholyte reservoir:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardCathodicSpacer->Model[Sample,StockSolution, "500mM Arginine"],
				Output->Options];
			Lookup[options,StandardCathodicSpacer],
			ObjectReferenceP[Model[Sample,StockSolution, "500mM Arginine"]],
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardCathodicSpacerTargetConcentration,"Standards: Specify a concentration of Cathodic spacer in the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardCathodicSpacerTargetConcentration->10Millimolar,
				Output->Options];
			Lookup[options,StandardCathodicSpacerTargetConcentration],
			10Millimolar,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardCathodicSpacerTargetConcentration,"Standards: Specify a concentration of Cathodic spacer in the MasterMix and calculate its volume:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardCathodicSpacerTargetConcentration->10Millimolar,
				Output->Options];
			Lookup[options,StandardCathodicSpacerVolume],
			2Microliter,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardCathodicSpacerVolume,"Standards: Specify a volume of Cathodic spacer stocks to add to the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardCathodicSpacerVolume->10Microliter,
				Output->Options];
			Lookup[options,StandardCathodicSpacerVolume],
			10Microliter,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardCathodicSpacerVolume,"Standards: Specify a volume of Cathodic spacer stocks to add to the MasterMix and calculate its final concentration:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardCathodicSpacerVolume->10Microliter,
				Output->Options];
			Lookup[options,StandardCathodicSpacerTargetConcentration],
			RangeP[50Millimolar,50Millimolar],
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardDenaturationReagentStorageCondition,"Standards: Specify a non-default storage condition for DenaturationReagent stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardDenaturationReagentStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,StandardDenaturationReagentStorageCondition],
			Refrigerator,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardAnodicSpacerStorageCondition,"Standards: Specify a non-default storage condition for AnodicSpacer stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardAnodicSpacerStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,StandardAnodicSpacerStorageCondition],
			Refrigerator,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardCathodicSpacerStorageCondition,"Standards: Specify a non-default storage condition for CathodicSpacer stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardCathodicSpacerStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,StandardCathodicSpacerStorageCondition],
			Refrigerator,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardElectroosmoticFlowBlockerStorageCondition,"Standards: Specify a non-default storage condition for CathodicSpacer stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardElectroosmoticFlowBlockerStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,StandardElectroosmoticFlowBlockerStorageCondition],
			Refrigerator,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardDiluentStorageCondition,"Standards: Specify a non-default storage condition for Diluent of this experiment after the protocol is completed. If left unset, Diluent will be stored according to their current StorageCondition:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardDiluentStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,StandardDiluentStorageCondition],
			Refrigerator,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardStorageCondition,"Standards: Specify a non-default storage condition for standards of this experiment after the protocol is completed. If left unset, Diluent will be stored according to their current StorageCondition:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,StandardStorageCondition],
			Refrigerator,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardAmpholytesStorageCondition,"Standards: Specify a non-default storage condition for ampholyte stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True, StandardAmpholytesStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,StandardAmpholytesStorageCondition],
			{Refrigerator},
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardIsoelectricPointMarkersStorageCondition,"Standards: Specify a non-default storage condition for isoelectric point markers stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True, StandardIsoelectricPointMarkersStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,StandardIsoelectricPointMarkersStorageCondition],
			{Refrigerator, Refrigerator},
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardLoadTime,"Standards: Specify Time to load standards in MasterMix into the capillary by vacuum:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardLoadTime->55Second,
				Output->Options];
			Lookup[options,StandardLoadTime],
			55Second,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardVoltageDurationProfile,"Standards: Specify Series of voltages and durations to apply onto the capillary for separation. Supports up to 20 steps where each step is 0-600 minutes, and 0-5000 volts:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardVoltageDurationProfile->{{1500Volt, 1Minute}, {3000Volt, 10Minute}},
				Output->Options];
			Lookup[options,StandardVoltageDurationProfile],
			{{1500Volt, 1Minute}, {3000Volt, 10Minute}},
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardImagingMethods,"Standards: Specify Whole capillary imaging by Either UVAbsorbance (280 nm) alone or both UVAbsorbance and Native Fluorescence (Ex 280 nm, Em 320-450nm):"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardImagingMethods->AbsorbanceAndFluorescence,
				Output->Options];
			Lookup[options,StandardImagingMethods],
			AbsorbanceAndFluorescence,
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,StandardNativeFluorescenceExposureTime,"Standards: Specify Exposure duration for NativeFluorescence detection:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeStandards->True,StandardNativeFluorescenceExposureTime->{3Second, 5Second, 10Second, 20Second},
				Output->Options];
			Lookup[options,StandardNativeFluorescenceExposureTime],
			{3Second, 5Second, 10Second, 20Second},
			Variables:>{options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[
			{Options,IncludeBlanks,"Blanks: Specify if standards should be included in this experiment. Blanks are used to both ensure reproducibility within and between Experiments and as a reference to interpolate the isoelectric point of unknown analytes in samples:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,
				Output->Options];
			Lookup[options,IncludeBlanks],
			True,
			Variables:>{options}
		],
		Example[
			{Options,Blanks,"Blanks: Specify what standards to include:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				Blanks->Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				Output->Options];
			Lookup[options,Blanks],
			ObjectReferenceP[Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID]],
			Variables:>{options}
		],
		Example[
			{Options,BlankVolume,"Blanks: Specify the volume drawn from the standard to the assay tube. Each tube contains a Sample, DenaturationReagent, Ampholytes, IsoelectricPointMarkers, Spacers, and ElectroosmoticBlocker:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				BlankVolume->20Microliter,
				Output->Options];
			Lookup[options,BlankVolume],
			20Microliter,
			Variables:>{options}
		],
		Example[
			{Options,BlankFrequency,"Blanks: Specify how many injections per standard should be included in this experiment. Sample, Blank, and Blank injection order are resolved according to InjectionTable:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True, BlankFrequency->FirstAndLast,
				Output->Options];
			Lookup[options,BlankFrequency],
			FirstAndLast
		],
		Example[
			{Options,BlankTotalVolume,"Blanks: Specify the final volume in the assay tube, including standard and MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True, BlankTotalVolume->100Microliter,
				Output->Options];
			Lookup[options,BlankTotalVolume],
			100Microliter,
			Variables:>{options}
		],
		Example[
			{Options,BlankPremadeMasterMix,"Blanks: Specify if a premade master mix should be used or, alternatively, the master mix should be made as part of this protocol. The master mix contains the reagents required for cIEF experiments, i.e., DenaturationReagent, Ampholytes, IsoelectricPointMarkers, Spacers, and ElectroosmoticBlocker:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankPremadeMasterMix->True,
				Output->Options];
			Lookup[options,BlankPremadeMasterMix],
			True,
			Variables:>{options},
			Messages:>{}
		],
		Example[
			{Options,BlankPremadeMasterMixReagent,"Blanks: Specify a premade master mix used for cIEF experiment, containing DenaturationReagent, Ampholytes, IsoelectricPointMarkers, Spacers, and ElectroosmoticBlocker:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankPremadeMasterMix->True,BlankPremadeMasterMixReagent->Model[Sample, StockSolution, "2X Wide-Range cIEF Premade Master Mix"],
				Output->Options];
			Lookup[options,BlankPremadeMasterMixReagent],
			ObjectReferenceP[Model[Sample, StockSolution, "2X Wide-Range cIEF Premade Master Mix"]],
			Variables:>{options}
		],
		Example[
			{Options,BlankPremadeMasterMixDiluent,"Blanks: Specify a solution used to dilute the premade master mix used to its working concentration:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankPremadeMasterMixReagent->Object[Sample,"ExperimentCIEF Test reagent "<>$SessionUUID],BlankPremadeMasterMixDiluent->Model[Sample,"Milli-Q water"],
				Output->Options];
			Lookup[options,BlankPremadeMasterMixDiluent],
			ObjectReferenceP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[
			{Options,BlankPremadeMasterMixReagentDilutionFactor,"Blanks: Specify a factor by which the premade MasterMix should be diluted by in the final assay tube:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankPremadeMasterMixReagent->Object[Sample,"ExperimentCIEF Test reagent "<>$SessionUUID],BlankPremadeMasterMixReagentDilutionFactor->2.5,
				Output->Options];
			Lookup[options,BlankPremadeMasterMixReagentDilutionFactor],
			2.5,
			Variables:>{options}
		],
		Example[
			{Options,BlankPremadeMasterMixReagentDilutionFactor,"Blanks: Specify a factor by which the premade MasterMix should be diluted by in the final assay tube and calculate its volume:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankPremadeMasterMixReagent->Object[Sample,"ExperimentCIEF Test reagent "<>$SessionUUID],BlankPremadeMasterMixReagentDilutionFactor->2.5,
				Output->Options];
			Lookup[options,BlankPremadeMasterMixVolume],
			40.Microliter,
			Variables:>{options}
		],
		Example[
			{Options,BlankPremadeMasterMixVolume,"Blanks: Specify a volume of the premade MasterMix required to reach its final concentration:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankPremadeMasterMixReagent->Object[Sample,"ExperimentCIEF Test reagent "<>$SessionUUID],BlankPremadeMasterMixVolume->50Microliter,
				Output->Options];
			Lookup[options,BlankPremadeMasterMixVolume],
			50Microliter,
			Variables:>{options}
		],
		Example[
			{Options,BlankPremadeMasterMixVolume,"Blanks: Specify a volume of the premade MasterMix required and calculate its final concentration:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankPremadeMasterMixReagent->Object[Sample,"ExperimentCIEF Test reagent "<>$SessionUUID],BlankPremadeMasterMixVolume->50Microliter,
				Output->Options];
			Lookup[options,BlankPremadeMasterMixReagentDilutionFactor],
			2.,
			Variables:>{options}
		],
		Example[
			{Options,BlankDiluent,"Blanks: Specify a solution used to top volume in assay tube to total volume and dilute components to working concentration:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankDiluent->Model[Sample,"Milli-Q water"],
				Output->Options];
			Lookup[options,BlankDiluent],
			ObjectReferenceP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[
			{Options,BlankAmpholytes,"Blanks: Specify a composition of amphoteric molecules in the MasterMix that form the pH gradient:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankAmpholytes->{{Model[Sample,"Pharmalyte pH 5-8"],Model[Sample,"Pharmalyte pH 3-10"]}},
				Output->Options];
			Lookup[options,BlankAmpholytes],
			{ObjectReferenceP[Model[Sample,"Pharmalyte pH 5-8"]],ObjectReferenceP[Model[Sample,"Pharmalyte pH 3-10"]]},
			Variables:>{options},
			Messages:>{}
		],
		Example[
			{Options,BlankAmpholyteTargetConcentrations,"Blanks: Specify a concentration (Vol/Vol) of amphoteric molecules in the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankAmpholyteTargetConcentrations->{{1VolumePercent}},
				Output->Options];
			Lookup[options,BlankAmpholyteTargetConcentrations],
			{1VolumePercent},
			Variables:>{options}
		],
		Example[
			{Options,BlankAmpholyteTargetConcentrations,"Blanks: Specify a concentration (Vol/Vol) of amphoteric molecules in the MasterMix and calculate their volume:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankAmpholyteTargetConcentrations->{{1VolumePercent}},
				Output->Options];
			Lookup[options,BlankAmpholyteVolume],
			{1Microliter},
			Variables:>{options}
		],
		Example[
			{Options,BlankAmpholyteVolume,"Blanks: Specify a volume of amphoteric molecule stocks to add to the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankAmpholyteVolume->{{2Microliter}},
				Output->Options];
			Lookup[options,BlankAmpholyteVolume],
			{2Microliter},
			Variables:>{options}
		],
		Example[
			{Options,BlankAmpholyteVolume,"Blanks: Specify a volume of amphoteric molecule stocks to add to the MasterMix and calculate its final concentration:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankAmpholyteVolume->{{2Microliter}},
				Output->Options];
			Lookup[options,BlankAmpholyteTargetConcentrations],
			{2VolumePercent},
			Variables:>{options}
		],
		Example[
			{Options,BlankIsoelectricPointMarkers,"Blanks: Specify Reference analytes to include in the MasterMix that facilitate the interpolation of standard pI:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankIsoelectricPointMarkers->{{Model[Sample,StockSolution, "Resuspended cIEF pI Marker - 4.05" ],Model[Sample,StockSolution, "Resuspended cIEF pI Marker - 10.17" ]}},
				Output->Options];
			Lookup[options,BlankIsoelectricPointMarkers],
			{ObjectReferenceP[Model[Sample,StockSolution, "Resuspended cIEF pI Marker - 4.05" ]],ObjectReferenceP[Model[Sample,StockSolution, "Resuspended cIEF pI Marker - 10.17" ]]},
			Variables:>{options}
		],
		Example[
			{Options,BlankIsoelectricPointMarkersTargetConcentrations,"Blanks: Specify a final concentration (Vol/Vol) of pI markers in the assay tube:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankIsoelectricPointMarkersTargetConcentrations->{{1VolumePercent,2VolumePercent}},
				Output->Options];
			Lookup[options,BlankIsoelectricPointMarkersTargetConcentrations],
			{1VolumePercent,2VolumePercent},
			Variables:>{options}
		],
		Example[
			{Options,BlankIsoelectricPointMarkersTargetConcentrations,"Blanks: Specify a final concentration (Vol/Vol) of pI markers in the assay tube and calculate hte final volume:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankIsoelectricPointMarkersTargetConcentrations->{{1VolumePercent,2VolumePercent}},
				Output->Options];
			Lookup[options,BlankIsoelectricPointMarkersVolume],
			{1Microliter,2Microliter},
			Variables:>{options}
		],
		Example[
			{Options,BlankIsoelectricPointMarkersVolume,"Blanks: Specify a volume of pI marker stocks to add to the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankIsoelectricPointMarkersVolume->{{2Microliter,4Microliter}},
				Output->Options];
			Lookup[options,BlankIsoelectricPointMarkersVolume],
			{2Microliter,4Microliter},
			Variables:>{options}
		],
		Example[
			{Options,BlankIsoelectricPointMarkersVolume,"Blanks: Specify a volume of pI marker stocks to add to the MasterMix and calculate its final concentration:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankIsoelectricPointMarkersVolume->{{2Microliter,4Microliter}},
				Output->Options];
			Lookup[options,BlankIsoelectricPointMarkersTargetConcentrations],
			{2VolumePercent,4VolumePercent},
			Variables:>{options}
		],
		Example[
			{Options,BlankElectroosmoticFlowBlocker,"Blanks: Specify Electroosmotic flow blocker to include in the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankElectroosmoticFlowBlocker->Model[Sample,"1% Methyl Cellulose"],
				Output->Options];
			Lookup[options,BlankElectroosmoticFlowBlocker],
			ObjectReferenceP[Model[Sample,"1% Methyl Cellulose"]],
			Variables:>{options}
		],
		Example[
			{Options,BlankElectroosmoticFlowBlockerTargetConcentrations,"Blanks: Specify a concentration of ElectroosmoticFlowBlocker in the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankElectroosmoticFlowBlockerTargetConcentrations->0.5MassPercent,
				Output->Options];
			Lookup[options,BlankElectroosmoticFlowBlockerTargetConcentrations],
			0.5MassPercent,
			Variables:>{options}
		],
		Example[
			{Options,BlankElectroosmoticFlowBlockerTargetConcentrations,"Blanks: Specify a concentration of ElectroosmoticFlowBlocker in the MasterMix and calculate its volume:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankElectroosmoticFlowBlockerTargetConcentrations->0.5MassPercent,
				Output->Options];
			Lookup[options,BlankElectroosmoticFlowBlockerVolume],
			50Microliter,
			Variables:>{options}
		],
		Example[
			{Options,BlankElectroosmoticFlowBlockerVolume,"Blanks: Specify a volume of ElectroosmoticBlocker stock to add to the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankElectroosmoticFlowBlockerVolume->20Microliter,
				Output->Options];
			Lookup[options,BlankElectroosmoticFlowBlockerVolume],
			20Microliter,
			Variables:>{options}
		],
		Example[
			{Options,BlankElectroosmoticFlowBlockerVolume,"Blanks: Specify a volume of ElectroosmoticBlocker stock to add to the MasterMix and calculate its concentration:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankElectroosmoticFlowBlockerVolume->20Microliter,
				Output->Options];
			Lookup[options,BlankElectroosmoticFlowBlockerTargetConcentrations],
			0.2MassPercent,
			Variables:>{options}
		],
		Example[
			{Options,BlankDenature,"Blanks: Specify if a DenaturationReagent should be added to the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankDenature->True,
				Output->Options];
			Lookup[options,BlankDenature],
			True,
			Variables:>{options}
		],
		Example[
			{Options,BlankDenaturationReagent,"Blanks: Specify a denaturing agent, e.g., Urea, to be added to the MasterMix to prevent protein precipitation:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankDenaturationReagent->Model[Sample,StockSolution,"10M Urea"],
				Output->Options];
			Lookup[options,BlankDenaturationReagent],
			ObjectReferenceP[Model[Sample,StockSolution,"10M Urea"]],
			Variables:>{options}
		],
		Example[
			{Options,BlankDenaturationReagent,"Blanks: Specify a denaturing agent, e.g., SimpleSol, to be added to the MasterMix to prevent protein precipitation:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankDenaturationReagent->Model[Sample,"SimpleSol"],
				Output->Options];
			Lookup[options,BlankDenaturationReagent],
			ObjectReferenceP[Model[Sample,"SimpleSol"]],
			Variables:>{options}
		],
		Example[
			{Options,BlankDenaturationReagentTargetConcentration,"Blanks: Specify a final concentration of the denaturing agent in the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankDenaturationReagent->Model[Sample,StockSolution,"10M Urea"],BlankDenaturationReagentTargetConcentration->2Molar,
				Output->Options];
			Lookup[options,BlankDenaturationReagentTargetConcentration],
			2Molar,
			Variables:>{options}
		],
		Example[
			{Options,BlankDenaturationReagentTargetConcentration,"Blanks: Specify a final concentration of the denaturing agent in the MasterMix and calculate its volume:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankDenaturationReagent->Model[Sample,StockSolution,"10M Urea"],BlankDenaturationReagentTargetConcentration->2Molar,
				Output->Options];
			Lookup[options,BlankDenaturationReagentVolume],
			20Microliter,
			Variables:>{options}
		],
		Example[
			{Options,BlankDenaturationReagentTargetConcentration,"Blanks: Specify a final concentration of the denaturing agent in the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankDenaturationReagent->Model[Sample,"SimpleSol"],BlankDenaturationReagentTargetConcentration->20VolumePercent,
				Output->Options];
			Lookup[options,BlankDenaturationReagentTargetConcentration],
			20VolumePercent,
			Variables:>{options}
		],
		Example[
			{Options,BlankDenaturationReagentTargetConcentration,"Blanks: Specify a final concentration of the denaturing agent in the MasterMix and calculate its volume:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankDenaturationReagent->Model[Sample,"SimpleSol"],BlankDenaturationReagentTargetConcentration->20VolumePercent,
				Output->Options];
			Lookup[options,BlankDenaturationReagentVolume],
			20Microliter,
			Variables:>{options}
		],
		Example[
			{Options,BlankDenaturationReagentVolume,"Blanks: Specify a volume of the denaturing agent required to reach its final concentration in the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankDenaturationReagent->Model[Sample,StockSolution,"10M Urea"],BlankDenaturationReagentVolume->10Microliter,
				Output->Options];
			Lookup[options,BlankDenaturationReagentVolume],
			10Microliter,
			Variables:>{options}
		],
		Example[
			{Options,BlankDenaturationReagentVolume,"Blanks: Specify a volume of the denaturing agent required to reach its final concentration in the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankDenaturationReagent->Model[Sample,StockSolution,"10M Urea"],BlankDenaturationReagentVolume->10Microliter,
				Output->Options];
			Lookup[options,BlankDenaturationReagentTargetConcentration],
			1.Molar,
			Variables:>{options}
		],
		Example[
			{Options,BlankDenaturationReagentVolume,"Blanks: Specify a volume of the denaturing agent required to reach its final concentration in the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankDenaturationReagent->Model[Sample,"SimpleSol"],BlankDenaturationReagentVolume->10Microliter,
				Output->Options];
			Lookup[options,BlankDenaturationReagentVolume],
			10Microliter,
			Variables:>{options}
		],
		Example[
			{Options,BlankDenaturationReagentVolume,"Blanks: Specify a volume of the denaturing agent required to reach its final concentration in the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankDenaturationReagent->Model[Sample,"SimpleSol"],BlankDenaturationReagentVolume->10Microliter,
				Output->Options];
			Lookup[options,BlankDenaturationReagentTargetConcentration],
			10VolumePercent,
			Variables:>{options}
		],
		Example[
			{Options,BlankIncludeAnodicSpacer,"Blanks: Specify if an anodic spacer should be added to the MasterMix. Both acidic and alkaline carrier ampholytes may be lost in the electrolyte reservoirs due to diffusion and isotachophoresis, decreasing the resolution and detection of proteins at the extremes of the pH gradient. To reduce the loss of amopholytes, Spacers (ampholites with very low or very high pIs) can be added to buffer the loss of analytes of interest. Traditionally, Iminodiacetic acid (pI 2.2) is added as an AnodicSpacer:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankIncludeAnodicSpacer->True,
				Output->Options];
			Lookup[options,BlankIncludeAnodicSpacer],
			True,
			Variables:>{options}
		],
		Example[
			{Options,BlankAnodicSpacer,"Blanks: Specify Acidic ampholyte to include in the MasterMix.  When analyzing a protein with very acidic pI (e.g. Pepsin), one might choose to add an AnodicSpacer such as Arginine (pI 10.7), to prevent loss of signal to the anolyte reservoir:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankAnodicSpacer->Model[Sample,StockSolution, "200mM Iminodiacetic acid"],
				Output->Options];
			Lookup[options,BlankAnodicSpacer],
			ObjectReferenceP[Model[Sample,StockSolution, "200mM Iminodiacetic acid"]],
			Variables:>{options}
		],
		Example[
			{Options,BlankAnodicSpacerTargetConcentration,"Blanks: Specify a final concentration of AnodicSpacer in the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankAnodicSpacerTargetConcentration->10Millimolar,
				Output->Options];
			Lookup[options,BlankAnodicSpacerTargetConcentration],
			10Millimolar,
			Variables:>{options}
		],
		Example[
			{Options,BlankAnodicSpacerTargetConcentration,"Blanks: Specify a final concentration of AnodicSpacer in the MasterMix and calculate its volume:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankAnodicSpacerTargetConcentration->10Millimolar,
				Output->Options];
			Lookup[options,BlankAnodicSpacerVolume],
			5Microliter,
			Variables:>{options}
		],
		Example[
			{Options,BlankAnodicSpacerVolume,"Blanks: Specify a volume of AnodicSpacer stock to add to the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankAnodicSpacerVolume->10Microliter,
				Output->Options];
			Lookup[options,BlankAnodicSpacerVolume],
			10Microliter,
			Variables:>{options}
		],
		Example[
			{Options,BlankAnodicSpacerVolume,"Blanks: Specify a volume of AnodicSpacer stock to add to the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankAnodicSpacerVolume->10Microliter,
				Output->Options];
			Lookup[options,BlankAnodicSpacerTargetConcentration],
			20.Millimolar,
			Variables:>{options}
		],
		Example[
			{Options,BlankIncludeCathodicSpacer,"Blanks: Specify if a cathodic spacer should be added to the MasterMix. Both acidic and alkaline carrier ampholytes may be lost in the electrolyte reservoirs due to diffusion and isotachophoresis, decreasing the resolution and detection of proteins at the extremes of the pH gradient. To reduce the loss of amopholytes, Spacers (ampholites with very low or very high pIs) can be added to buffer the loss of analytes of interest. Traditionally, Iminodiacetic acid (pI 2.2) and Arginine (pI 10.7) are added as Spacers:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankIncludeCathodicSpacer->True,
				Output->Options];
			Lookup[options,BlankIncludeCathodicSpacer],
			True,
			Variables:>{options}
		],
		Example[
			{Options,BlankCathodicSpacer,"Blanks: Specify Basic ampholyte spacer to include in the MasterMix. When analyzing a protein with very basic pI (e.g. Cytochrome C), one might choose to add a CathodicSpacer such as Arginine (pI 10.7), to prevent loss of signal to the catholyte reservoir:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankCathodicSpacer->Model[Sample,StockSolution, "500mM Arginine"],
				Output->Options];
			Lookup[options,BlankCathodicSpacer],
			ObjectReferenceP[Model[Sample,StockSolution, "500mM Arginine"]],
			Variables:>{options}
		],
		Example[
			{Options,BlankCathodicSpacerTargetConcentration,"Blanks: Specify a concentration of Cathodic spacer in the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankCathodicSpacerTargetConcentration->10Millimolar,
				Output->Options];
			Lookup[options,BlankCathodicSpacerTargetConcentration],
			10Millimolar,
			Variables:>{options}
		],
		Example[
			{Options,BlankCathodicSpacerTargetConcentration,"Blanks: Specify a concentration of Cathodic spacer in the MasterMix and calculate its volume:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankCathodicSpacerTargetConcentration->10Millimolar,
				Output->Options];
			Lookup[options,BlankCathodicSpacerVolume],
			2Microliter,
			Variables:>{options}
		],
		Example[
			{Options,BlankCathodicSpacerVolume,"Blanks: Specify a volume of Cathodic spacer stocks to add to the MasterMix:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankCathodicSpacerVolume->10Microliter,
				Output->Options];
			Lookup[options,BlankCathodicSpacerVolume],
			10Microliter,
			Variables:>{options}
		],
		Example[
			{Options,BlankCathodicSpacerVolume,"Blanks: Specify a volume of Cathodic spacer stocks to add to the MasterMix and calculate its final concentration:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankCathodicSpacerVolume->10Microliter,
				Output->Options];
			Lookup[options,BlankCathodicSpacerTargetConcentration],
			50.Millimolar,
			Variables:>{options}
		],
		Example[
			{Options,BlankDenaturationReagentStorageCondition,"Blanks: Specify a non-default storage condition for DenaturationReagent stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankDenaturationReagentStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,BlankDenaturationReagentStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,BlankAnodicSpacerStorageCondition,"Blanks: Specify a non-default storage condition for AnodicSpacer stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankAnodicSpacerStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,BlankAnodicSpacerStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,BlankCathodicSpacerStorageCondition,"Blanks: Specify a non-default storage condition for CathodicSpacer stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankCathodicSpacerStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,BlankCathodicSpacerStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,BlankElectroosmoticFlowBlockerStorageCondition,"Blanks: Specify a non-default storage condition for CathodicSpacer stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankElectroosmoticFlowBlockerStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,BlankElectroosmoticFlowBlockerStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,BlankDiluentStorageCondition,"Blanks: Specify a non-default storage condition for Diluent of this experiment after the protocol is completed. If left unset, Diluent will be stored according to their current StorageCondition:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankDiluentStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,BlankDiluentStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,BlankStorageCondition,"Blanks: Specify a non-default storage condition for blanks of this experiment after the protocol is completed. If left unset, Diluent will be stored according to their current StorageCondition:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,BlankStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,BlankAmpholytesStorageCondition,"Blanks: Specify a non-default storage condition for ampholyte stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True, BlankAmpholytesStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,BlankAmpholytesStorageCondition],
			{Refrigerator},
			Variables:>{options}
		],
		Example[
			{Options,BlankIsoelectricPointMarkersStorageCondition,"Blanks: Specify a non-default storage condition for isoelectric point marker stocks of this experiment after the protocol is completed. If left unset, stocks will be stored according to their current StorageCondition:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True, BlankIsoelectricPointMarkersStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,BlankIsoelectricPointMarkersStorageCondition],
			{Refrigerator,Refrigerator},
			Variables:>{options}
		],
		Example[
			{Options,BlankLoadTime,"Blanks: Specify Time to load standards in MasterMix into the capillary by vacuum:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankLoadTime->55Second,
				Output->Options];
			Lookup[options,BlankLoadTime],
			55Second,
			Variables:>{options}
		],
		Example[
			{Options,BlankVoltageDurationProfile,"Blanks: Specify Series of voltages and durations to apply onto the capillary for separation. Supports up to 20 steps where each step is 0-600 minutes, and 0-5000 volts:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankVoltageDurationProfile->{{1500Volt, 1Minute}, {3000Volt, 10Minute}},
				Output->Options];
			Lookup[options,BlankVoltageDurationProfile],
			{{1500Volt, 1Minute}, {3000Volt, 10Minute}},
			Variables:>{options}
		],
		Example[
			{Options,BlankImagingMethods,"Blanks: Specify Whole capillary imaging by Either UVAbsorbance (280 nm) alone or both UVAbsorbance and Native Fluorescence (Ex 280 nm, Em 320-450nm):"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankImagingMethods->AbsorbanceAndFluorescence,
				Output->Options];
			Lookup[options,BlankImagingMethods],
			AbsorbanceAndFluorescence,
			Variables:>{options}
		],
		Example[
			{Options,BlankNativeFluorescenceExposureTime,"Blanks: Specify Exposure duration for NativeFluorescence detection:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				IncludeBlanks->True,BlankNativeFluorescenceExposureTime->{3Second, 5Second, 10Second, 20Second},
				Output->Options];
			Lookup[options,BlankNativeFluorescenceExposureTime],
			{3Second, 5Second, 10Second, 20Second},
			Variables:>{options}
		],
		(* --- Messages tests --- *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentCapillaryIsoelectricFocusing[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentCapillaryIsoelectricFocusing[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
					{"Work Surface", Object[Container, Bench, "Unit test bench for ExperimentCIEF tests " <> $SessionUUID]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				samplePackets = UploadSample[
					Model[Sample,"10 mg/mL BSA Fraction V for cIEF tests "<>$SessionUUID],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentCapillaryIsoelectricFocusing[sampleID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
					{"Work Surface", Object[Container, Bench, "Unit test bench for ExperimentCIEF tests " <> $SessionUUID]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				samplePackets = UploadSample[
					Model[Sample,"10 mg/mL BSA Fraction V for cIEF tests "<>$SessionUUID],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentCapillaryIsoelectricFocusing[containerID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages,"InputContainsTemporalLinks","Throw a message if given a temporal link:"},
			ExperimentCapillaryIsoelectricFocusing[Link[Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				Now - 1 Minute], Output->Options],
			_List,(*ObjectP[Object[Protocol, CapillaryGelElectrophoresisSDS]]*)
			Messages:>{Warning::InputContainsTemporalLinks}
		],
		Example[{Messages,"DiscardedSamples","If the provided sample is discarded, an error will be thrown:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (discarded) "<>$SessionUUID],
				Output->Options],
			_List, (*$Failed, Until resource packets are done *)
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages,"DeprecatedModels","If the provided sample has a deprecated model, an error will be thrown:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test protein 1 (deprecated) "<>$SessionUUID],
				Output->Options],
			_List, (*$Failed, Until resource packets are done *)
			Messages:>{
				Error::DeprecatedModels,
				Error::InvalidInput
			}
		],
		Example[{Messages,"CIEFIncompatibleCartridge","If the provided cartridge is not compatible with this experiment, an error will be thrown:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				Cartridge->Object[Container,ProteinCapillaryElectrophoresisCartridge,"CESDS-Plus Cartridge test Object 1 for ExperimentCIEF "<>$SessionUUID],
				Output->Options],
			_List, (*$Failed, Until resource packets are done *)
			Messages:>{
				Error::CIEFIncompatibleCartridge,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFDiscardedCartridge","If a discarded cartridge is set, raise an error:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				Cartridge ->Object[Container,ProteinCapillaryElectrophoresisCartridge,"cIEF Cartridge test discarded Object 2 ExperimentCIEF "<>$SessionUUID],
				Output->Options
			],
			_List, (*$Failed, Until resource packets are done *)
			Messages:>{
				Error::CIEFDiscardedCartridge,
				Error::InvalidOption
			}
		],
		Example[{Messages,"CIEFBlanksFalseOptionsSpecifiedError","Raise an error if IncludeBlanks was set to False while other related options have been specified for Blanks:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				IncludeBlanks->False, Blanks->Model[Sample,"Milli-Q water"],
				Output->Options],
			_List, (*$Failed, Until resource packets are done *)
			Messages:>{
				Error::CIEFBlanksFalseOptionsSpecifiedError,
				Error::InvalidOption
			}
		],
		Example[{Messages,"CIEFStandardsFalseOptionsSpecifiedError","Raise an error if IncludeStandards was set to False while other related options have been specified for Standards:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				IncludeStandards->False, Standards->Model[Sample,"Milli-Q water"],
				Output->Options],
			_List, (*$Failed, Until resource packets are done *)
			Messages:>{
				Error::CIEFStandardsFalseOptionsSpecifiedError,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFInjectionTableMismatch","If an injectionTable is set but is not compatible with samples, ladders, blanks, and standards, raise an error:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				Blanks -> Model[Sample, "Milli-Q water"],
				InjectionTable ->
					{{Blank, Model[Sample, "1% SDS in 100mM Tris, pH 9.5"], 5Microliter},
						{Sample, Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], 10Microliter},
						{Blank, Model[Sample, "1% SDS in 100mM Tris, pH 9.5"], 5Microliter}},
				Output->Options],
			_List, (*$Failed, Until resource packets are done *)
			Messages:>{
				Error::CIEFInjectionTableMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InjectionTableReplicatesSpecified","If both an injectionTable and number of replicates are specified, raise an error:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],SampleVolume->5Microliter,
				Blanks -> Model[Sample, "1% SDS in 100mM Tris, pH 9.5"],BlankVolume->30Microliter,
				NumberOfReplicates->2,
				InjectionTable ->
					{{Blank, Model[Sample, "1% SDS in 100mM Tris, pH 9.5"],30Microliter},
						{Sample, Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],5Microliter},
						{Blank, Model[Sample, "1% SDS in 100mM Tris, pH 9.5"],30Microliter}},
				Output->Options],
			_List,
			Messages:>{
				Error::InjectionTableReplicatesSpecified,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InjectionTableVolumeZero","If an injectionTable is specified with volume 0 microliter, raise an error:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],SampleVolume->5Microliter,
				InjectionTable ->
					{{Blank, Model[Sample, "1% SDS in 100mM Tris, pH 9.5"],30Microliter},
						{Sample, Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],5Microliter},
						{Blank, Model[Sample, "1% SDS in 100mM Tris, pH 9.5"],0Microliter}},
				Output->Options],
			_List,
			Messages:>{
				Error::InjectionTableVolumeZero,
				Error::InvalidOption
			}
		],
		Example[{Messages, "TooManyInjectionsCapillaryIsoelectricFocusing","If more than 100 injections are required, raise an error:"},
			ExperimentCapillaryIsoelectricFocusing[
				{Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],Object[Sample,"ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID],Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID]}, NumberOfReplicates->40,
				Blanks -> Model[Sample, "1% SDS in 100mM Tris, pH 9.5"],BlankFrequency->3,
				Output->Options],
			_List, (*$Failed, Until resource packets are done *)
			Messages:>{
				Error::TooManyInjectionsCapillaryIsoelectricFocusing,
				Error::InvalidOption
			}
		],
		Example[{Messages, "NotEnoughUsesLeftOnCIEFCartridge","If the cartridge object does not have enough uses for the stated samples, blanks, and standards, raise an error:"},
			ExperimentCapillaryIsoelectricFocusing[
				{Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],Object[Sample,"ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]}, NumberOfReplicates->5,
				Blanks -> Model[Sample, "Milli-Q water"], BlankFrequency->FirstAndLast,
				Cartridge-> Object[Container,ProteinCapillaryElectrophoresisCartridge, "cIEF Cartridge test Object 3 ExperimentCIEF (190 uses) "<>$SessionUUID],
				Output->Options
			],
			_List, (*$Failed, Until resource packets are done *)
			Messages:>{
				Error::NotEnoughUsesLeftOnCIEFCartridge,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFPreMadeMasterMixWithMakeOwnOptions","When options for both PremadeMasterMix and Make-Ones-Own mastermix are passed, raise warning and follow PremadeMaterMix:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				PremadeMasterMix -> True, PremadeMasterMixReagent -> Object[Sample,"ExperimentCIEF Test reagent "<>$SessionUUID],Denature->True,
				Output->Options
			],
			_List,
			Messages:>{Warning::CIEFPreMadeMasterMixWithMakeOwnOptions}
		],
		Example[{Messages, "CIEFPreMadeMasterMixWithMakeOwnOptions","When options for both PremadeMasterMix and Make-Ones-Own mastermix are passed, raise warning and follow PremadeMaterMix:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				PremadeMasterMix -> True,PremadeMasterMixReagent ->	Object[Sample,"ExperimentCIEF Test reagent "<>$SessionUUID],Denature->True,
				IncludeStandards -> True,StandardPremadeMasterMix -> True,
				StandardPremadeMasterMixReagent ->Object[Sample,"ExperimentCIEF Test reagent "<>$SessionUUID],StandardDenature->True,
				Output -> Options
			],
			_List,
			Messages:>{Warning::CIEFPreMadeMasterMixWithMakeOwnOptions,Warning::CIEFMissingSampleComposition}
		],
		Example[{Messages, "CIEFMissingSampleComposition","When a sample or a standard does not have a protein in their composition, a warning is raised to note that sample volume cannot be determined and is defaulted to 25% of the total volume:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 5 (100 uL) "<>$SessionUUID],
				Output -> Options
			],
			_List,
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[{Messages, "CIEFTotalVolumeNull","When a TotalVolume is specified as Null for a Standard or a blank, raise an Error:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				Blanks->{Model[Sample, "Milli-Q water"]}, BlankTotalVolume->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFTotalVolumeNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFIncludeTrueFrequencyNullError","BlankFrequency/StandardFrequency cannot be set to Null when any related options are specified:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				IncludeBlanks->True, BlankFrequency->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFIncludeTrueFrequencyNullError,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFLoadTimeNullError","BlankLoadTime/StandardLoadTime cannot be set to Null when any related options are specified:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				IncludeBlanks->True, BlankLoadTime->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFLoadTimeNullError,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFOnBoardMixingIncompatibleVolumes","When OnBoardMixing is True, raise an error if the difference between Total volume and Sample Volume is less than 100 ul:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				OnBoardMixing->True, TotalVolume->100Microliter, Output -> Options
			],
			_List,
			Messages:>{
				Warning::OnBoardMixingVolume,
				Error::CIEFOnBoardMixingIncompatibleVolumes,
				Error::InvalidOption
			}
		],
		Example[{Messages, "OnBoardMixingVolume","When OnBoardMixing is True, raise an warning if the volume in the reagent vial is too low and the method will prepare extra to account for dead volume:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				OnBoardMixing->True, Output -> Options
			],
			_List,
			Messages:>{
				Warning::OnBoardMixingVolume
			}
		],
		Example[{Messages,"CIEFMoreThanOneMasterMixWithOnBoardMixing","When OnBoardMixing is True, raise an error if more than one mastermix is required:"},
			options=ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				OnBoardMixing->True,IncludeCathodicSpacer->{True, False},
				Output->Options];
			Lookup[options,OnBoardMixing],
			True,
			Variables:>{options},
			Messages:>{
				Warning::OnBoardMixingVolume,
				Error::CIEFMoreThanOneMasterMixWithOnBoardMixing,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFimagingMethodMismatch","When both ImagingMethods and NativeFluorescenceExposureTimes are specified, raise an error if they are not compatible:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				ImagingMethods -> Absorbance, NativeFluorescenceExposureTime -> {3 Second}, Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFimagingMethodMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFInvalidVoltageDurationProfile","Raise an error if VoltageDurationProfile has more than 20 steps or none at all:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				VoltageDurationProfile->ConstantArray[{3000Volt, 1Minute},21], Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFInvalidVoltageDurationProfile,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFPremadeMasterMixReagentNull","When PremadeMasterMix is True, raise an error if no PremadeMasterMix reagent is specified:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				PremadeMasterMix-> True, PremadeMasterMixReagent->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFPremadeMasterMixReagentNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFPremadeMasterMixDilutionFactorNull","When PremadeMasterMix is True, raise an error if no PremadeMasterMix reagent dilution factor is specified:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				PremadeMasterMix-> True, PremadeMasterMixReagent->Object[Sample,"ExperimentCIEF Test reagent "<>$SessionUUID],
				PremadeMasterMixReagentDilutionFactor->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFPremadeMasterMixDilutionFactorNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFPremadeMasterMixVolumeNull","When PremadeMasterMix is True, raise an error if no PremadeMasterMix reagent volume is specified:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				PremadeMasterMix-> True, PremadeMasterMixReagent->Object[Sample,"ExperimentCIEF Test reagent "<>$SessionUUID],
				PremadeMasterMixVolume->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFPremadeMasterMixVolumeNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFPremadeMasterMixVolumeDilutionFactorMismatch","When PremadeMasterMix is True, raise an error if there is a mismatch between the PremadeMasterMix reagent specified dilution factor and volume:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				PremadeMasterMix-> True, PremadeMasterMixReagent->Object[Sample,"ExperimentCIEF Test reagent "<>$SessionUUID],
				PremadeMasterMixVolume->10Microliter,PremadeMasterMixReagentDilutionFactor->2,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFPremadeMasterMixVolumeDilutionFactorMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFPremadeMasterMixInvalidTotalVolume","When PremadeMasterMix is True, raise an error if the sum of all components' volumes is over the total volume:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				PremadeMasterMix-> True, PremadeMasterMixReagent->Object[Sample,"ExperimentCIEF Test reagent "<>$SessionUUID],
				PremadeMasterMixVolume->90Microliter,SampleVolume->20Microliter,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFPremadeMasterMixInvalidTotalVolume,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFPremadeMasterMixDiluentNull","When PremadeMasterMix is True, raise an error if no PremadeMasterMix reagent diluent is specified but the sum of all components is less than the total volume:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				PremadeMasterMix-> True, PremadeMasterMixReagent->Object[Sample,"ExperimentCIEF Test reagent "<>$SessionUUID],
				PremadeMasterMixVolume->50Microliter,PremadeMasterMixDiluent->Null, SampleVolume->20Microliter,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFPremadeMasterMixDiluentNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFMakeMasterMixDiluentNull","When PremadeMasterMix is False, raise an error if no diluent is specified but the sum of all components is less than the total volume:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				Diluent->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFMakeMasterMixDiluentNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFMakeMasterMixAmpholytesNull","When PremadeMasterMix is False, raise an error if no ampholytes are specified:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				Ampholytes->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFMakeMasterMixAmpholytesNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFMakeMasterMixAmpholyteOptionLengthsNotCompatible","When PremadeMasterMix is False, raise an error if the lengths of ampholytes matched options are not the same length:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				Ampholytes->{{Model[Sample,"Pharmalyte pH 3-10"]}}, AmpholyteVolume->{{10Microliter,5Microliter}},
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFMakeMasterMixAmpholyteOptionLengthsNotCompatible,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFMakeMasterMixAmpholyteOptionLengthsNotCompatible","When PremadeMasterMix is False, raise an error if the lengths of ampholytes matched options are not the same length:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				Ampholytes->{{Model[Sample,"Pharmalyte pH 3-10"]}}, AmpholyteTargetConcentrations->{{2VolumePercent,5VolumePercent}},
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFMakeMasterMixAmpholyteOptionLengthsNotCompatible,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFMakeMasterMixAmpholytesVolumesNull","When PremadeMasterMix is False, raise an error if ampholyte volumes are Null:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				Ampholytes->{Model[Sample,"Pharmalyte pH 3-10"]}, AmpholyteVolume->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFMakeMasterMixAmpholytesVolumesNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFMakeMasterMixAmpholytesConcentrationNull","When PremadeMasterMix is False, raise an error if ampholyte target concentrations are Null:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				Ampholytes->{Model[Sample,"Pharmalyte pH 3-10"]}, AmpholyteTargetConcentrations->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFMakeMasterMixAmpholytesConcentrationNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFMakeMasterMixAmpholytesVolumeConcentrationMismatch","When PremadeMasterMix is False, raise an error if the ampholyte volumes and target concentrations are not in agreement:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				Ampholytes->{Model[Sample,"Pharmalyte pH 3-10"]}, AmpholyteTargetConcentrations->{2VolumePercent}, AmpholyteVolume->{10Microliter},
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFMakeMasterMixAmpholytesVolumeConcentrationMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFMakeMasterMixIsoelectricPointMarkersNull","When PremadeMasterMix is False, raise an error if no ampholytes are specified:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				IsoelectricPointMarkers->Null,
					Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFMakeMasterMixIsoelectricPointMarkersNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFMakeMasterMixIsoelectricPointMarkerOptionLengthsNotCompatible","When PremadeMasterMix is False, raise an error if the lengths of IsoelectricPointMarkers matched options are not the same length:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				IsoelectricPointMarkers->{{Model[Sample,"Pharmalyte pH 3-10"]}}, IsoelectricPointMarkersVolume->{{10Microliter,5Microliter}},
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFMakeMasterMixIsoelectricPointMarkerOptionLengthsNotCompatible,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFMakeMasterMixIsoelectricPointMarkerOptionLengthsNotCompatible","When PremadeMasterMix is False, raise an error if the lengths of IsoelectricPointMarkers matched options are not the same length:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				IsoelectricPointMarkers->{{Model[Sample,"Pharmalyte pH 3-10"]}}, IsoelectricPointMarkersTargetConcentrations->{{2VolumePercent,5VolumePercent}},
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFMakeMasterMixIsoelectricPointMarkerOptionLengthsNotCompatible,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFMakeMasterMixIsoelectricPointMarkersVolumesNull","When PremadeMasterMix is False, raise an error if IsoelectricPointMarkers volumes are Null:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				IsoelectricPointMarkers->{Model[Sample,"Pharmalyte pH 3-10"]}, IsoelectricPointMarkersVolume->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFMakeMasterMixIsoelectricPointMarkersVolumesNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFMakeMasterMixIsoelectricPointMarkersConcentrationNull","When PremadeMasterMix is False, raise an error if IsoelectricPointMarkers target concentrations are Null:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				IsoelectricPointMarkers->{Model[Sample,"Pharmalyte pH 3-10"]}, IsoelectricPointMarkersTargetConcentrations->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFMakeMasterMixIsoelectricPointMarkersConcentrationNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFMakeMasterMixIsoelectricPointMarkersVolumeConcentrationMismatch","When PremadeMasterMix is False, raise an error if the IsoelectricPointMarkers volumes and target concentrations are not in agreement:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				IsoelectricPointMarkers->{Model[Sample,"Pharmalyte pH 3-10"]}, IsoelectricPointMarkersTargetConcentrations->{2VolumePercent}, IsoelectricPointMarkersVolume->{10Microliter},
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFMakeMasterMixIsoelectricPointMarkersVolumeConcentrationMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFMakeMasterMixElectroosmoticFlowBlockersNull","When PremadeMasterMix is False, raise an error if the ElectroosmoticFlowBlocker is Null:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				ElectroosmoticFlowBlocker->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFMakeMasterMixElectroosmoticFlowBlockersNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFMakeMasterMixElectroosmoticFlowBlockerComposition","When PremadeMasterMix is False, raise a warning if the composition of ElectroosmoticFlowBlocker is unknown:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				ElectroosmoticFlowBlocker->Model[Sample,"Milli-Q water"],
				Output -> Options
			],
			_List,
			Messages:>{Warning::CIEFMakeMasterMixElectroosmoticFlowBlockerComposition}
		],
		Example[{Messages, "CIEFMakeMasterMixElectroosmoticFlowBlockersVolumesNull","When PremadeMasterMix is False, raise an error if the ElectroosmoticFlowBlocker volume is Null:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				ElectroosmoticFlowBlockerVolume->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFMakeMasterMixElectroosmoticFlowBlockersVolumesNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFMakeMasterMixElectroosmoticFlowBlockersConcentrationNull","When PremadeMasterMix is False, raise an error if the ElectroosmoticFlowBlocker target concentration is Null:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				ElectroosmoticFlowBlockerTargetConcentrations->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFMakeMasterMixElectroosmoticFlowBlockersConcentrationNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFMakeMasterMixElectroosmoticFlowBlockersVolumeConcentrationMismatch","When PremadeMasterMix is False, raise an error if the ElectroosmoticFlowBlocker target concentration and volume are not in agreement:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				ElectroosmoticFlowBlockerTargetConcentrations->0.35MassPercent, ElectroosmoticFlowBlockerVolume->20Microliter,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFMakeMasterMixElectroosmoticFlowBlockersVolumeConcentrationMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFMakeMasterMixDenaturationReagentsNull","When Denature is True, raise an error if the DenaturationReagent is Null:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				Denature->True, DenaturationReagent->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFMakeMasterMixDenaturationReagentsNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFMakeMasterMixDenatureFalseOptionsSpecifiedErrors","When Denature is False, raise an error if and other denaturation related options have been set by the user:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				Denature->False, DenaturationReagent->Model[Sample,StockSolution,"10M Urea"],
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFMakeMasterMixDenatureFalseOptionsSpecifiedErrors,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFMakeMasterMixDenaturationReagentComposition","When Denature is True, raise a warning if the composition of DenaturationReagent is unknown:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				Denature->True, DenaturationReagent->Model[Sample,"Milli-Q water"],
				Output -> Options
			],
			_List,
			Messages:>{Warning::CIEFMakeMasterMixDenaturationReagentComposition}
		],
		Example[{Messages, "CIEFMakeMasterMixDenaturationReagentsVolumesNull","When Denature is True, raise an error if the DenaturationReagent volume is Null:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				Denature->True, DenaturationReagentVolume->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFMakeMasterMixDenaturationReagentsVolumesNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFMakeMasterMixDenaturationReagentsConcentrationNull","When Denature is True, raise an error if the DenaturationReagent target concentration is Null:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				Denature->True, DenaturationReagentTargetConcentration->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFMakeMasterMixDenaturationReagentsConcentrationNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFresolveableDenatureReagentConcentrationUnitMismatch","When Denature is True, If denaturation reagent's concentration is in Molar, but Target concentration is specified in Volume Percent, raise warning:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				Denature->True, DenaturationReagent-> Model[Sample, StockSolution,"10M Urea"], DenaturationReagentTargetConcentration->10VolumePercent,
				Output -> Options
			],
			_List,
			Messages:>{Warning::CIEFresolveableDenatureReagentConcentrationUnitMismatch}
		],
		Example[{Messages, "CIEFunresolveableDenatureReagentConcentrationUnitMismatch","When Denature is True, If denaturation reagent's concentration is in VolumePercent, but Target concentration is specified in Molar, raise error:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				Denature->True, DenaturationReagent-> Model[Sample, "SimpleSol"], DenaturationReagentTargetConcentration->2Molar,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFunresolveableDenatureReagentConcentrationUnitMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFMakeMasterMixDenaturationReagentsVolumeConcentrationMismatch","When Denature is True, If denaturation reagent's concentration is in VolumePercent, but Target concentration is specified in Molar, raise error:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				Denature->True, DenaturationReagent-> Model[Sample, "SimpleSol"], DenaturationReagentTargetConcentration->20VolumePercent,DenaturationReagentVolume->5Microliter,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFMakeMasterMixDenaturationReagentsVolumeConcentrationMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFMakeMasterMixAnodicSpacerFalseOptionsSpecifiedErrors","When IncludeAnodicSpacer is False, raise an error if and other anodic spacer related options have been set by the user:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				IncludeAnodicSpacer -> False, AnodicSpacer -> Model[Sample,StockSolution, "200mM Iminodiacetic acid"],
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFMakeMasterMixAnodicSpacerFalseOptionsSpecifiedErrors,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFMakeMasterMixAnodicSpacersNull","When IncludeAnodicSpacer is True, raise an error if the AnodicSpacer is Null volumes and target concentrations are not in agreement:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				IncludeAnodicSpacer->True, AnodicSpacer->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFMakeMasterMixAnodicSpacersNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFMakeMasterMixAnodicSpacerComposition","When IncludeAnodicSpacer is True, raise a warning if the composition of AnodicSpacer is unknown:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				IncludeAnodicSpacer->True, AnodicSpacer->Model[Sample,"Milli-Q water"],
				Output -> Options
			],
			_List,
			Messages:>{Warning::CIEFMakeMasterMixAnodicSpacerComposition}
		],
		Example[{Messages, "CIEFMakeMasterMixAnodicSpacersVolumesNull","When IncludeAnodicSpacer is True, raise an error if the AnodicSpacer volume is Null:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				IncludeAnodicSpacer->True, AnodicSpacerVolume->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFMakeMasterMixAnodicSpacersVolumesNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFMakeMasterMixAnodicSpacersConcentrationNull","When IncludeAnodicSpacer is True, raise an error if the AnodicSpacer target concentration is Null:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				IncludeAnodicSpacer->True, AnodicSpacerTargetConcentration->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFMakeMasterMixAnodicSpacersConcentrationNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFMakeMasterMixAnodicSpacersVolumeConcentrationMismatch","When IncludeAnodicSpacer is True, raise an error if the AnodicSpacer target concentration and volume are not in agreement:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				IncludeAnodicSpacer->True, AnodicSpacerTargetConcentration->5Millimolar, AnodicSpacerVolume->4Microliter,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFMakeMasterMixAnodicSpacersVolumeConcentrationMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFMakeMasterMixCathodicSpacerFalseOptionsSpecifiedErrors","When IncludeCathodicSpacer is False, raise an error if and other anodic spacer related options have been set by the user:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				IncludeCathodicSpacer -> False, CathodicSpacer -> Model[Sample,StockSolution, "500mM Arginine"],
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFMakeMasterMixCathodicSpacerFalseOptionsSpecifiedErrors,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFMakeMasterMixCathodicSpacersNull","When IncludeCathodicSpacer is True, raise an error if the CathodicSpacer is Null volumes and target concentrations are not in agreement:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				IncludeCathodicSpacer->True, CathodicSpacer->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFMakeMasterMixCathodicSpacersNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFMakeMasterMixCathodicSpacerComposition","When IncludeCathodicSpacer is True, raise a warning if the composition of CathodicSpacer is unknown:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				IncludeCathodicSpacer->True, CathodicSpacer->Model[Sample,"Milli-Q water"],
				Output -> Options
			],
			_List,
			Messages:>{Warning::CIEFMakeMasterMixCathodicSpacerComposition}
		],
		Example[{Messages, "CIEFMakeMasterMixCathodicSpacersVolumesNull","When IncludeCathodicSpacer is True, raise an error if the CathodicSpacer volume is Null:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				IncludeCathodicSpacer->True, CathodicSpacerVolume->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFMakeMasterMixCathodicSpacersVolumesNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFMakeMasterMixCathodicSpacersConcentrationNull","When IncludeCathodicSpacer is True, raise an error if the CathodicSpacer target concentration is Null:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				IncludeCathodicSpacer->True, CathodicSpacerTargetConcentration->Null,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFMakeMasterMixCathodicSpacersConcentrationNull,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFMakeMasterMixCathodicSpacersVolumeConcentrationMismatch","When IncludeCathodicSpacer is True, raise an error if the CathodicSpacer target concentration and volume are not in agreement:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				IncludeCathodicSpacer->True, CathodicSpacerTargetConcentration->5Millimolar, CathodicSpacerVolume->4Microliter,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFMakeMasterMixCathodicSpacersVolumeConcentrationMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CIEFSumOfVolumesOverTotalVolume","When IncludeCathodicSpacer is True, raise an error if the CathodicSpacer target concentration and volume are not in agreement:"},
			ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				SampleVolume->30Microliter, TotalVolume->100Microliter,
				Denature->True, DenaturationReagentVolume->50Microliter,
				ElectroosmoticFlowBlockerVolume->50Microliter,
				IncludeCathodicSpacer->True, CathodicSpacerVolume->20Microliter,
				Output -> Options
			],
			_List,
			Messages:>{
				Error::CIEFSumOfVolumesOverTotalVolume,
				Error::InvalidOption
			}
		],
		Example[{Messages, "NestedIndexLengthMismatch","When expanding n-multiple matched options and ExpandByLongest->False, warn that options will be expanded to match the length of the parent option:"},
			expandNestedIndexMatch[
				ExperimentCapillaryIsoelectricFocusing,
				<|Ampholytes -> {{Automatic,Automatic},{Automatic,Object[Sample,"ExperimentCIEF Test reagent "<>$SessionUUID]}}, AmpholyteTargetConcentrations -> {{4VolumePercent},{2VolumePercent}}|>,
				{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				Ampholytes,
				{Ampholytes, AmpholyteTargetConcentrations},
				ExpandByLongest -> False,
				Quiet -> False
			],
			{
				Ampholytes -> {{Automatic, Automatic}, {Automatic,Object[Sample,"ExperimentCIEF Test reagent "<>$SessionUUID]}},
				AmpholyteTargetConcentrations ->  {{4VolumePercent, 4VolumePercent},{2VolumePercent,2VolumePercent}}
			},
			Messages:>{
				Warning::NestedIndexLengthMismatch
			}
		],
		Example[{Messages, "NestedIndexLengthMismatch","When expanding n-multiple matched options and ExpandByLongest->True, warn that options will be expanded or trimmed to match the length of the parent option:"},
			expandNestedIndexMatch[
				ExperimentCapillaryIsoelectricFocusing,
				<|Ampholytes -> {{Automatic,Automatic},{Automatic}}, AmpholyteTargetConcentrations -> {{4VolumePercent},{2VolumePercent,2VolumePercent}}|>,
				{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				Ampholytes,
				{Ampholytes, AmpholyteTargetConcentrations},
				ExpandByLongest -> True,
				Quiet -> False
			],
			{
				Ampholytes -> {{Automatic, Automatic}, {Automatic,Automatic}},
				AmpholyteTargetConcentrations ->  {{4VolumePercent, 4VolumePercent},{2VolumePercent,2VolumePercent}}
			},
			Messages:>{
				Warning::NestedIndexLengthMismatch
			}
		],
		Example[{Messages, "ExpandedNestedIndexLengthMismatch","When expanding n-multiple matched options and ExpandByLongest->False, raise error if the dependent option is longer than the parent option:"},
			expandNestedIndexMatch[
				ExperimentCapillaryIsoelectricFocusing,
				<|Ampholytes -> {{Automatic,Automatic},{Automatic}}, AmpholyteTargetConcentrations -> {{4VolumePercent},{2VolumePercent,2VolumePercent}}|>,
				{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				Ampholytes,
				{Ampholytes, AmpholyteTargetConcentrations},
				ExpandByLongest -> False,
				Quiet -> False
			],
			{
				Ampholytes -> {{Automatic, Automatic}, {Automatic}},
				AmpholyteTargetConcentrations ->  {{4VolumePercent, 4VolumePercent},{2VolumePercent,2VolumePercent}}
			},
			Messages:>{
				Error::ExpandedNestedIndexLengthMismatch
			}
		],
		(* --- shared options --- *)
		Example[{Options, Template, "Specify a protocol on whose options to Template off of in the new experiment:"},
			ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
				Template -> Object[Protocol, CapillaryIsoelectricFocusing, "CIEF Protocol 1 "<>$SessionUUID, UnresolvedOptions]],
			ObjectP[Object[Protocol, CapillaryIsoelectricFocusing]]
		],
		Example[{Options, Template, "Specify a protocol on whose options to Template off of in the new experiment:"},
			Download[
				ExperimentCapillaryIsoelectricFocusing[{Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Object[Sample, "ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID]},
					Template -> Object[Protocol, CapillaryIsoelectricFocusing, "CIEF Protocol 1 "<>$SessionUUID, UnresolvedOptions]],
				{TotalVolumes, DenaturationReagentTargetConcentrations}
			],
			{
				{150Microliter, 150Microliter},
				{4Molar, 4Molar}
			},
			EquivalenceFunction -> Equal
		],
		Example[{Options, Name, "Provide a name for the protocol:"},
			options=ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				Name -> "CIEF protocol with Test Sample 1",
				Output->Options
			];
			Lookup[options, Name],
			"CIEF protocol with Test Sample 1",
			Variables :> {options}
		],
		(* --- Sample prep option tests --- *)
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentCapillaryIsoelectricFocusing[
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
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[{Options, PreparatoryUnitOperations, "Use the PreparatoryUnitOperations option to prepare samples from models before the experiment is run:"},
			options = ExperimentCapillaryIsoelectricFocusing["MyProteinMix",
				PreparatoryUnitOperations -> {
					LabelContainer[Label -> "MyProteinMix", Container -> Model[Container,Vessel,"New 0.5mL Tube with 2mL Tube Skirt"]],
					Transfer[Source -> Model[Sample, "Milli-Q water"],Destination -> "MyProteinMix", Amount -> 100 Microliter]},
				Output -> Options
			];
			Lookup[options, PreparatoryUnitOperations],
			{SamplePreparationP..},
			Variables :> {options},
			Messages:>{Warning::CIEFMissingSampleComposition}
		],
		Example[{Options, Incubate, "Set the Incubate option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				Incubate -> True, Output -> Options];
			Lookup[options, Incubate],
			True,
			Variables :> {options}
		],
		Example[{Options, IncubationTemperature, "Set the IncubationTemperature option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				IncubationTemperature -> 40*Celsius, Output -> Options];
			Lookup[options, IncubationTemperature],
			40*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationTime, "Set the IncubationTime option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				IncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, IncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxIncubationTime, "Set the MaxIncubationTime option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				MaxIncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, MaxIncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationInstrument, "Set the IncubationInstrument option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				IncubationInstrument -> Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"],
				Output -> Options];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"]],
			Variables :> {options}
		],
		Example[{Options, AnnealingTime, "Set the AnnealingTime option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				AnnealingTime -> 40*Minute, Output -> Options];
			Lookup[options, AnnealingTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquot, "Set the IncubateAliquot option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				IncubateAliquot -> 80*Microliter, Output -> Options];
			Lookup[options, IncubateAliquot],
			80*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotContainer, "Set the IncubateAliquotContainer option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test reagent "<>$SessionUUID],
				IncubateAliquotContainer -> Model[Container, Plate, "96-Well Full-Skirted PCR Plate"],
				Output -> Options];
			Lookup[options, IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Plate, "96-Well Full-Skirted PCR Plate"]]},
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotDestinationWell, "Set the IncubateAliquotDestinationWell option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				IncubateAliquotContainer -> Model[Container, Plate, "96-Well Full-Skirted PCR Plate"],
				IncubateAliquotDestinationWell -> "A2", Output -> Options];
			Lookup[options, IncubateAliquotDestinationWell],
			"A2",
			Variables :> {options}
		],
		Example[{Options, Mix, "Set the Mix option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				Mix -> True, Output -> Options];
			Lookup[options, Mix],
			True,
			Variables :> {options}
		],
		Example[{Options, MixType, "Set the MixType option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				MixType -> Shake, Output -> Options];
			Lookup[options, MixType],
			Shake,
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Set the MixUntilDissolved option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				MixUntilDissolved -> True, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options}
		],
		(* centrifuge options *)
		Example[{Options, Centrifuge, "Set the Centrifuge option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (20 mL) "<>$SessionUUID],
				Centrifuge -> True, Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options}
		],
		Example[{Options, CentrifugeInstrument, "Set the CentrifugeInstrument option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (20 mL) "<>$SessionUUID],
				Centrifuge->True,CentrifugeTime -> 40*Minute, CentrifugeTemperature -> 10 Celsius,
				CentrifugeIntensity -> 1000*RPM,CentrifugeInstrument -> Model[Instrument, Centrifuge, "Avanti J-15R"],
				Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Avanti J-15R"]],
			Variables :> {options}
		],
		Example[{Options, CentrifugeIntensity, "Set the CentrifugeIntensity option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (20 mL) "<>$SessionUUID],
				CentrifugeTime -> 40*Minute, CentrifugeTemperature -> 10 Celsius,
				CentrifugeIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTime, "Set the CentrifugeTime option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (20 mL) "<>$SessionUUID],
				CentrifugeTime -> 40*Minute, Output -> Options];
			Lookup[options, CentrifugeTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTemperature, "Set the CentrifugeTemperature option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (20 mL) "<>$SessionUUID],
				CentrifugeTime -> 40*Minute, CentrifugeTemperature -> 10 Celsius, Output -> Options];
			Lookup[options, CentrifugeTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquot, "Set the CentrifugeAliquot option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (20 mL) "<>$SessionUUID],
				Centrifuge->True,CentrifugeTime -> 40*Minute, CentrifugeTemperature -> 10 Celsius,
				CentrifugeIntensity -> 1000*RPM, CentrifugeAliquot -> 1Milliliter, Output -> Options];
			Lookup[options, CentrifugeAliquot],
			1Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotContainer, "Set the CentrifugeAliquotContainer option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test reagent "<>$SessionUUID],
				CentrifugeAliquotContainer -> Model[Container,Vessel,"1.5mL Tube with 2mL Tube Skirt"],
				Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectReferenceP[Model[Container,Vessel,"1.5mL Tube with 2mL Tube Skirt"]]},
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotDestinationWell, "Set the CentrifugeAliquotDestinationWell option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (20 mL) "<>$SessionUUID],
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
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				Filtration -> True, Output -> Options];
			Lookup[options, Filtration],
			True,
			Variables :> {options}
		],
		Example[{Options, FiltrationType, "Set the FiltrationType option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				FiltrationType -> Syringe, Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options}
		],
		Example[{Options, FilterInstrument, "Set the FilterInstrument option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"],
				Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
			Variables :> {options}
		],
		Example[{Options, Filter, "Set the Filter option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				Filter -> Model[Item, Filter, "id:n0k9mG8Kqrwp"],
				Output -> Options];
			Lookup[options, Filter],
			ObjectReferenceP[Model[Item, Filter, "id:n0k9mG8Kqrwp"]],
			Variables :> {options}
		],
		Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentFPLC[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID], FilterPoreSize -> 0.22 * Micrometer, Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22 * Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterMaterial, "Set the FilterMaterial option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				FilterMaterial -> PTFE, AliquotAmount -> 100*Microliter, Output -> Options];
			Lookup[options, FilterMaterial],
			PTFE,
			Variables :> {options}
		],
		Example[{Options, PrefilterMaterial, "Set the PrefilterMaterial option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (20 mL) "<>$SessionUUID],
				FilterMaterial -> PES, PrefilterMaterial -> Null, AliquotAmount -> 100*Microliter, Output -> Options];
			Lookup[options, PrefilterMaterial],
			Null,
			Variables :> {options}
		],
		Example[{Options, PrefilterPoreSize, "Set the PrefilterPoreSize option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (20 mL) "<>$SessionUUID],
				FilterMaterial -> PTFE, PrefilterPoreSize -> 1.*Micrometer, AliquotAmount -> 100*Microliter, Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1.*Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterSyringe, "Set the FilterSyringe option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (20 mL) "<>$SessionUUID],
				FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "id:AEqRl9Kz1VD1"],
				Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "id:AEqRl9Kz1VD1"]],
			Variables :> {options}
		],
		Example[{Options, FilterHousing, "Set the FilterHousing option :"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (20 mL) "<>$SessionUUID],
				FiltrationType -> PeristalticPump, FilterHousing -> Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"], Output -> Options];
			Lookup[options, FilterHousing],
			ObjectP[Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterIntensity, "Set the FilterIntensity option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				FiltrationType -> Centrifuge, FilterIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, FilterIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTime, "Set the FilterTime option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				FiltrationType -> Centrifuge, FilterTime -> 20*Minute, Output -> Options];
			Lookup[options, FilterTime],
			20*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTemperature, "Set the FilterTemperature option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				FiltrationType -> Centrifuge, FilterTemperature -> 10*Celsius, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, FilterTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],(* we will revisit this and change FilterSterile to make better sense with this task https://app.asana.com/1/84467620246/task/1209775340905665?focus=true
		Example[{Options, FilterSterile, "Set the FilterSterile option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				FilterSterile -> True, Output -> Options];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options}
		],*)
		Example[{Options, FilterAliquot, "Set the FilterAliquot option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				FilterAliquot -> 80*Microliter, Output -> Options];
			Lookup[options, FilterAliquot],
			80*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterAliquotContainer, "Set the FilterAliquotContainer option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				FilterAliquotContainer -> Model[Container, Plate, "96-Well Full-Skirted PCR Plate"],
				Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Plate, "96-Well Full-Skirted PCR Plate"]]},
			Variables :> {options}
		],
		Example[{Options, FilterAliquotDestinationWell, "Set the FilterAliquotDestinationWell option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				FilterAliquotContainer -> Model[Container, Plate, "96-Well Full-Skirted PCR Plate"],
				FilterAliquotDestinationWell -> "A2", Output -> Options];
			Lookup[options, FilterAliquotDestinationWell],
			"A2",
			Variables :> {options}
		],
		Example[{Options, FilterContainerOut, "Set the FilterContainerOut option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				FilterContainerOut -> Model[Container, Plate, "96-Well Full-Skirted PCR Plate"],
				Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Plate, "96-Well Full-Skirted PCR Plate"]]},
			Variables :> {options}
		],
		(* aliquot options *)
		Example[{Options, Aliquot, "Set the Aliquot option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				Aliquot -> True, Output -> Options];
			Lookup[options, Aliquot],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotAmount, "Set the AliquotAmount option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				AliquotAmount -> 0.08*Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AssayVolume, "Set the AssayVolume option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				AssayVolume -> 0.08*Milliliter, Output -> Options];
			Lookup[options, AssayVolume],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "Set the TargetConcentration option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				TargetConcentration -> 10*Milligram/Milliliter, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, TargetConcentration],
			10*Milligram/Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentrationAnalyte, "Set the TargetConcentrationAnalyte option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				TargetConcentration -> 1*Milligram/Milliliter, TargetConcentrationAnalyte -> Model[Molecule, Protein, "id:o1k9jAGP83Ba"],
				AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectP[Model[Molecule, Protein, "id:o1k9jAGP83Ba"]],
			Variables :> {options}
		],
		Example[{Options, ConcentratedBuffer, "Set the ConcentratedBuffer option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AliquotAmount -> 50*Microliter, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "Set the BufferDilutionFactor option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AliquotAmount -> 50*Microliter, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "Set the BufferDiluent option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				BufferDiluent -> Model[Sample, "Milli-Q water"],
				BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AliquotAmount -> 50*Microliter, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "Set the AssayBuffer option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AliquotAmount -> 50*Microliter, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "Set the AliquotSampleStorageCondition option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, ConsolidateAliquots, "Set the ConsolidateAliquots option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Set the AliquotPreparation option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, AliquotContainer, "Set the AliquotContainer option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				AliquotContainer -> Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
				Output -> Options];
			Lookup[options, AliquotContainer],
			{{1, ObjectReferenceP[Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"]]}},
			Variables :> {options}
		],
		Example[{Options, DestinationWell, "Set the DestinationWell option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				DestinationWell -> "A1", Output -> Options];
			Lookup[options, DestinationWell],
			{"A1"},
			Variables :> {options}
		],
		Example[{Options, ImageSample, "Set the ImageSample option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				ImageSample -> True, Output -> Options];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options, MeasureWeight, "Set the MeasureWeight option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
				MeasureWeight -> True, Output -> Options];
			Lookup[options, MeasureWeight],
			True,
			Variables :> {options}
		],
		Example[{Options, MeasureVolume, "Set the MeasureVolume option:"},
			options = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				MeasureVolume -> True, Output -> Options];
			Lookup[options, MeasureVolume],
			True,
			Variables :> {options}
		],
		Example[{Options, Output, "Simulation is returned when Output-> Simulation is specified:"},
			simulation = ExperimentCapillaryIsoelectricFocusing[Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
				Output -> Simulation];
			simulation,
			SimulationP,
			Variables:>{simulation}
		],
		Test["Nested index-matched options expand appropriately:",
			protocol = ExperimentCapillaryIsoelectricFocusing[
				Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) " <> $SessionUUID],
				IsoelectricPointMarkers -> {{ Model[Sample, StockSolution, "Resuspended cIEF pI Marker - 4.05"],Model[Sample, StockSolution, "Resuspended cIEF pI Marker - 9.50"] }},
				IsoelectricPointMarkersVolume -> {{ 2 Microliter,2 Microliter }},
				IncludeBlanks -> True,BlankFrequency -> First,Blanks -> Model[Sample, "LCMS Grade Water"],
				BlankIsoelectricPointMarkers -> {{ Model[Sample, StockSolution, "Resuspended cIEF pI Marker - 4.05"],Model[Sample, StockSolution, "Resuspended cIEF pI Marker - 9.50"] }},
				BlankIsoelectricPointMarkersVolume -> {{ 2 Microliter,2 Microliter }}
			];
			Download[protocol,{
				IsoelectricPointMarkers, IsoelectricPointMarkersVolumes, IsoelectricPointMarkersTargetConcentrations,
				BlankIsoelectricPointMarkers, BlankIsoelectricPointMarkersVolumes, BlankIsoelectricPointMarkersTargetConcentrations
			}],
			{
				{{ObjectP[Model[Sample, StockSolution, "id:M8n3rx0xl4p9"]], ObjectP[Model[Sample, StockSolution, "id:n0k9mG8GAJ3r"]]}},
				{{2Microliter,2Microliter}},
				{{2VolumePercent,2VolumePercent}},
				{{ObjectP[Model[Sample, StockSolution, "id:M8n3rx0xl4p9"]], ObjectP[Model[Sample, StockSolution, "id:n0k9mG8GAJ3r"]]}},
				{{2Microliter,2Microliter}},
				{{2VolumePercent,2VolumePercent}}
			},
			Variables:>{protocol},
			EquivalenceFunction->MatchQ
		],
		Test["Deal with Nulls with correct listiness for Ampholytes and IsoelectricPointMarkers:",
			Download[
				ExperimentCapillaryIsoelectricFocusing[{Object[Sample,
					"ExperimentCIEF Test sample 1 (100 uL) " <> $SessionUUID],
					Object[Sample,
						"ExperimentCIEF Test sample 2 (100 uL) " <> $SessionUUID]},
					PremadeMasterMix -> True,
					PremadeMasterMixReagent ->
						Object[Sample, "ExperimentCIEF Test reagent " <> $SessionUUID],
					Ampholytes -> {Null, Null},
					IsoelectricPointMarkers -> {Null, Null}],
				{Ampholytes, IsoelectricPointMarkers}
			],
			{
				{{Null}, {Null}},
				{{Null}, {Null}}
			}
		]
	},
	Parallel->True,
	Stubs:>{ (* Set global Variables *)
		$EmailEnabled=False,
		$AllowSystemsProtocols=True
	},
	SetUp:>( (* before and after EVERY test *)
		$CreatedObjects={};
		ClearMemoization[];

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Off[Warning::AliquotRequired];
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
					Object[Container,Bench,"Unit test bench for ExperimentCIEF tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 1 for ExperimentCIEF tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 2 for ExperimentCIEF tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 3 for ExperimentCIEF tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 4 for ExperimentCIEF tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 4a for ExperimentCIEF tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 5 for ExperimentCIEF tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 6 for ExperimentCIEF tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 7 for ExperimentCIEF tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 8 for ExperimentCIEF tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 9 for ExperimentCIEF tests "<>$SessionUUID],
					Object[Container,Plate,"Unit test container 10 for ExperimentCIEF tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 12 for ExperimentCIEF tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 13 for ExperimentCIEF tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 14 for ExperimentCIEF tests "<>$SessionUUID],
					Model[Sample,"Unit test Model for ExperimentCIEF (deprecated) "<>$SessionUUID ],
					Model[Sample,"10 mg/mL BSA Fraction V for cIEF tests "<>$SessionUUID],
					Model[Sample,"10 mg/mL bActin for cIEF tests "<>$SessionUUID],
					Model[Sample,"0.24 mM bActin "<>$SessionUUID],
					Model[Sample,"0.5% SDS in 100mM Tris, pH 9.5 "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test protein 1 (deprecated) "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test sample 1 (discarded) "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test reagent "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF IgG Standard "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test sample 1 (20 mL) "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test sample 4 (250 uL) "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test sample 5 (100 uL) "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF model-less Test sample 5 (100 uL) "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test Unit test anolyte "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test Unit test catholyte "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test Unit test 0.5% MC "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test Unit test FL std "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test Unit test urea "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test Unit test ampholyte "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test Unit test piMarker 1 "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test Unit test piMarker 2 "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test Unit test piMarker 3 "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test Unit test piMarker 4 "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test Unit test piMarker 5 "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test Unit test Arginine "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test Unit test 1% MC "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test Unit test std peptide mix "<>$SessionUUID],
					Object[Container,ProteinCapillaryElectrophoresisCartridge,"CESDS-Plus Cartridge test Object 1 for ExperimentCIEF "<>$SessionUUID],
					Object[Container,ProteinCapillaryElectrophoresisCartridge,"cIEF Cartridge test discarded Object 2 ExperimentCIEF "<>$SessionUUID],
					Object[Container,ProteinCapillaryElectrophoresisCartridge,"cIEF Cartridge test Object 3 ExperimentCIEF (190 uses) "<>$SessionUUID],
					Object[Container,ProteinCapillaryElectrophoresisCartridge,"cIEF Cartridge test Object 1 for ExperimentCIEF "<>$SessionUUID],

					Object[Protocol, CapillaryIsoelectricFocusing, "CIEF Protocol 1 "<>$SessionUUID],
					Lookup[Object[Protocol, CapillaryIsoelectricFocusing, "CIEF Protocol 1 "<>$SessionUUID], {ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs,DatabaseMemberQ[objs]];
			EraseObject[existingObjs,Force->True,Verbose->False] (* make sure nothing is left over from previous test, cleanup whatever was left *)
		];
		Block[{$AllowSystemsProtocols=True},(* must use Block here, rather than With, With wont set it back to original value *)
			Module[
				{testBench,container,container2,container3,container4,container5,sampleModel4,container4a,
					sample,sample2,sample3,sample4,sample5,container6,sample6,container7,sample7,container8,sample8,container10,
					sampleModel,sampleModel1,sampleModel2,sampleModel3,container9,sample9,sample10,cartridge3,cartridge4,
					cartridge1,cartridge2,allObjects, anolyte,piMarker3,piMarker4,std,piMarker5,
					catholyte,mc05,flx,urea,ampholyte,piMarker1,piMarker2,arg,mc1,sample10modelless,fakeProtocol1,completeThefakeProtocol,
					fakeProtSubObjs,container12,container13,container14,clearCaps,pressureCaps},

				(* before everything we make sure the instrument is clear of anything. we do that only if we're not on production to avoid unfortunate mistakes *)
				(* TODO: make fake instrument object *)
				If[!ProductionQ[],
					Upload[<|Object->Object[Instrument, ProteinCapillaryElectrophoresis, "Maurice"], Replace[Contents]->{}|>]
				];

				sampleModel=UploadSampleModel["Unit test Model for ExperimentCIEF (deprecated) "<>$SessionUUID,
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
				sampleModel1=UploadSampleModel["10 mg/mL BSA Fraction V for cIEF tests "<>$SessionUUID,
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
				sampleModel2=UploadSampleModel["10 mg/mL bActin for cIEF tests "<>$SessionUUID,
					Composition->{
						{100 VolumePercent,Model[Molecule,"Water"]},
						{10 Milligram/Milliliter,Model[Molecule,Protein,"BActin"]}
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
				sampleModel3=UploadSampleModel[ "0.24 mM bActin "<>$SessionUUID,
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
				sampleModel4=UploadSampleModel["0.5% SDS in 100mM Tris, pH 9.5 "<>$SessionUUID,
					Composition -> {{Quantity[100, "Millimolar"],
						Link[Model[Molecule, "id:01G6nvwRWR0d"],
							"01G6nv1ZlzO7"]}, {Quantity[0.5, IndependentUnit["MassPercent"]],
						Link[Model[Molecule, "id:Y0lXejMq5eRl"], "1ZA60vZdXlGw"]}},
					Expires -> True,
					ShelfLife -> Quantity[365.`, "Days"],
					UnsealedShelfLife->2 Week,
					DOTHazardClass -> "Class 0",
					State -> Liquid, BiosafetyLevel -> "BSL-1",
					MSDSFile ->
						Link[Object[EmeraldCloudFile, "id:8qZ1VW0rd17n"], "dORYzZOEpwaR"],
					Flammable -> False,
					IncompatibleMaterials -> {None},
					DefaultStorageCondition ->
						Link[Model[StorageCondition, "id:N80DNj1r04jW"]]
				];
				{
					testBench,
					cartridge1,
					cartridge2,
					cartridge3,
					cartridge4
				}=Upload[{
					<|
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name -> "Unit test bench for ExperimentCIEF tests " <> $SessionUUID,
						DeveloperObject -> True,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Site -> Link[$Site]
					|>,
					<|
						Name-> "CESDS-Plus Cartridge test Object 1 for ExperimentCIEF "<>$SessionUUID,
						Type->Object[Container,ProteinCapillaryElectrophoresisCartridge],
						Model-> Link[Model[Container,ProteinCapillaryElectrophoresisCartridge, "CESDS-Plus"],Objects],
						NumberOfUses->75,
						DeveloperObject->True,
						Status->Available,
						Site -> Link[$Site]
					|>,
					<|
						Name->"cIEF Cartridge test Object 1 for ExperimentCIEF "<>$SessionUUID,
						Type->Object[Container,ProteinCapillaryElectrophoresisCartridge],
						Model-> Link[Model[Container,ProteinCapillaryElectrophoresisCartridge, "cIEF"],Objects],
						NumberOfUses->25,
						DeveloperObject->True,
						Status->Available,
						Site -> Link[$Site]
					|>,
					<|
						Name-> "cIEF Cartridge test discarded Object 2 ExperimentCIEF "<>$SessionUUID,
						Type->Object[Container,ProteinCapillaryElectrophoresisCartridge],
						Model-> Link[Model[Container,ProteinCapillaryElectrophoresisCartridge, "cIEF"],Objects],
						NumberOfUses->25,
						Status->Discarded,
						DeveloperObject->True,
						Site -> Link[$Site]
					|>,
					<|
						Name-> "cIEF Cartridge test Object 3 ExperimentCIEF (190 uses) "<>$SessionUUID,
						Type->Object[Container,ProteinCapillaryElectrophoresisCartridge],
						Model-> Link[Model[Container,ProteinCapillaryElectrophoresisCartridge, "cIEF"],Objects],
						NumberOfUses->190,
						DeveloperObject->True,
						Status->Available,
						Site -> Link[$Site]
					|>
				}];

				{
					container,
					container2,
					container3,
					container4,
					container4a,
					container5,
					container6,
					container7,
					container8,
					container9,
					container10,
					container12,
					container13,
					container14
				}=UploadSample[
					{
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"]
					},
					{
						{"Work Surface",testBench},
						{"Work Surface",testBench},
						{"Work Surface",testBench},
						{"Work Surface",testBench},
						{"Work Surface",testBench},
						{"Work Surface",testBench},
						{"Work Surface",testBench},
						{"Work Surface",testBench},
						{"Work Surface",testBench},
						{"Work Surface",testBench},
						{"Work Surface",testBench},
						{"Work Surface",testBench},
						{"Work Surface",testBench},
						{"Work Surface",testBench}
					},
					Status->Available,
					Name->{
						"Unit test container 1 for ExperimentCIEF tests "<>$SessionUUID,
						"Unit test container 2 for ExperimentCIEF tests "<>$SessionUUID,
						"Unit test container 3 for ExperimentCIEF tests "<>$SessionUUID,
						"Unit test container 4 for ExperimentCIEF tests "<>$SessionUUID,
						"Unit test container 4a for ExperimentCIEF tests "<>$SessionUUID,
						"Unit test container 5 for ExperimentCIEF tests "<>$SessionUUID,
						"Unit test container 6 for ExperimentCIEF tests "<>$SessionUUID,
						"Unit test container 7 for ExperimentCIEF tests "<>$SessionUUID,
						"Unit test container 8 for ExperimentCIEF tests "<>$SessionUUID,
						"Unit test container 9 for ExperimentCIEF tests "<>$SessionUUID,
						"Unit test container 10 for ExperimentCIEF tests "<>$SessionUUID,
						"Unit test container 12 for ExperimentCIEF tests "<>$SessionUUID,
						"Unit test container 13 for ExperimentCIEF tests "<>$SessionUUID,
						"Unit test container 14 for ExperimentCIEF tests "<>$SessionUUID
					}
				];

				{
					sample,
					sample2,
					sample3,
					sample4,
					sample5,
					sample6,
					sample7,
					sample8,
					sample9,
					sample10,
					sample10modelless,
					anolyte,
					catholyte,
					mc05,
					flx,
					urea,
					ampholyte,
					piMarker1,
					piMarker2,
					piMarker3,
					piMarker4,
					piMarker5,
					arg,
					mc1,
					std
				}=UploadSample[
					{
						Model[Sample,"10 mg/mL BSA Fraction V for cIEF tests "<>$SessionUUID],
						Model[Sample,"Unit test Model for ExperimentCIEF (deprecated) "<>$SessionUUID],
						Model[Sample,"10 mg/mL BSA Fraction V for cIEF tests "<>$SessionUUID],
						Model[Sample,"10 mg/mL bActin for cIEF tests "<>$SessionUUID],
						Model[Sample,"0.24 mM bActin "<>$SessionUUID],
						Model[Sample,"10 mg/mL bActin for cIEF tests "<>$SessionUUID],
						Model[Sample,StockSolution, "Resuspended cIEF System Suitability Peptide Panel"],
						Model[Sample,"10 mg/mL BSA Fraction V for cIEF tests "<>$SessionUUID],
						Model[Sample,"10 mg/mL BSA Fraction V for cIEF tests "<>$SessionUUID],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"10 mg/mL bActin for cIEF tests "<>$SessionUUID],
						Model[Sample, "0.08M Phosphoric Acid in 0.1% Methyl Cellulose"],
						Model[Sample, "0.1M Sodium Hydroxide in 0.1% Methyl Cellulose"],
						Model[Sample, "0.5% Methyl Cellulose"],
						Model[Sample, "cIEF Fluorescence Calibration Standard"],
						Model[Sample, StockSolution, "10M Urea"],
						Model[Sample, "Pharmalyte pH 3-10"],
						Model[Sample, StockSolution, "Resuspended cIEF pI Marker - 4.05"],
						Model[Sample, StockSolution, "Resuspended cIEF pI Marker - 9.99"],
						Model[Sample, StockSolution, "Resuspended cIEF pI Marker - 6.14"],
						Model[Sample,StockSolution, "Resuspended cIEF pI Marker - 8.40"],
						Model[Sample,StockSolution, "Resuspended cIEF pI Marker - 10.17"],
						Model[Sample, StockSolution, "500mM Arginine"],
						Model[Sample, "1% Methyl Cellulose"],
						Model[Sample, StockSolution, "Resuspended cIEF System Suitability Peptide Panel"]

					},
					{
						{"A1",container},
						{"A1",container2},
						{"A1",container3},
						{"A1",container4},
						{"A1",container5},
						{"A1",container6},
						{"A1",container7},
						{"A1",container8},
						{"A1",container9},
						{"B1",container10},
						{"B2",container10},
						{"A1",container12},
						{"A1",container13},
						{"A1",container14},
						{"A5",container10},
						{"A6",container10},
						{"A7",container10},
						{"A8",container10},
						{"A9",container10},
						{"B8",container10},
						{"B9",container10},
						{"A10",container10},
						{"A11",container10},
						{"A12",container10},
						{"B12",container10}

					},
					InitialAmount->{
						100*Microliter,
						100*Microliter,
						100*Microliter,
						100*Microliter,
						100*Microliter,
						1500*Microliter,
						1500*Microliter,
						20*Milliliter,
						250*Microliter,
						100*Microliter,
						100*Microliter,
						20Milliliter,
						20Milliliter,
						20Milliliter,
						2Milliliter,
						2Milliliter,
						2Milliliter,
						2Milliliter,
						2Milliliter,
						2Milliliter,
						2Milliliter,
						2Milliliter,
						2Milliliter,
						2Milliliter,
						2Milliliter
					},
					Name->{
						"ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID,
						"ExperimentCIEF Test protein 1 (deprecated) "<>$SessionUUID,
						"ExperimentCIEF Test sample 1 (discarded) "<>$SessionUUID ,
						"ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID,
						"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID,
						"ExperimentCIEF Test reagent "<>$SessionUUID,
						"ExperimentCIEF IgG Standard "<>$SessionUUID,
						"ExperimentCIEF Test sample 1 (20 mL) "<>$SessionUUID,
						"ExperimentCIEF Test sample 4 (250 uL) "<>$SessionUUID,
						"ExperimentCIEF Test sample 5 (100 uL) "<>$SessionUUID,
						"ExperimentCIEF model-less Test sample 5 (100 uL) "<>$SessionUUID,
						"ExperimentCIEF Test Unit test anolyte "<>$SessionUUID,
						"ExperimentCIEF Test Unit test catholyte "<>$SessionUUID,
						"ExperimentCIEF Test Unit test 0.5% MC "<>$SessionUUID,
						"ExperimentCIEF Test Unit test FL std "<>$SessionUUID,
						"ExperimentCIEF Test Unit test urea "<>$SessionUUID,
						"ExperimentCIEF Test Unit test ampholyte "<>$SessionUUID,
						"ExperimentCIEF Test Unit test piMarker 1 "<>$SessionUUID,
						"ExperimentCIEF Test Unit test piMarker 2 "<>$SessionUUID,
						"ExperimentCIEF Test Unit test piMarker 3 "<>$SessionUUID,
						"ExperimentCIEF Test Unit test piMarker 4 "<>$SessionUUID,
						"ExperimentCIEF Test Unit test piMarker 5 "<>$SessionUUID,
						"ExperimentCIEF Test Unit test Arginine "<>$SessionUUID,
						"ExperimentCIEF Test Unit test 1% MC "<>$SessionUUID,
						"ExperimentCIEF Test Unit test std peptide mix "<>$SessionUUID

					},
					Status->Available,
					StorageCondition->{
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]]
					}
				];

				(* upload other items needed for testing the protocol All of those are Developer object -> True AwaitingStorageUpdate-> Null so that they are not treated as real objects in lab if messed something up *)
				allObjects=Cases[Flatten[{
					container,container2,container3,container4,container5,sample,sample2,sample4,sample10,
					sample5,cartridge1,cartridge2,container6,sample6,container7,container8,sample8,container9,sample9,
					container10,container12,container13,container14,container4a,anolyte,catholyte,mc05,flx,urea,ampholyte,
					arg,mc1,sample10modelless, clearCaps,pressureCaps
				}],ObjectP[]];

				Upload[<|Object->#,DeveloperObject->True,AwaitingStorageUpdate->Null|> &/@allObjects];
				Upload[Cases[Flatten[{
					<|Object->sample2, Replace[Composition]->{{10 Milligram/Milliliter,Link[Model[Molecule,Protein,"id:n0k9mG8npLLw"]],Now}}|>,
					<|Object->sample3,Status->Discarded,Model->Null|>,
					<|Object->sampleModel,Deprecated->True,DeveloperObject->True|>,
					<|Object->sample10modelless,Model->Null,DeveloperObject->True|>,
					<|Object->container4a,Replace[Contents]->{}, Status->Available, Product->Link[Object[Product, "id:8qZ1VWNwNNAn"], Samples],DeveloperObject->True|>,
					<|Object->sample7,DeveloperObject->True,Replace[Composition]->{{10 Milligram/Milliliter,Link[Model[Molecule,Protein,"id:n0k9mG8npLLw"]],Now}}|>
				}],PacketP[]]];

				(* template option sets options from previous protocol *)
				fakeProtocol1 = ExperimentCapillaryIsoelectricFocusing[Object[Sample, "ExperimentCIEF Test sample 1 (100 uL) "<>$SessionUUID], Name -> "CIEF Protocol 1 "<>$SessionUUID, Confirm -> True, Denature->True, TotalVolume->150Microliter];
				completeThefakeProtocol = UploadProtocolStatus[fakeProtocol1, Completed, FastTrack -> True];
				fakeProtSubObjs = Flatten[Download[fakeProtocol1, {ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]];
				Upload[<|Object -> #, DeveloperObject -> True|>& /@ Cases[Flatten[{fakeProtocol1, fakeProtSubObjs}], ObjectP[]]]
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
					Object[Container,Bench,"Unit test bench for ExperimentCIEF tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 1 for ExperimentCIEF tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 2 for ExperimentCIEF tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 3 for ExperimentCIEF tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 4 for ExperimentCIEF tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 4a for ExperimentCIEF tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 5 for ExperimentCIEF tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 6 for ExperimentCIEF tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 7 for ExperimentCIEF tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 8 for ExperimentCIEF tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 9 for ExperimentCIEF tests "<>$SessionUUID],
					Object[Container,Plate,"Unit test container 10 for ExperimentCIEF tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 12 for ExperimentCIEF tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 13 for ExperimentCIEF tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 14 for ExperimentCIEF tests "<>$SessionUUID],
					Model[Sample,"Unit test Model for ExperimentCIEF (deprecated) "<>$SessionUUID ],
					Model[Sample,"10 mg/mL BSA Fraction V for cIEF tests "<>$SessionUUID],
					Model[Sample,"10 mg/mL bActin for cIEF tests "<>$SessionUUID],
					Model[Sample,"0.24 mM bActin "<>$SessionUUID],
					Model[Sample,"0.5% SDS in 100mM Tris, pH 9.5 "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test protein 1 (deprecated) "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test sample 1 (discarded) "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test sample 3 (100 uL) "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test sample 2 (100 uL) "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test reagent "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF IgG Standard "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test sample 1 (20 mL) "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test sample 4 (250 uL) "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test sample 5 (100 uL) "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF model-less Test sample 5 (100 uL) "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test Unit test anolyte "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test Unit test catholyte "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test Unit test 0.5% MC "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test Unit test FL std "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test Unit test urea "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test Unit test ampholyte "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test Unit test piMarker 1 "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test Unit test piMarker 2 "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test Unit test piMarker 3 "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test Unit test piMarker 4 "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test Unit test piMarker 5 "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test Unit test Arginine "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test Unit test 1% MC "<>$SessionUUID],
					Object[Sample,"ExperimentCIEF Test Unit test std peptide mix "<>$SessionUUID],
					Object[Container,ProteinCapillaryElectrophoresisCartridge,"CESDS-Plus Cartridge test Object 1 for ExperimentCIEF "<>$SessionUUID],
					Object[Container,ProteinCapillaryElectrophoresisCartridge,"cIEF Cartridge test discarded Object 2 ExperimentCIEF "<>$SessionUUID],
					Object[Container,ProteinCapillaryElectrophoresisCartridge,"cIEF Cartridge test Object 3 ExperimentCIEF (190 uses) "<>$SessionUUID],
					Object[Container,ProteinCapillaryElectrophoresisCartridge,"cIEF Cartridge test Object 1 for ExperimentCIEF "<>$SessionUUID],

					Object[Protocol, CapillaryIsoelectricFocusing, "CIEF Protocol 1 "<>$SessionUUID],
					Lookup[Object[Protocol, CapillaryIsoelectricFocusing, "CIEF Protocol 1 "<>$SessionUUID], {ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs,DatabaseMemberQ[objs]];
			EraseObject[existingObjs,Force->True,Verbose->False] (* make sure nothing is left over from previous test, cleanup whatever was left *)
		];
	)
];



(* ::Subsection:: *)
(*ValidExperimentCapillaryIsoelectricFocusingQ*)

DefineTests[ValidExperimentCapillaryIsoelectricFocusingQ,
	{
		Example[{Basic,"Returns a Boolean indicating the validity of a capillary isoelectric focusing experiment:"},
			ValidExperimentCapillaryIsoelectricFocusingQ[Object[Sample,"ValidExperimentCIEFQ Test sample 1 (100 uL) "<>$SessionUUID]],
			True
		],
		Example[{Basic,"Return False if there are problems with the inputs or options:"},
			ValidExperimentCapillaryIsoelectricFocusingQ[Object[Sample,"ValidExperimentCIEFQ Test sample 1 (discarded) "<>$SessionUUID]],
			False
		],
		Example[{Options,Verbose,"If Verbose -> True, returns the passing and failing tests:"},
			ValidExperimentCapillaryIsoelectricFocusingQ[Object[Sample,"ValidExperimentCIEFQ Test sample 1 (discarded) "<>$SessionUUID],
				Verbose->True
			],
			False
		],
		Example[{Options,OutputFormat,"If OutputFormat -> TestSummary, returns a test summary instead of a Boolean:"},
			ValidExperimentCapillaryIsoelectricFocusingQ[Object[Sample,"ValidExperimentCIEFQ Test sample 1 (discarded) "<>$SessionUUID],
				OutputFormat->TestSummary
			],
			_EmeraldTestSummary
		]
	},
	Stubs:>{ (* Set global Variables *)
		$EmailEnabled=False,
		$AllowSystemsProtocols=True(*),
		$DeveloperSearch = True*)
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
						Object[Container,Bench,"Unit test bench for ValidExperimentCIEFQ tests "<>$SessionUUID],
						Object[Container,Vessel,"Unit test container 1 for ValidExperimentCIEFQ tests "<>$SessionUUID],
						Object[Container,Vessel,"Unit test container 2 for ValidExperimentCIEFQ tests "<>$SessionUUID],
						Object[Container,Plate,"Unit test container 3 for ValidExperimentCIEFQ tests "<>$SessionUUID],
						Object[Container,Vessel,"Unit test container 4 for ValidExperimentCIEFQ tests "<>$SessionUUID],
						Object[Container,Vessel,"Unit test container 5 for ValidExperimentCIEFQ tests "<>$SessionUUID],
						Model[Sample,"10 mg/mL BSA Fraction V for cIEF tests "<>$SessionUUID],
						Object[Sample,"ValidExperimentCIEFQ Test sample 1 (discarded) "<>$SessionUUID],
						Object[Sample,"ValidExperimentCIEFQ Test sample 1 (100 uL) "<>$SessionUUID],
						Object[Sample,"ValidExperimentCIEFQ Test Unit test anolyte "<>$SessionUUID],
						Object[Sample,"ValidExperimentCIEFQ Test Unit test catholyte "<>$SessionUUID],
						Object[Sample,"ValidExperimentCIEFQ Test Unit test 0.5% MC "<>$SessionUUID],
						Object[Sample,"ValidExperimentCIEFQ Test Unit test FL std "<>$SessionUUID],
						Object[Sample,"ValidExperimentCIEFQ Test Unit test urea "<>$SessionUUID],
						Object[Sample,"ValidExperimentCIEFQ Test Unit test ampholyte "<>$SessionUUID],
						Object[Sample,"ValidExperimentCIEFQ Test Unit test piMarker 1 "<>$SessionUUID],
						Object[Sample,"ValidExperimentCIEFQ Test Unit test piMarker 2 "<>$SessionUUID],
						Object[Sample,"ValidExperimentCIEFQ Test Unit test piMarker 3 "<>$SessionUUID],
						Object[Sample,"ValidExperimentCIEFQ Test Unit test piMarker 4 "<>$SessionUUID],
						Object[Sample,"ValidExperimentCIEFQ Test Unit test piMarker 5 "<>$SessionUUID],
						Object[Sample,"ValidExperimentCIEFQ Test Unit test Arginine "<>$SessionUUID],
						Object[Sample,"ValidExperimentCIEFQ Test Unit test 1% MC "<>$SessionUUID],
						Object[Sample,"ValidExperimentCIEFQ Test Unit test std peptide mix "<>$SessionUUID],
						Object[Container,ProteinCapillaryElectrophoresisCartridge,"cIEF Cartridge test Object 1 for ValidExperimentCIEFQ "<>$SessionUUID]
					}],
					ObjectP[]
			]];
			existingObjs=PickList[objs,DatabaseMemberQ[objs]];
			EraseObject[existingObjs,Force->True,Verbose->False] (* make sure nothing is left over from previous test, cleanup whatever was left *)
		];
		Block[{$AllowSystemsProtocols=True},(* must use Block here, rather than With, With wont set it back to original value *)
			Module[
				{
					testBench,container,container2,sample,sample2,container10,sampleModel1,cartridge1,allObjects,
					anolyte,std,catholyte,mc05,flx,urea,ampholyte,piMarker1,piMarker2,arg,mc1,container13,container14
				},

				sampleModel1=UploadSampleModel["10 mg/mL BSA Fraction V for cIEF tests "<>$SessionUUID,
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

				{
					testBench,
					cartridge1
				}=Upload[{
					<|
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name -> "Unit test bench for ValidExperimentCIEFQ tests " <> $SessionUUID,
						DeveloperObject -> True,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Site -> Link[$Site]
					|>,
					<|
						Name->"cIEF Cartridge test Object 1 for ValidExperimentCIEFQ "<>$SessionUUID,
						Type->Object[Container,ProteinCapillaryElectrophoresisCartridge],
						Model-> Link[Model[Container,ProteinCapillaryElectrophoresisCartridge, "cIEF"],Objects],
						NumberOfUses->25,
						DeveloperObject->True,
						Status->Available,
						Site -> Link[$Site]
					|>
				}];

				{
					container,
					container2,
					container10,
					container13,
					container14
				}=UploadSample[
					{
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"]
					},
					{
						{"Work Surface",testBench},
						{"Work Surface",testBench},
						{"Work Surface",testBench},
						{"Work Surface",testBench},
						{"Work Surface",testBench}
					},
					Status->Available,
					Name->{
						"Unit test container 1 for ValidExperimentCIEFQ tests "<>$SessionUUID,
						"Unit test container 2 for ValidExperimentCIEFQ tests "<>$SessionUUID,
						"Unit test container 3 for ValidExperimentCIEFQ tests "<>$SessionUUID,
						"Unit test container 4 for ValidExperimentCIEFQ tests "<>$SessionUUID,
						"Unit test container 5 for ValidExperimentCIEFQ tests "<>$SessionUUID
					}
				];

				{
					sample,
					sample2,
					anolyte,
					catholyte,
					mc05,
					flx,
					urea,
					ampholyte,
					piMarker1,
					piMarker2,
					arg,
					mc1,
					std
				}=UploadSample[
					{
						Model[Sample, "10 mg/mL BSA Fraction V for cIEF tests "<>$SessionUUID],
						Model[Sample, "10 mg/mL BSA Fraction V for cIEF tests "<>$SessionUUID],
						Model[Sample, "0.08M Phosphoric Acid in 0.1% Methyl Cellulose"],
						Model[Sample, "0.1M Sodium Hydroxide in 0.1% Methyl Cellulose"],
						Model[Sample, "0.5% Methyl Cellulose"],
						Model[Sample, "cIEF Fluorescence Calibration Standard"],
						Model[Sample, StockSolution, "10M Urea"],
						Model[Sample, "Pharmalyte pH 3-10"],
						Model[Sample, StockSolution, "Resuspended cIEF pI Marker - 4.05"],
						Model[Sample, StockSolution, "Resuspended cIEF pI Marker - 9.99"],
						Model[Sample, StockSolution, "500mM Arginine"],
						Model[Sample, "1% Methyl Cellulose"],
						Model[Sample, StockSolution, "Resuspended cIEF System Suitability Peptide Panel"]
					},
					{
						{"A1",container},
						{"A1",container2},
						{"A1",container13},
						{"A1",container14},
						{"A5",container10},
						{"A6",container10},
						{"A7",container10},
						{"A8",container10},
						{"A9",container10},
						{"B8",container10},
						{"B9",container10},
						{"A10",container10},
						{"A12",container10}

					},
					InitialAmount->{
						100*Microliter,
						100*Microliter,
						20Milliliter,
						20Milliliter,
						2Milliliter,
						2Milliliter,
						2Milliliter,
						2Milliliter,
						2Milliliter,
						2Milliliter,
						2Milliliter,
						2Milliliter,
						2Milliliter
					},
					Name->{
						"ValidExperimentCIEFQ Test sample 1 (100 uL) "<>$SessionUUID,
						"ValidExperimentCIEFQ Test sample 1 (discarded) "<>$SessionUUID,
						"ValidExperimentCIEFQ Test Unit test anolyte "<>$SessionUUID,
						"ValidExperimentCIEFQ Test Unit test catholyte "<>$SessionUUID,
						"ValidExperimentCIEFQ Test Unit test 0.5% MC "<>$SessionUUID,
						"ValidExperimentCIEFQ Test Unit test FL std "<>$SessionUUID,
						"ValidExperimentCIEFQ Test Unit test urea "<>$SessionUUID,
						"ValidExperimentCIEFQ Test Unit test ampholyte "<>$SessionUUID,
						"ValidExperimentCIEFQ Test Unit test piMarker 1 "<>$SessionUUID,
						"ValidExperimentCIEFQ Test Unit test piMarker 2 "<>$SessionUUID,
						"ValidExperimentCIEFQ Test Unit test Arginine "<>$SessionUUID,
						"ValidExperimentCIEFQ Test Unit test 1% MC "<>$SessionUUID,
						"ValidExperimentCIEFQ Test Unit test std peptide mix "<>$SessionUUID

					},
					Status->Available,
					StorageCondition->{
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]],
						Link[Model[StorageCondition,"Ambient Storage"]]
					}
				];

				(* upload other items needed for testing the protocol All of those are Developer object -> True AwaitingStorageUpdate-> Null so that they are not treated as real objects in lab if messed something up *)
				allObjects=Cases[Flatten[{container,container2,sample,sample2,cartridge1,
					container10,container13,container14,anolyte,catholyte,mc05,flx,urea,ampholyte,arg,mc1}
				],ObjectP[]];
				Upload[<|Object->#,DeveloperObject->True,AwaitingStorageUpdate->Null|> &/@allObjects];
				Upload[Cases[Flatten[{
					<|Object->sample2,Status->Discarded,Model->Null|>
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
					Object[Container,Bench,"Unit test bench for ValidExperimentCIEFQ tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 1 for ValidExperimentCIEFQ tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 2 for ValidExperimentCIEFQ tests "<>$SessionUUID],
					Object[Container,Plate,"Unit test container 3 for ValidExperimentCIEFQ tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 4 for ValidExperimentCIEFQ tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 5 for ValidExperimentCIEFQ tests "<>$SessionUUID],
					Model[Sample,"10 mg/mL BSA Fraction V for cIEF tests "<>$SessionUUID],
					Object[Sample,"ValidExperimentCIEFQ Test sample 1 (discarded) "<>$SessionUUID],
					Object[Sample,"ValidExperimentCIEFQ Test sample 1 (100 uL) "<>$SessionUUID],
					Object[Sample,"ValidExperimentCIEFQ Test Unit test anolyte "<>$SessionUUID],
					Object[Sample,"ValidExperimentCIEFQ Test Unit test catholyte "<>$SessionUUID],
					Object[Sample,"ValidExperimentCIEFQ Test Unit test 0.5% MC "<>$SessionUUID],
					Object[Sample,"ValidExperimentCIEFQ Test Unit test FL std "<>$SessionUUID],
					Object[Sample,"ValidExperimentCIEFQ Test Unit test urea "<>$SessionUUID],
					Object[Sample,"ValidExperimentCIEFQ Test Unit test ampholyte "<>$SessionUUID],
					Object[Sample,"ValidExperimentCIEFQ Test Unit test piMarker 1 "<>$SessionUUID],
					Object[Sample,"ValidExperimentCIEFQ Test Unit test piMarker 2 "<>$SessionUUID],
					Object[Sample,"ValidExperimentCIEFQ Test Unit test piMarker 3 "<>$SessionUUID],
					Object[Sample,"ValidExperimentCIEFQ Test Unit test piMarker 4 "<>$SessionUUID],
					Object[Sample,"ValidExperimentCIEFQ Test Unit test piMarker 5 "<>$SessionUUID],
					Object[Sample,"ValidExperimentCIEFQ Test Unit test Arginine "<>$SessionUUID],
					Object[Sample,"ValidExperimentCIEFQ Test Unit test 1% MC "<>$SessionUUID],
					Object[Sample,"ValidExperimentCIEFQ Test Unit test std peptide mix "<>$SessionUUID],
					Object[Container,ProteinCapillaryElectrophoresisCartridge,"cIEF Cartridge test Object 1 for ValidExperimentCIEFQ "<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs,DatabaseMemberQ[objs]];
			EraseObject[existingObjs,Force->True,Verbose->False] (* make sure nothing is left over from previous test, cleanup whatever was left *)
		];
	)
];

(* ::Subsection::Closed:: *)
(*ExperimentCapillaryIsoelectricFocusingOptions*)


DefineTests[
	ExperimentCapillaryIsoelectricFocusingOptions,
	{
		Example[{Basic,"Display the option values which will be used in the capillary Gel Electrophoresis SDS experiment:"},
			ExperimentCapillaryIsoelectricFocusingOptions[Object[Sample,"ExperimentCIEFOptions Test sample 1 (100 uL) "<>$SessionUUID]],
			_Grid
		],
		Example[{Basic,"View any potential issues with provided inputs/options displayed:"},
			ExperimentCapillaryIsoelectricFocusingOptions[Object[Sample,"ExperimentCIEFOptions Test sample 1 (discarded) "<>$SessionUUID]],
			_Grid,
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			ExperimentCapillaryIsoelectricFocusingOptions[Object[Sample,"ExperimentCIEFOptions Test sample 1 (100 uL) "<>$SessionUUID],OutputFormat->List],
			{(_Rule|_RuleDelayed)..}
		]
	},
	Stubs:>{ (* Set global Variables *)
		$EmailEnabled=False,
		$AllowSystemsProtocols=True(*),
		$DeveloperSearch = True*)
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
						Object[Container,Bench,"Unit test bench for ExperimentCIEFOptions tests "<>$SessionUUID],
						Object[Container,Vessel,"Unit test container 1 for ExperimentCIEFOptions tests "<>$SessionUUID],
						Object[Container,Vessel,"Unit test container 2 for ExperimentCIEFOptions tests "<>$SessionUUID],
						Object[Container,Plate,"Unit test container 3 for ExperimentCIEFOptions tests "<>$SessionUUID],
						Object[Container,Vessel,"Unit test container 4 for ExperimentCIEFOptions tests "<>$SessionUUID],
						Object[Container,Vessel,"Unit test container 5 for ExperimentCIEFOptions tests "<>$SessionUUID],
						Model[Sample,"10 mg/mL BSA Fraction V for cIEF tests "<>$SessionUUID],
						Object[Sample,"ExperimentCIEFOptions Test sample 1 (discarded) "<>$SessionUUID],
						Object[Sample,"ExperimentCIEFOptions Test sample 1 (100 uL) "<>$SessionUUID],
						Object[Sample,"ExperimentCIEFOptions Test Unit test anolyte "<>$SessionUUID],
						Object[Sample,"ExperimentCIEFOptions Test Unit test catholyte "<>$SessionUUID],
						Object[Sample,"ExperimentCIEFOptions Test Unit test 0.5% MC "<>$SessionUUID],
						Object[Sample,"ExperimentCIEFOptions Test Unit test FL std "<>$SessionUUID],
						Object[Sample,"ExperimentCIEFOptions Test Unit test urea "<>$SessionUUID],
						Object[Sample,"ExperimentCIEFOptions Test Unit test ampholyte "<>$SessionUUID],
						Object[Sample,"ExperimentCIEFOptions Test Unit test piMarker 1 "<>$SessionUUID],
						Object[Sample,"ExperimentCIEFOptions Test Unit test piMarker 2 "<>$SessionUUID],
						Object[Sample,"ExperimentCIEFOptions Test Unit test piMarker 3 "<>$SessionUUID],
						Object[Sample,"ExperimentCIEFOptions Test Unit test piMarker 4 "<>$SessionUUID],
						Object[Sample,"ExperimentCIEFOptions Test Unit test piMarker 5 "<>$SessionUUID],
						Object[Sample,"ExperimentCIEFOptions Test Unit test Arginine "<>$SessionUUID],
						Object[Sample,"ExperimentCIEFOptions Test Unit test 1% MC "<>$SessionUUID],
						Object[Sample,"ExperimentCIEFOptions Test Unit test std peptide mix "<>$SessionUUID],
						Object[Container,ProteinCapillaryElectrophoresisCartridge,"cIEF Cartridge test Object 1 for ExperimentCIEFOptions "<>$SessionUUID]
					}],
					ObjectP[]
				]];
			existingObjs=PickList[objs,DatabaseMemberQ[objs]];
			EraseObject[existingObjs,Force->True,Verbose->False] (* make sure nothing is left over from previous test, cleanup whatever was left *)
			];
			Block[{$AllowSystemsProtocols=True},(* must use Block here, rather than With, With wont set it back to original value *)
				Module[
					{
						testBench,container,container2,sample,sample2,container10,sampleModel1,cartridge1,allObjects,
						anolyte,std,catholyte,mc05,flx,urea,ampholyte,piMarker1,piMarker2,arg,mc1,container13,container14
					},

					sampleModel1=UploadSampleModel["10 mg/mL BSA Fraction V for cIEF tests "<>$SessionUUID,
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

					{
						testBench,
						cartridge1
					}=Upload[{
						<|
							Type -> Object[Container, Bench],
							Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
							Name -> "Unit test bench for ExperimentCIEFOptions tests " <> $SessionUUID,
							DeveloperObject -> True,
							StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
							Site -> Link[$Site]
						|>,
						<|
							Name->"cIEF Cartridge test Object 1 for ExperimentCIEFOptions "<>$SessionUUID,
							Type->Object[Container,ProteinCapillaryElectrophoresisCartridge],
							Model->	Link[Model[Container,ProteinCapillaryElectrophoresisCartridge, "cIEF"],Objects],
							NumberOfUses->25,
							DeveloperObject->True,
							Status->Available,
							Site -> Link[$Site]
						|>
					}];


					{
						container,
						container2,
						container10,
						container13,
						container14
					}=UploadSample[
						{
							Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
							Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
							Model[Container, Plate, "96-well 2mL Deep Well Plate"],
							Model[Container, Vessel, "50mL Tube"],
							Model[Container, Vessel, "50mL Tube"]
						},
						{
							{"Work Surface",testBench},
							{"Work Surface",testBench},
							{"Work Surface",testBench},
							{"Work Surface",testBench},
							{"Work Surface",testBench}
						},
						Status->Available,
						Name->{
							"Unit test container 1 for ExperimentCIEFOptions tests "<>$SessionUUID,
							"Unit test container 2 for ExperimentCIEFOptions tests "<>$SessionUUID,
							"Unit test container 3 for ExperimentCIEFOptions tests "<>$SessionUUID,
							"Unit test container 4 for ExperimentCIEFOptions tests "<>$SessionUUID,
							"Unit test container 5 for ExperimentCIEFOptions tests "<>$SessionUUID
						}
					];

					{
						sample,
						sample2,
						anolyte,
						catholyte,
						mc05,
						flx,
						urea,
						ampholyte,
						piMarker1,
						piMarker2,
						arg,
						mc1,
						std
					}=UploadSample[
						{
							Model[Sample, "10 mg/mL BSA Fraction V for cIEF tests "<>$SessionUUID],
							Model[Sample, "10 mg/mL BSA Fraction V for cIEF tests "<>$SessionUUID],
							Model[Sample, "0.08M Phosphoric Acid in 0.1% Methyl Cellulose"],
							Model[Sample, "0.1M Sodium Hydroxide in 0.1% Methyl Cellulose"],
							Model[Sample, "0.5% Methyl Cellulose"],
							Model[Sample, "cIEF Fluorescence Calibration Standard"],
							Model[Sample, StockSolution, "10M Urea"],
							Model[Sample, "Pharmalyte pH 3-10"],
							Model[Sample, StockSolution, "Resuspended cIEF pI Marker - 4.05"],
							Model[Sample, StockSolution, "Resuspended cIEF pI Marker - 9.99"],
							Model[Sample, StockSolution, "500mM Arginine"],
							Model[Sample, "1% Methyl Cellulose"],
							Model[Sample, StockSolution, "Resuspended cIEF System Suitability Peptide Panel"]
						},
						{
							{"A1",container},
							{"A1",container2},
							{"A1",container13},
							{"A1",container14},
							{"A5",container10},
							{"A6",container10},
							{"A7",container10},
							{"A8",container10},
							{"A9",container10},
							{"B8",container10},
							{"B9",container10},
							{"A10",container10},
							{"A12",container10}

						},
						InitialAmount->{
							100*Microliter,
							100*Microliter,
							20Milliliter,
							20Milliliter,
							2Milliliter,
							2Milliliter,
							2Milliliter,
							2Milliliter,
							2Milliliter,
							2Milliliter,
							2Milliliter,
							2Milliliter,
							2Milliliter
						},
						Name->{
							"ExperimentCIEFOptions Test sample 1 (100 uL) "<>$SessionUUID,
							"ExperimentCIEFOptions Test sample 1 (discarded) "<>$SessionUUID,
							"ExperimentCIEFOptions Test Unit test anolyte "<>$SessionUUID,
							"ExperimentCIEFOptions Test Unit test catholyte "<>$SessionUUID,
							"ExperimentCIEFOptions Test Unit test 0.5% MC "<>$SessionUUID,
							"ExperimentCIEFOptions Test Unit test FL std "<>$SessionUUID,
							"ExperimentCIEFOptions Test Unit test urea "<>$SessionUUID,
							"ExperimentCIEFOptions Test Unit test ampholyte "<>$SessionUUID,
							"ExperimentCIEFOptions Test Unit test piMarker 1 "<>$SessionUUID,
							"ExperimentCIEFOptions Test Unit test piMarker 2 "<>$SessionUUID,
							"ExperimentCIEFOptions Test Unit test Arginine "<>$SessionUUID,
							"ExperimentCIEFOptions Test Unit test 1% MC "<>$SessionUUID,
							"ExperimentCIEFOptions Test Unit test std peptide mix "<>$SessionUUID

						},
						Status->Available,
						StorageCondition->{
							Link[Model[StorageCondition,"Ambient Storage"]],
							Link[Model[StorageCondition,"Ambient Storage"]],
							Link[Model[StorageCondition,"Ambient Storage"]],
							Link[Model[StorageCondition,"Ambient Storage"]],
							Link[Model[StorageCondition,"Ambient Storage"]],
							Link[Model[StorageCondition,"Ambient Storage"]],
							Link[Model[StorageCondition,"Ambient Storage"]],
							Link[Model[StorageCondition,"Ambient Storage"]],
							Link[Model[StorageCondition,"Ambient Storage"]],
							Link[Model[StorageCondition,"Ambient Storage"]],
							Link[Model[StorageCondition,"Ambient Storage"]],
							Link[Model[StorageCondition,"Ambient Storage"]],
							Link[Model[StorageCondition,"Ambient Storage"]]
						}
					];

					(* upload other items needed for testing the protocol All of those are Developer object -> True AwaitingStorageUpdate-> Null so that they are not treated as real objects in lab if messed something up *)
					allObjects=Cases[Flatten[{container,container2,sample,sample2,cartridge1,
						container10,container13,container14,anolyte,catholyte,mc05,flx,urea,ampholyte,arg,mc1}
					],ObjectP[]];
					Upload[<|Object->#,DeveloperObject->True,AwaitingStorageUpdate->Null|> &/@allObjects];
					Upload[Cases[Flatten[{
						<|Object->sample2,Status->Discarded,Model->Null|>
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
					Object[Container,Bench,"Unit test bench for ExperimentCIEFOptions tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 1 for ExperimentCIEFOptions tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 2 for ExperimentCIEFOptions tests "<>$SessionUUID],
					Object[Container,Plate,"Unit test container 3 for ExperimentCIEFOptions tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 4 for ExperimentCIEFOptions tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 5 for ExperimentCIEFOptions tests "<>$SessionUUID],
					Model[Sample,"10 mg/mL BSA Fraction V for cIEF tests "<>$SessionUUID],
					Object[Sample,"ExperimentCIEFOptions Test sample 1 (discarded) "<>$SessionUUID],
					Object[Sample,"ExperimentCIEFOptions Test sample 1 (100 uL) "<>$SessionUUID],
					Object[Sample,"ExperimentCIEFOptions Test Unit test anolyte "<>$SessionUUID],
					Object[Sample,"ExperimentCIEFOptions Test Unit test catholyte "<>$SessionUUID],
					Object[Sample,"ExperimentCIEFOptions Test Unit test 0.5% MC "<>$SessionUUID],
					Object[Sample,"ExperimentCIEFOptions Test Unit test FL std "<>$SessionUUID],
					Object[Sample,"ExperimentCIEFOptions Test Unit test urea "<>$SessionUUID],
					Object[Sample,"ExperimentCIEFOptions Test Unit test ampholyte "<>$SessionUUID],
					Object[Sample,"ExperimentCIEFOptions Test Unit test piMarker 1 "<>$SessionUUID],
					Object[Sample,"ExperimentCIEFOptions Test Unit test piMarker 2 "<>$SessionUUID],
					Object[Sample,"ExperimentCIEFOptions Test Unit test piMarker 3 "<>$SessionUUID],
					Object[Sample,"ExperimentCIEFOptions Test Unit test piMarker 4 "<>$SessionUUID],
					Object[Sample,"ExperimentCIEFOptions Test Unit test piMarker 5 "<>$SessionUUID],
					Object[Sample,"ExperimentCIEFOptions Test Unit test Arginine "<>$SessionUUID],
					Object[Sample,"ExperimentCIEFOptions Test Unit test 1% MC "<>$SessionUUID],
					Object[Sample,"ExperimentCIEFOptions Test Unit test std peptide mix "<>$SessionUUID],
					Object[Container,ProteinCapillaryElectrophoresisCartridge,"cIEF Cartridge test Object 1 for ExperimentCIEFOptions "<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs,DatabaseMemberQ[objs]];
			EraseObject[existingObjs,Force->True,Verbose->False] (* make sure nothing is left over from previous test, cleanup whatever was left *)
		];
	)
];

(* ::Subsection::Closed:: *)
(*ExperimentCapillaryIsoelectricFocusingPreview*)

DefineTests[
	ExperimentCapillaryIsoelectricFocusingPreview,
	{
		Example[{Basic,"No preview is currently available for ExperimentCapillaryIsoelectricFocusing:"},
			ExperimentCapillaryIsoelectricFocusingPreview[Object[Sample,"ExperimentCIEFPreview Test sample 1 (100 uL) "<>$SessionUUID]],
			Null
		],
		Example[{Basic,"Return Null for multiple samples:"},
			ExperimentCapillaryIsoelectricFocusingPreview[{Object[Sample,"ExperimentCIEFPreview Test sample 1 (100 uL) "<>$SessionUUID],Object[Sample,"ExperimentCIEFPreview Test sample 1 (100 uL) "<>$SessionUUID]}],
			Null
		],
		Example[{Additional,"If you wish to understand how the experiment will be performed, try using ExperimentCapillaryIsoelectricFocusingOptions:"},
			ExperimentCapillaryIsoelectricFocusingOptions[Object[Sample,"ExperimentCIEFPreview Test sample 1 (100 uL) "<>$SessionUUID]],
			_Grid
		],
		Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run using ValidExperimentCapillaryIsoelectricFocusingQ:"},
			ValidExperimentCapillaryIsoelectricFocusingQ[Object[Sample,"ExperimentCIEFPreview Test sample 1 (100 uL) "<>$SessionUUID]],
			True
		]
	},
	Stubs:>{ (* Set global Variables *)
		$EmailEnabled=False,
		$AllowSystemsProtocols=True(*),
		$DeveloperSearch = True*)
	},
	SetUp:>( (* before and after EVERY test *)
		$CreatedObjects={};
		ClearMemoization[];
	),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects];
	),
	SymbolSetUp:>( (* create objects for tests, runs once before everything *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Off[Warning::AliquotRequired];
		ClearMemoization[];

		Module[{objs,existingObjs},
			objs=Quiet[Cases[
				Flatten[{
						Object[Container,Bench,"Unit test bench for ExperimentCIEFPreview tests "<>$SessionUUID],
						Object[Container,Vessel,"Unit test container 1 for ExperimentCIEFPreview tests "<>$SessionUUID],
						Object[Container,Vessel,"Unit test container 2 for ExperimentCIEFPreview tests "<>$SessionUUID],
						Object[Container,Plate,"Unit test container 3 for ExperimentCIEFPreview tests "<>$SessionUUID],
						Object[Container,Vessel,"Unit test container 4 for ExperimentCIEFPreview tests "<>$SessionUUID],
						Object[Container,Vessel,"Unit test container 5 for ExperimentCIEFPreview tests "<>$SessionUUID],
						Model[Sample,"10 mg/mL BSA Fraction V for cIEF tests "<>$SessionUUID],
						Object[Sample,"ExperimentCIEFPreview Test sample 1 (discarded) "<>$SessionUUID],
						Object[Sample,"ExperimentCIEFPreview Test sample 1 (100 uL) "<>$SessionUUID],
						Object[Sample,"ExperimentCIEFPreview Test Unit test anolyte "<>$SessionUUID],
						Object[Sample,"ExperimentCIEFPreview Test Unit test catholyte "<>$SessionUUID],
						Object[Sample,"ExperimentCIEFPreview Test Unit test 0.5% MC "<>$SessionUUID],
						Object[Sample,"ExperimentCIEFPreview Test Unit test FL std "<>$SessionUUID],
						Object[Sample,"ExperimentCIEFPreview Test Unit test urea "<>$SessionUUID],
						Object[Sample,"ExperimentCIEFPreview Test Unit test ampholyte "<>$SessionUUID],
						Object[Sample,"ExperimentCIEFPreview Test Unit test piMarker 1 "<>$SessionUUID],
						Object[Sample,"ExperimentCIEFPreview Test Unit test piMarker 2 "<>$SessionUUID],
						Object[Sample,"ExperimentCIEFPreview Test Unit test piMarker 3 "<>$SessionUUID],
						Object[Sample,"ExperimentCIEFPreview Test Unit test piMarker 4 "<>$SessionUUID],
						Object[Sample,"ExperimentCIEFPreview Test Unit test piMarker 5 "<>$SessionUUID],
						Object[Sample,"ExperimentCIEFPreview Test Unit test Arginine "<>$SessionUUID],
						Object[Sample,"ExperimentCIEFPreview Test Unit test 1% MC "<>$SessionUUID],
						Object[Sample,"ExperimentCIEFPreview Test Unit test std peptide mix "<>$SessionUUID],
						Object[Container,ProteinCapillaryElectrophoresisCartridge,"cIEF Cartridge test Object 1 for ExperimentCIEFPreview "<>$SessionUUID]
					}],
					ObjectP[]
				]];
			existingObjs=PickList[objs,DatabaseMemberQ[objs]];
			EraseObject[existingObjs,Force->True,Verbose->False] (* make sure nothing is left over from previous test, cleanup whatever was left *)
			];
			Block[{$AllowSystemsProtocols=True},(* must use Block here, rather than With, With wont set it back to original value *)
				Module[
					{
						testBench,container,container2,sample,sample2,container10,sampleModel1,cartridge1,allObjects,
						anolyte,std,catholyte,mc05,flx,urea,ampholyte,piMarker1,piMarker2,arg,mc1,container13,container14
					},

					sampleModel1=UploadSampleModel["10 mg/mL BSA Fraction V for cIEF tests "<>$SessionUUID,
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

					{
						testBench,
						cartridge1
					}=Upload[{
						<|
							Type -> Object[Container, Bench],
							Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
							Name -> "Unit test bench for ExperimentCIEFPreview tests " <> $SessionUUID,
							DeveloperObject -> True,
							StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
							Site -> Link[$Site]
						|>,
						<|
							Name->"cIEF Cartridge test Object 1 for ExperimentCIEFPreview "<>$SessionUUID,
							Type->Object[Container,ProteinCapillaryElectrophoresisCartridge],
							Model-> Link[Model[Container,ProteinCapillaryElectrophoresisCartridge, "cIEF"],Objects],
							NumberOfUses->25,
							DeveloperObject->True,
							Status->Available,
							Site -> Link[$Site]
						|>
					}];

					{
						container,
						container2,
						container10,
						container13,
						container14
					}=UploadSample[
						{
							Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
							Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
							Model[Container, Plate, "96-well 2mL Deep Well Plate"],
							Model[Container, Vessel, "50mL Tube"],
							Model[Container, Vessel, "50mL Tube"]
						},
						{
							{"Work Surface",testBench},
							{"Work Surface",testBench},
							{"Work Surface",testBench},
							{"Work Surface",testBench},
							{"Work Surface",testBench}
						},
						Status->Available,
						Name->{
							"Unit test container 1 for ExperimentCIEFPreview tests "<>$SessionUUID,
							"Unit test container 2 for ExperimentCIEFPreview tests "<>$SessionUUID,
							"Unit test container 3 for ExperimentCIEFPreview tests "<>$SessionUUID,
							"Unit test container 4 for ExperimentCIEFPreview tests "<>$SessionUUID,
							"Unit test container 5 for ExperimentCIEFPreview tests "<>$SessionUUID
						}
					];

					{
						sample,
						sample2,
						anolyte,
						catholyte,
						mc05,
						flx,
						urea,
						ampholyte,
						piMarker1,
						piMarker2,
						arg,
						mc1,
						std
					}=UploadSample[
						{
							Model[Sample, "10 mg/mL BSA Fraction V for cIEF tests "<>$SessionUUID],
							Model[Sample, "10 mg/mL BSA Fraction V for cIEF tests "<>$SessionUUID],
							Model[Sample, "0.08M Phosphoric Acid in 0.1% Methyl Cellulose"],
							Model[Sample, "0.1M Sodium Hydroxide in 0.1% Methyl Cellulose"],
							Model[Sample, "0.5% Methyl Cellulose"],
							Model[Sample, "cIEF Fluorescence Calibration Standard"],
							Model[Sample, StockSolution, "10M Urea"],
							Model[Sample, "Pharmalyte pH 3-10"],
							Model[Sample, StockSolution, "Resuspended cIEF pI Marker - 4.05"],
							Model[Sample, StockSolution, "Resuspended cIEF pI Marker - 9.99"],
							Model[Sample, StockSolution, "500mM Arginine"],
							Model[Sample, "1% Methyl Cellulose"],
							Model[Sample, StockSolution, "Resuspended cIEF System Suitability Peptide Panel"]
						},
						{
							{"A1",container},
							{"A1",container2},
							{"A1",container13},
							{"A1",container14},
							{"A5",container10},
							{"A6",container10},
							{"A7",container10},
							{"A8",container10},
							{"A9",container10},
							{"B8",container10},
							{"B9",container10},
							{"A10",container10},
							{"A12",container10}

						},
						InitialAmount->{
							100*Microliter,
							100*Microliter,
							20Milliliter,
							20Milliliter,
							2Milliliter,
							2Milliliter,
							2Milliliter,
							2Milliliter,
							2Milliliter,
							2Milliliter,
							2Milliliter,
							2Milliliter,
							2Milliliter
						},
						Name->{
							"ExperimentCIEFPreview Test sample 1 (100 uL) "<>$SessionUUID,
							"ExperimentCIEFPreview Test sample 1 (discarded) "<>$SessionUUID,
							"ExperimentCIEFPreview Test Unit test anolyte "<>$SessionUUID,
							"ExperimentCIEFPreview Test Unit test catholyte "<>$SessionUUID,
							"ExperimentCIEFPreview Test Unit test 0.5% MC "<>$SessionUUID,
							"ExperimentCIEFPreview Test Unit test FL std "<>$SessionUUID,
							"ExperimentCIEFPreview Test Unit test urea "<>$SessionUUID,
							"ExperimentCIEFPreview Test Unit test ampholyte "<>$SessionUUID,
							"ExperimentCIEFPreview Test Unit test piMarker 1 "<>$SessionUUID,
							"ExperimentCIEFPreview Test Unit test piMarker 2 "<>$SessionUUID,
							"ExperimentCIEFPreview Test Unit test Arginine "<>$SessionUUID,
							"ExperimentCIEFPreview Test Unit test 1% MC "<>$SessionUUID,
							"ExperimentCIEFPreview Test Unit test std peptide mix "<>$SessionUUID

						},
						Status->Available,
						StorageCondition->{
							Link[Model[StorageCondition,"Ambient Storage"]],
							Link[Model[StorageCondition,"Ambient Storage"]],
							Link[Model[StorageCondition,"Ambient Storage"]],
							Link[Model[StorageCondition,"Ambient Storage"]],
							Link[Model[StorageCondition,"Ambient Storage"]],
							Link[Model[StorageCondition,"Ambient Storage"]],
							Link[Model[StorageCondition,"Ambient Storage"]],
							Link[Model[StorageCondition,"Ambient Storage"]],
							Link[Model[StorageCondition,"Ambient Storage"]],
							Link[Model[StorageCondition,"Ambient Storage"]],
							Link[Model[StorageCondition,"Ambient Storage"]],
							Link[Model[StorageCondition,"Ambient Storage"]],
							Link[Model[StorageCondition,"Ambient Storage"]]
						}
					];

					(* upload other items needed for testing the protocol All of those are Developer object -> True AwaitingStorageUpdate-> Null so that they are not treated as real objects in lab if messed something up *)
					allObjects=Cases[Flatten[{container,container2,sample,sample2,cartridge1,
						container10,container13,container14,anolyte,catholyte,mc05,flx,urea,ampholyte,arg,mc1}
					],ObjectP[]];
					Upload[<|Object->#,DeveloperObject->True,AwaitingStorageUpdate->Null|> &/@allObjects];
					Upload[Cases[Flatten[{
						<|Object->sample2,Status->Discarded,Model->Null|>
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
					Object[Container,Bench,"Unit test bench for ExperimentCIEFPreview tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 1 for ExperimentCIEFPreview tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 2 for ExperimentCIEFPreview tests "<>$SessionUUID],
					Object[Container,Plate,"Unit test container 3 for ExperimentCIEFPreview tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 4 for ExperimentCIEFPreview tests "<>$SessionUUID],
					Object[Container,Vessel,"Unit test container 5 for ExperimentCIEFPreview tests "<>$SessionUUID],
					Model[Sample,"10 mg/mL BSA Fraction V for cIEF tests "<>$SessionUUID],
					Object[Sample,"ExperimentCIEFPreview Test sample 1 (discarded) "<>$SessionUUID],
					Object[Sample,"ExperimentCIEFPreview Test sample 1 (100 uL) "<>$SessionUUID],
					Object[Sample,"ExperimentCIEFPreview Test Unit test anolyte "<>$SessionUUID],
					Object[Sample,"ExperimentCIEFPreview Test Unit test catholyte "<>$SessionUUID],
					Object[Sample,"ExperimentCIEFPreview Test Unit test 0.5% MC "<>$SessionUUID],
					Object[Sample,"ExperimentCIEFPreview Test Unit test FL std "<>$SessionUUID],
					Object[Sample,"ExperimentCIEFPreview Test Unit test urea "<>$SessionUUID],
					Object[Sample,"ExperimentCIEFPreview Test Unit test ampholyte "<>$SessionUUID],
					Object[Sample,"ExperimentCIEFPreview Test Unit test piMarker 1 "<>$SessionUUID],
					Object[Sample,"ExperimentCIEFPreview Test Unit test piMarker 2 "<>$SessionUUID],
					Object[Sample,"ExperimentCIEFPreview Test Unit test piMarker 3 "<>$SessionUUID],
					Object[Sample,"ExperimentCIEFPreview Test Unit test piMarker 4 "<>$SessionUUID],
					Object[Sample,"ExperimentCIEFPreview Test Unit test piMarker 5 "<>$SessionUUID],
					Object[Sample,"ExperimentCIEFPreview Test Unit test Arginine "<>$SessionUUID],
					Object[Sample,"ExperimentCIEFPreview Test Unit test 1% MC "<>$SessionUUID],
					Object[Sample,"ExperimentCIEFPreview Test Unit test std peptide mix "<>$SessionUUID],
					Object[Container,ProteinCapillaryElectrophoresisCartridge,"cIEF Cartridge test Object 1 for ExperimentCIEFPreview "<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs,DatabaseMemberQ[objs]];
			EraseObject[existingObjs,Force->True,Verbose->False] (* make sure nothing is left over from previous test, cleanup whatever was left *)
		];
	)
];
