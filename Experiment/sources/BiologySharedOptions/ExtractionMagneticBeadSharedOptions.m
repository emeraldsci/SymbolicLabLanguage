(* ::Package:: *)

(* ::Text:: *)
(* \[Copyright] 2011-2022 Emerald Cloud Lab, Inc. *)


(* ::Subsection:: *)
(* ExtractionMagneticBeadSharedOptions *)


(* Options below based on Options from ExperimentMagneticBeadSeparation. Description and resolution descriptions are revised for Extraction Purification
Option Names are revised to avoid confusion with other purification. *)

$MBSPurificationOptionMap={
	MagneticBeadSeparationSelectionStrategy -> SelectionStrategy,
	MagneticBeadSeparationMode -> SeparationMode,
	MagneticBeadSeparationSampleVolume -> Volume,
	MagneticBeadSeparationAnalyteAffinityLabel -> AnalyteAffinityLabel,
	MagneticBeadAffinityLabel -> MagneticBeadAffinityLabel,
	MagneticBeads -> MagneticBeads,
	MagneticBeadVolume -> MagneticBeadVolume,
	MagneticBeadCollectionStorageCondition -> MagneticBeadCollectionStorageCondition,
	MagnetizationRack -> MagnetizationRack,
	MagneticBeadSeparationPreWash -> PreWash,
	MagneticBeadSeparationPreWashSolution -> PreWashBuffer,
	MagneticBeadSeparationPreWashSolutionVolume -> PreWashBufferVolume,
	MagneticBeadSeparationPreWashMix -> PreWashMix,
	MagneticBeadSeparationPreWashMixType -> PreWashMixType,
	MagneticBeadSeparationPreWashMixTime -> PreWashMixTime,
	MagneticBeadSeparationPreWashMixRate -> PreWashMixRate,
	NumberOfMagneticBeadSeparationPreWashMixes -> NumberOfPreWashMixes,
	MagneticBeadSeparationPreWashMixVolume -> PreWashMixVolume,
	MagneticBeadSeparationPreWashMixTemperature -> PreWashMixTemperature,
	MagneticBeadSeparationPreWashMixTipType -> PreWashMixTipType,
	MagneticBeadSeparationPreWashMixTipMaterial -> PreWashMixTipMaterial,
	PreWashMagnetizationTime -> PreWashMagnetizationTime,
	MagneticBeadSeparationPreWashAspirationVolume -> PreWashAspirationVolume,
	MagneticBeadSeparationPreWashCollectionContainer -> PreWashCollectionContainer,
	MagneticBeadSeparationPreWashCollectionStorageCondition -> PreWashCollectionStorageCondition,
	NumberOfMagneticBeadSeparationPreWashes -> NumberOfPreWashes,
	MagneticBeadSeparationPreWashAirDry -> PreWashAirDry,
	MagneticBeadSeparationPreWashAirDryTime -> PreWashAirDryTime,
	MagneticBeadSeparationEquilibration -> Equilibration,
	MagneticBeadSeparationEquilibrationSolution -> EquilibrationBuffer,
	MagneticBeadSeparationEquilibrationSolutionVolume -> EquilibrationBufferVolume,
	MagneticBeadSeparationEquilibrationMix -> EquilibrationMix,
	MagneticBeadSeparationEquilibrationMixType -> EquilibrationMixType,
	MagneticBeadSeparationEquilibrationMixTime -> EquilibrationMixTime,
	MagneticBeadSeparationEquilibrationMixRate -> EquilibrationMixRate,
	NumberOfMagneticBeadSeparationEquilibrationMixes -> NumberOfEquilibrationMixes,
	MagneticBeadSeparationEquilibrationMixVolume -> EquilibrationMixVolume,
	MagneticBeadSeparationEquilibrationMixTemperature -> EquilibrationMixTemperature,
	MagneticBeadSeparationEquilibrationMixTipType -> EquilibrationMixTipType,
	MagneticBeadSeparationEquilibrationMixTipMaterial -> EquilibrationMixTipMaterial,
	EquilibrationMagnetizationTime -> EquilibrationMagnetizationTime,
	MagneticBeadSeparationEquilibrationAspirationVolume -> EquilibrationAspirationVolume,
	MagneticBeadSeparationEquilibrationCollectionContainer -> EquilibrationCollectionContainer,
	MagneticBeadSeparationEquilibrationCollectionStorageCondition -> EquilibrationCollectionStorageCondition,
	MagneticBeadSeparationEquilibrationAirDry -> EquilibrationAirDry,
	MagneticBeadSeparationEquilibrationAirDryTime -> EquilibrationAirDryTime,
	MagneticBeadSeparationLoadingMix -> LoadingMix,
	MagneticBeadSeparationLoadingMixType -> LoadingMixType,
	MagneticBeadSeparationLoadingMixTime -> LoadingMixTime,
	MagneticBeadSeparationLoadingMixRate -> LoadingMixRate,
	NumberOfMagneticBeadSeparationLoadingMixes -> NumberOfLoadingMixes,
	MagneticBeadSeparationLoadingMixVolume -> LoadingMixVolume,
	MagneticBeadSeparationLoadingMixTemperature -> LoadingMixTemperature,
	MagneticBeadSeparationLoadingMixTipType -> LoadingMixTipType,
	MagneticBeadSeparationLoadingMixTipMaterial -> LoadingMixTipMaterial,
	LoadingMagnetizationTime -> LoadingMagnetizationTime,
	MagneticBeadSeparationLoadingAspirationVolume -> LoadingAspirationVolume,
	MagneticBeadSeparationLoadingCollectionContainer -> LoadingCollectionContainer,
	MagneticBeadSeparationLoadingCollectionStorageCondition -> LoadingCollectionStorageCondition,
	MagneticBeadSeparationLoadingAirDry -> LoadingAirDry,
	MagneticBeadSeparationLoadingAirDryTime -> LoadingAirDryTime,
	MagneticBeadSeparationWash -> Wash,
	MagneticBeadSeparationWashSolution -> WashBuffer,
	MagneticBeadSeparationWashSolutionVolume -> WashBufferVolume,
	MagneticBeadSeparationWashMix -> WashMix,
	MagneticBeadSeparationWashMixType -> WashMixType,
	MagneticBeadSeparationWashMixTime -> WashMixTime,
	MagneticBeadSeparationWashMixRate -> WashMixRate,
	NumberOfMagneticBeadSeparationWashMixes -> NumberOfWashMixes,
	MagneticBeadSeparationWashMixVolume -> WashMixVolume,
	MagneticBeadSeparationWashMixTemperature -> WashMixTemperature,
	MagneticBeadSeparationWashMixTipType -> WashMixTipType,
	MagneticBeadSeparationWashMixTipMaterial -> WashMixTipMaterial,
	WashMagnetizationTime -> WashMagnetizationTime,
	MagneticBeadSeparationWashAspirationVolume -> WashAspirationVolume,
	MagneticBeadSeparationWashCollectionContainer -> WashCollectionContainer,
	MagneticBeadSeparationWashCollectionStorageCondition -> WashCollectionStorageCondition,
	NumberOfMagneticBeadSeparationWashes -> NumberOfWashes,
	MagneticBeadSeparationWashAirDry -> WashAirDry,
	MagneticBeadSeparationWashAirDryTime -> WashAirDryTime,
	MagneticBeadSeparationSecondaryWash -> SecondaryWash,
	MagneticBeadSeparationSecondaryWashSolution -> SecondaryWashBuffer,
	MagneticBeadSeparationSecondaryWashSolutionVolume -> SecondaryWashBufferVolume,
	MagneticBeadSeparationSecondaryWashMix -> SecondaryWashMix,
	MagneticBeadSeparationSecondaryWashMixType -> SecondaryWashMixType,
	MagneticBeadSeparationSecondaryWashMixTime -> SecondaryWashMixTime,
	MagneticBeadSeparationSecondaryWashMixRate -> SecondaryWashMixRate,
	NumberOfMagneticBeadSeparationSecondaryWashMixes -> NumberOfSecondaryWashMixes,
	MagneticBeadSeparationSecondaryWashMixVolume -> SecondaryWashMixVolume,
	MagneticBeadSeparationSecondaryWashMixTemperature -> SecondaryWashMixTemperature,
	MagneticBeadSeparationSecondaryWashMixTipType -> SecondaryWashMixTipType,
	MagneticBeadSeparationSecondaryWashMixTipMaterial -> SecondaryWashMixTipMaterial,
	SecondaryWashMagnetizationTime -> SecondaryWashMagnetizationTime,
	MagneticBeadSeparationSecondaryWashAspirationVolume -> SecondaryWashAspirationVolume,
	MagneticBeadSeparationSecondaryWashCollectionContainer -> SecondaryWashCollectionContainer,
	MagneticBeadSeparationSecondaryWashCollectionStorageCondition -> SecondaryWashCollectionStorageCondition,
	NumberOfMagneticBeadSeparationSecondaryWashes -> NumberOfSecondaryWashes,
	MagneticBeadSeparationSecondaryWashAirDry -> SecondaryWashAirDry,
	MagneticBeadSeparationSecondaryWashAirDryTime -> SecondaryWashAirDryTime,
	MagneticBeadSeparationTertiaryWash -> TertiaryWash,
	MagneticBeadSeparationTertiaryWashSolution -> TertiaryWashBuffer,
	MagneticBeadSeparationTertiaryWashSolutionVolume -> TertiaryWashBufferVolume,
	MagneticBeadSeparationTertiaryWashMix -> TertiaryWashMix,
	MagneticBeadSeparationTertiaryWashMixType -> TertiaryWashMixType,
	MagneticBeadSeparationTertiaryWashMixTime -> TertiaryWashMixTime,
	MagneticBeadSeparationTertiaryWashMixRate -> TertiaryWashMixRate,
	NumberOfMagneticBeadSeparationTertiaryWashMixes -> NumberOfTertiaryWashMixes,
	MagneticBeadSeparationTertiaryWashMixVolume -> TertiaryWashMixVolume,
	MagneticBeadSeparationTertiaryWashMixTemperature -> TertiaryWashMixTemperature,
	MagneticBeadSeparationTertiaryWashMixTipType -> TertiaryWashMixTipType,
	MagneticBeadSeparationTertiaryWashMixTipMaterial -> TertiaryWashMixTipMaterial,
	TertiaryWashMagnetizationTime -> TertiaryWashMagnetizationTime,
	MagneticBeadSeparationTertiaryWashAspirationVolume -> TertiaryWashAspirationVolume,
	MagneticBeadSeparationTertiaryWashCollectionContainer -> TertiaryWashCollectionContainer,
	MagneticBeadSeparationTertiaryWashCollectionStorageCondition -> TertiaryWashCollectionStorageCondition,
	NumberOfMagneticBeadSeparationTertiaryWashes -> NumberOfTertiaryWashes,
	MagneticBeadSeparationTertiaryWashAirDry -> TertiaryWashAirDry,
	MagneticBeadSeparationTertiaryWashAirDryTime -> TertiaryWashAirDryTime,
	MagneticBeadSeparationQuaternaryWash -> QuaternaryWash,
	MagneticBeadSeparationQuaternaryWashSolution -> QuaternaryWashBuffer,
	MagneticBeadSeparationQuaternaryWashSolutionVolume -> QuaternaryWashBufferVolume,
	MagneticBeadSeparationQuaternaryWashMix -> QuaternaryWashMix,
	MagneticBeadSeparationQuaternaryWashMixType -> QuaternaryWashMixType,
	MagneticBeadSeparationQuaternaryWashMixTime -> QuaternaryWashMixTime,
	MagneticBeadSeparationQuaternaryWashMixRate -> QuaternaryWashMixRate,
	NumberOfMagneticBeadSeparationQuaternaryWashMixes -> NumberOfQuaternaryWashMixes,
	MagneticBeadSeparationQuaternaryWashMixVolume -> QuaternaryWashMixVolume,
	MagneticBeadSeparationQuaternaryWashMixTemperature -> QuaternaryWashMixTemperature,
	MagneticBeadSeparationQuaternaryWashMixTipType -> QuaternaryWashMixTipType,
	MagneticBeadSeparationQuaternaryWashMixTipMaterial -> QuaternaryWashMixTipMaterial,
	QuaternaryWashMagnetizationTime -> QuaternaryWashMagnetizationTime,
	MagneticBeadSeparationQuaternaryWashAspirationVolume -> QuaternaryWashAspirationVolume,
	MagneticBeadSeparationQuaternaryWashCollectionContainer -> QuaternaryWashCollectionContainer,
	MagneticBeadSeparationQuaternaryWashCollectionStorageCondition -> QuaternaryWashCollectionStorageCondition,
	NumberOfMagneticBeadSeparationQuaternaryWashes -> NumberOfQuaternaryWashes,
	MagneticBeadSeparationQuaternaryWashAirDry -> QuaternaryWashAirDry,
	MagneticBeadSeparationQuaternaryWashAirDryTime -> QuaternaryWashAirDryTime,
	MagneticBeadSeparationQuinaryWash -> QuinaryWash,
	MagneticBeadSeparationQuinaryWashSolution -> QuinaryWashBuffer,
	MagneticBeadSeparationQuinaryWashSolutionVolume -> QuinaryWashBufferVolume,
	MagneticBeadSeparationQuinaryWashMix -> QuinaryWashMix,
	MagneticBeadSeparationQuinaryWashMixType -> QuinaryWashMixType,
	MagneticBeadSeparationQuinaryWashMixTime -> QuinaryWashMixTime,
	MagneticBeadSeparationQuinaryWashMixRate -> QuinaryWashMixRate,
	NumberOfMagneticBeadSeparationQuinaryWashMixes -> NumberOfQuinaryWashMixes,
	MagneticBeadSeparationQuinaryWashMixVolume -> QuinaryWashMixVolume,
	MagneticBeadSeparationQuinaryWashMixTemperature -> QuinaryWashMixTemperature,
	MagneticBeadSeparationQuinaryWashMixTipType -> QuinaryWashMixTipType,
	MagneticBeadSeparationQuinaryWashMixTipMaterial -> QuinaryWashMixTipMaterial,
	QuinaryWashMagnetizationTime -> QuinaryWashMagnetizationTime,
	MagneticBeadSeparationQuinaryWashAspirationVolume -> QuinaryWashAspirationVolume,
	MagneticBeadSeparationQuinaryWashCollectionContainer -> QuinaryWashCollectionContainer,
	MagneticBeadSeparationQuinaryWashCollectionStorageCondition -> QuinaryWashCollectionStorageCondition,
	NumberOfMagneticBeadSeparationQuinaryWashes -> NumberOfQuinaryWashes,
	MagneticBeadSeparationQuinaryWashAirDry -> QuinaryWashAirDry,
	MagneticBeadSeparationQuinaryWashAirDryTime -> QuinaryWashAirDryTime,
	MagneticBeadSeparationSenaryWash -> SenaryWash,
	MagneticBeadSeparationSenaryWashSolution -> SenaryWashBuffer,
	MagneticBeadSeparationSenaryWashSolutionVolume -> SenaryWashBufferVolume,
	MagneticBeadSeparationSenaryWashMix -> SenaryWashMix,
	MagneticBeadSeparationSenaryWashMixType -> SenaryWashMixType,
	MagneticBeadSeparationSenaryWashMixTime -> SenaryWashMixTime,
	MagneticBeadSeparationSenaryWashMixRate -> SenaryWashMixRate,
	NumberOfMagneticBeadSeparationSenaryWashMixes -> NumberOfSenaryWashMixes,
	MagneticBeadSeparationSenaryWashMixVolume -> SenaryWashMixVolume,
	MagneticBeadSeparationSenaryWashMixTemperature -> SenaryWashMixTemperature,
	MagneticBeadSeparationSenaryWashMixTipType -> SenaryWashMixTipType,
	MagneticBeadSeparationSenaryWashMixTipMaterial -> SenaryWashMixTipMaterial,
	SenaryWashMagnetizationTime -> SenaryWashMagnetizationTime,
	MagneticBeadSeparationSenaryWashAspirationVolume -> SenaryWashAspirationVolume,
	MagneticBeadSeparationSenaryWashCollectionContainer -> SenaryWashCollectionContainer,
	MagneticBeadSeparationSenaryWashCollectionStorageCondition -> SenaryWashCollectionStorageCondition,
	NumberOfMagneticBeadSeparationSenaryWashes -> NumberOfSenaryWashes,
	MagneticBeadSeparationSenaryWashAirDry -> SenaryWashAirDry,
	MagneticBeadSeparationSenaryWashAirDryTime -> SenaryWashAirDryTime,
	MagneticBeadSeparationSeptenaryWash -> SeptenaryWash,
	MagneticBeadSeparationSeptenaryWashSolution -> SeptenaryWashBuffer,
	MagneticBeadSeparationSeptenaryWashSolutionVolume -> SeptenaryWashBufferVolume,
	MagneticBeadSeparationSeptenaryWashMix -> SeptenaryWashMix,
	MagneticBeadSeparationSeptenaryWashMixType -> SeptenaryWashMixType,
	MagneticBeadSeparationSeptenaryWashMixTime -> SeptenaryWashMixTime,
	MagneticBeadSeparationSeptenaryWashMixRate -> SeptenaryWashMixRate,
	NumberOfMagneticBeadSeparationSeptenaryWashMixes -> NumberOfSeptenaryWashMixes,
	MagneticBeadSeparationSeptenaryWashMixVolume -> SeptenaryWashMixVolume,
	MagneticBeadSeparationSeptenaryWashMixTemperature -> SeptenaryWashMixTemperature,
	MagneticBeadSeparationSeptenaryWashMixTipType -> SeptenaryWashMixTipType,
	MagneticBeadSeparationSeptenaryWashMixTipMaterial -> SeptenaryWashMixTipMaterial,
	SeptenaryWashMagnetizationTime -> SeptenaryWashMagnetizationTime,
	MagneticBeadSeparationSeptenaryWashAspirationVolume -> SeptenaryWashAspirationVolume,
	MagneticBeadSeparationSeptenaryWashCollectionContainer -> SeptenaryWashCollectionContainer,
	MagneticBeadSeparationSeptenaryWashCollectionStorageCondition -> SeptenaryWashCollectionStorageCondition,
	NumberOfMagneticBeadSeparationSeptenaryWashes -> NumberOfSeptenaryWashes,
	MagneticBeadSeparationSeptenaryWashAirDry -> SeptenaryWashAirDry,
	MagneticBeadSeparationSeptenaryWashAirDryTime -> SeptenaryWashAirDryTime,
	MagneticBeadSeparationElution -> Elution,
	MagneticBeadSeparationElutionSolution -> ElutionBuffer,
	MagneticBeadSeparationElutionSolutionVolume -> ElutionBufferVolume,
	MagneticBeadSeparationElutionMix -> ElutionMix,
	MagneticBeadSeparationElutionMixType -> ElutionMixType,
	MagneticBeadSeparationElutionMixTime -> ElutionMixTime,
	MagneticBeadSeparationElutionMixRate -> ElutionMixRate,
	NumberOfMagneticBeadSeparationElutionMixes -> NumberOfElutionMixes,
	MagneticBeadSeparationElutionMixVolume -> ElutionMixVolume,
	MagneticBeadSeparationElutionMixTemperature -> ElutionMixTemperature,
	MagneticBeadSeparationElutionMixTipType -> ElutionMixTipType,
	MagneticBeadSeparationElutionMixTipMaterial -> ElutionMixTipMaterial,
	ElutionMagnetizationTime -> ElutionMagnetizationTime,
	MagneticBeadSeparationElutionAspirationVolume -> ElutionAspirationVolume,
	MagneticBeadSeparationElutionCollectionContainer -> ElutionCollectionContainer,
	MagneticBeadSeparationElutionCollectionStorageCondition -> ElutionCollectionStorageCondition,
	NumberOfMagneticBeadSeparationElutions -> NumberOfElutions,
	MagneticBeadSeparationPreWashCollectionContainerLabel -> PreWashCollectionContainerLabel,
	MagneticBeadSeparationEquilibrationCollectionContainerLabel -> EquilibrationCollectionContainerLabel,
	MagneticBeadSeparationLoadingCollectionContainerLabel -> LoadingCollectionContainerLabel,
	MagneticBeadSeparationWashCollectionContainerLabel -> WashCollectionContainerLabel,
	MagneticBeadSeparationSecondaryWashCollectionContainerLabel -> SecondaryWashCollectionContainerLabel,
	MagneticBeadSeparationTertiaryWashCollectionContainerLabel -> TertiaryWashCollectionContainerLabel,
	MagneticBeadSeparationQuaternaryWashCollectionContainerLabel -> QuaternaryWashCollectionContainerLabel,
	MagneticBeadSeparationQuinaryWashCollectionContainerLabel -> QuinaryWashCollectionContainerLabel,
	MagneticBeadSeparationSenaryWashCollectionContainerLabel -> SenaryWashCollectionContainerLabel,
	MagneticBeadSeparationSeptenaryWashCollectionContainerLabel -> SeptenaryWashCollectionContainerLabel,
	MagneticBeadSeparationElutionCollectionContainerLabel -> ElutionCollectionContainerLabel
};

$MagneticBeadSeparationWashOptions = {MagneticBeadSeparationWash, MagneticBeadSeparationWashSolution, MagneticBeadSeparationWashSolutionVolume, MagneticBeadSeparationWashMix, MagneticBeadSeparationWashMixType, MagneticBeadSeparationWashMixTime, MagneticBeadSeparationWashMixRate, NumberOfMagneticBeadSeparationWashMixes, MagneticBeadSeparationWashMixVolume, MagneticBeadSeparationWashMixTemperature, MagneticBeadSeparationWashMixTipType, MagneticBeadSeparationWashMixTipMaterial, WashMagnetizationTime, MagneticBeadSeparationWashAspirationVolume, MagneticBeadSeparationWashCollectionContainer, MagneticBeadSeparationWashCollectionStorageCondition, NumberOfMagneticBeadSeparationWashes, MagneticBeadSeparationWashAirDry, MagneticBeadSeparationWashAirDryTime};

$MagneticBeadSeparationSecondaryWashOptions = {MagneticBeadSeparationSecondaryWash, MagneticBeadSeparationSecondaryWashSolution, MagneticBeadSeparationSecondaryWashSolutionVolume, MagneticBeadSeparationSecondaryWashMix, MagneticBeadSeparationSecondaryWashMixType, MagneticBeadSeparationSecondaryWashMixTime, MagneticBeadSeparationSecondaryWashMixRate, NumberOfMagneticBeadSeparationSecondaryWashMixes, MagneticBeadSeparationSecondaryWashMixVolume, MagneticBeadSeparationSecondaryWashMixTemperature, MagneticBeadSeparationSecondaryWashMixTipType, MagneticBeadSeparationSecondaryWashMixTipMaterial, SecondaryWashMagnetizationTime, MagneticBeadSeparationSecondaryWashAspirationVolume, MagneticBeadSeparationSecondaryWashCollectionContainer, MagneticBeadSeparationSecondaryWashCollectionStorageCondition, NumberOfMagneticBeadSeparationSecondaryWashes, MagneticBeadSeparationSecondaryWashAirDry, MagneticBeadSeparationSecondaryWashAirDryTime};

$MagneticBeadSeparationTertiaryWashOptions = {MagneticBeadSeparationTertiaryWash, MagneticBeadSeparationTertiaryWashSolution, MagneticBeadSeparationTertiaryWashSolutionVolume, MagneticBeadSeparationTertiaryWashMix, MagneticBeadSeparationTertiaryWashMixType, MagneticBeadSeparationTertiaryWashMixTime, MagneticBeadSeparationTertiaryWashMixRate, NumberOfMagneticBeadSeparationTertiaryWashMixes, MagneticBeadSeparationTertiaryWashMixVolume, MagneticBeadSeparationTertiaryWashMixTemperature, MagneticBeadSeparationTertiaryWashMixTipType, MagneticBeadSeparationTertiaryWashMixTipMaterial, TertiaryWashMagnetizationTime, MagneticBeadSeparationTertiaryWashAspirationVolume, MagneticBeadSeparationTertiaryWashCollectionContainer, MagneticBeadSeparationTertiaryWashCollectionStorageCondition, NumberOfMagneticBeadSeparationTertiaryWashes, MagneticBeadSeparationTertiaryWashAirDry, MagneticBeadSeparationTertiaryWashAirDryTime};

$MagneticBeadSeparationQuaternaryWashOptions = {MagneticBeadSeparationQuaternaryWash, MagneticBeadSeparationQuaternaryWashSolution, MagneticBeadSeparationQuaternaryWashSolutionVolume, MagneticBeadSeparationQuaternaryWashMix, MagneticBeadSeparationQuaternaryWashMixType, MagneticBeadSeparationQuaternaryWashMixTime, MagneticBeadSeparationQuaternaryWashMixRate, NumberOfMagneticBeadSeparationQuaternaryWashMixes, MagneticBeadSeparationQuaternaryWashMixVolume, MagneticBeadSeparationQuaternaryWashMixTemperature, MagneticBeadSeparationQuaternaryWashMixTipType, MagneticBeadSeparationQuaternaryWashMixTipMaterial, QuaternaryWashMagnetizationTime, MagneticBeadSeparationQuaternaryWashAspirationVolume, MagneticBeadSeparationQuaternaryWashCollectionContainer, MagneticBeadSeparationQuaternaryWashCollectionStorageCondition, NumberOfMagneticBeadSeparationQuaternaryWashes, MagneticBeadSeparationQuaternaryWashAirDry, MagneticBeadSeparationQuaternaryWashAirDryTime};

$MagneticBeadSeparationQuinaryWashOptions = {MagneticBeadSeparationQuinaryWash, MagneticBeadSeparationQuinaryWashSolution, MagneticBeadSeparationQuinaryWashSolutionVolume, MagneticBeadSeparationQuinaryWashMix, MagneticBeadSeparationQuinaryWashMixType, MagneticBeadSeparationQuinaryWashMixTime, MagneticBeadSeparationQuinaryWashMixRate, NumberOfMagneticBeadSeparationQuinaryWashMixes, MagneticBeadSeparationQuinaryWashMixVolume, MagneticBeadSeparationQuinaryWashMixTemperature, MagneticBeadSeparationQuinaryWashMixTipType, MagneticBeadSeparationQuinaryWashMixTipMaterial, QuinaryWashMagnetizationTime, MagneticBeadSeparationQuinaryWashAspirationVolume, MagneticBeadSeparationQuinaryWashCollectionContainer, MagneticBeadSeparationQuinaryWashCollectionStorageCondition, NumberOfMagneticBeadSeparationQuinaryWashes, MagneticBeadSeparationQuinaryWashAirDry, MagneticBeadSeparationQuinaryWashAirDryTime};

$MagneticBeadSeparationSenaryWashOptions = {MagneticBeadSeparationSenaryWash, MagneticBeadSeparationSenaryWashSolution, MagneticBeadSeparationSenaryWashSolutionVolume, MagneticBeadSeparationSenaryWashMix, MagneticBeadSeparationSenaryWashMixType, MagneticBeadSeparationSenaryWashMixTime, MagneticBeadSeparationSenaryWashMixRate, NumberOfMagneticBeadSeparationSenaryWashMixes, MagneticBeadSeparationSenaryWashMixVolume, MagneticBeadSeparationSenaryWashMixTemperature, MagneticBeadSeparationSenaryWashMixTipType, MagneticBeadSeparationSenaryWashMixTipMaterial, SenaryWashMagnetizationTime, MagneticBeadSeparationSenaryWashAspirationVolume, MagneticBeadSeparationSenaryWashCollectionContainer, MagneticBeadSeparationSenaryWashCollectionStorageCondition, NumberOfMagneticBeadSeparationSenaryWashes, MagneticBeadSeparationSenaryWashAirDry, MagneticBeadSeparationSenaryWashAirDryTime};

$MagneticBeadSeparationSeptenaryWashOptions = {MagneticBeadSeparationSeptenaryWash, MagneticBeadSeparationSeptenaryWashSolution, MagneticBeadSeparationSeptenaryWashSolutionVolume, MagneticBeadSeparationSeptenaryWashMix, MagneticBeadSeparationSeptenaryWashMixType, MagneticBeadSeparationSeptenaryWashMixTime, MagneticBeadSeparationSeptenaryWashMixRate, NumberOfMagneticBeadSeparationSeptenaryWashMixes, MagneticBeadSeparationSeptenaryWashMixVolume, MagneticBeadSeparationSeptenaryWashMixTemperature, MagneticBeadSeparationSeptenaryWashMixTipType, MagneticBeadSeparationSeptenaryWashMixTipMaterial, SeptenaryWashMagnetizationTime, MagneticBeadSeparationSeptenaryWashAspirationVolume, MagneticBeadSeparationSeptenaryWashCollectionContainer, MagneticBeadSeparationSeptenaryWashCollectionStorageCondition, NumberOfMagneticBeadSeparationSeptenaryWashes, MagneticBeadSeparationSeptenaryWashAirDry, MagneticBeadSeparationSeptenaryWashAirDryTime};


(* NOTE:Remember to call NonIndexMatchedExtractionMagneticBeadSharedOptions outside of index-matching in your experiment as well. *)
DefineOptionSet[ExtractionMagneticBeadSharedOptions:>{

	(* ---GENERAL OPTIONS--- *)
	
	{
		OptionName->MagneticBeadSeparationSampleVolume,
		Default->Automatic,
		Description->"The amount of sample that is added to the magnetic beads in order to allow binding of target analyte or contaminant to the magnetic beads after the magnetic beads are optionally prewashed and equilibrated.",
		ResolutionDescription->"Automatically set to the lesser of the input sample volume or 1 Milliliter.",
		AllowNull->True,
		Widget-> Alternatives[
			"Volume"->Widget[
				Type->Quantity,
				Pattern:>RangeP[$MinRoboticTransferVolume,$MaxRoboticTransferVolume],
				Units->{Microliter,{Microliter,Milliliter}}
			],
			"All"->Widget[
				Type->Enumeration,
				Pattern:>Alternatives[All]
			]
		],
		Category->"Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		AnalyteAffinityLabel,
		{
			OptionName->MagneticBeadSeparationAnalyteAffinityLabel,
			Default->Automatic,
			Description->"The target molecule in the sample that binds the immobilized ligand on the magnetic beads for affinity separation, applicable if MagneticBeadSeparationMode is set to Affinity. MagneticBeadSeparationAnalyteAffinityLabel is used to help set automatic options such as MagneticBeadAffinityLabel.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationAnalyteAffinityLabel specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationAnalyteAffinityLabel is set based on target cellular component of the experiment. Specifically, Automatically set to match target cellular component if MagneticBeadSeparationSelectionStrategy is set to Positive, and is set to the first non-target item in Analytes of the sample if MagneticBeadSeparationSelectionStrategy is set to Negative.",
			AllowNull->True,
			NestedIndexMatching->False,
			Category->"Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		MagneticBeadAffinityLabel,
		{
			OptionName->MagneticBeadAffinityLabel,
			Default->Automatic,
			Description->"The molecule immobilized on the magnetic beads that specifically binds the target analyte for affinity separation, applicable if MagneticBeadSeparationMode is set to Affinity. MagneticBeadAffinityLabel is used to help set automatic options such as MagneticBeads.",
			ResolutionDescription->"Automatically set to the MagneticBeadAffinityLabel specified by the selected Method. If Method is set to Custom, MagneticBeadAffinityLabel is automatically set to the first item in the Targets field of the target molecule object if MagneticBeadSeparationMode is set to Affinity. For example, if the target molecule is biotinylated, that molecule's Targets field is set to streptavidin.",
			AllowNull->True,
			NestedIndexMatching->False,
			Category->"Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		MagneticBeads,
		{
			OptionName->MagneticBeads,
			Default->Automatic,
			Description->"The superparamagnetic particles with surface coatings to bind target analyte or contaminants. They exhibit magnetic behavior only in the presence of an external magnetic field. The magnetic beads are pulled to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the supernatant.",
			ResolutionDescription->"Automatically set to the MagneticBeads specified by the selected Method. If Method is set to Custom, if MagneticBeadSeparationMode is Affinity, MagneticBeads is automatically set to the first found magnetic beads model with the affinity label of MagneticBeadAffinityLabel. Otherwise, MagneticBeads is automatically set according to the target cellular component and MagneticBeadSeparationMode. If the target is a non-mRNA nucleic acid (DNA, RNA, cDNA, plasmid DNA, etc.), MagneticBeads is automatically set to Model[Sample, \"Dynabeads MyOne SILANE Sample\"]. If the target is a protein or peptide, MagneticBeads is automatically set to Model[Sample,\"MagSi-proteomics C4\"] when MagneticBeadSeparationMode is ReversePhase, and set to Model[Sample,\"MagSi-WCX\"] when MagneticBeadSeparationMode is IonExchange. Otherwise, MagneticBeads is automatically set to Model[Sample, \"Mag-Bind Particles CNR (Mag-Bind Viral DNA/RNA Kit)\"]",
			AllowNull->True,
			NestedIndexMatching->False,
			Category->"Magnetic Bead Separation"
		}
	],
	{
		OptionName->MagneticBeadVolume,
		Default->Automatic,
		Description->"The volumetric amount of MagneticBeads that is added to the assay container prior to optional prewash and equilibration.",
		ResolutionDescription->"Automatically set to 1/10 of the maximum MagneticBeadSeparationSampleVolume across all input sample.",
		AllowNull->True,
		Widget->Widget[
			Type->Quantity,
			Pattern:>RangeP[$MinRoboticTransferVolume,$MaxRoboticTransferVolume],
			Units->{Microliter,{Microliter,Milliliter}}
		],
		NestedIndexMatching->False,
		Category->"Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		MagneticBeadCollectionStorageCondition,
		{
			OptionName->MagneticBeadCollectionStorageCondition,
			Default->Automatic,
			Description->"The non-default condition under which the used magnetic beads are stored after the protocol is completed.",
			AllowNull->True,
			Widget->Alternatives[
				"Condition"->Widget[
					Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal
				],
				"Objects"->Widget[
					Type->Object,
					Pattern:>ObjectP[Model[StorageCondition]],
					OpenPaths->{
						{Object[Catalog,"Root"],
							"Storage Conditions"}
					}
				]
			],
			NestedIndexMatching->False,
			ResolutionDescription->"Automatically set to Disposal if MagneticBeadSeparation is included in Purification.",
			Category->"Magnetic Bead Separation" 
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		MagnetizationRack,
		{
			OptionName->MagnetizationRack,
			Default->Automatic,
			Description->"The magnetic rack used during magnetization that provides the magnetic force to attract the magnetic beads.", 
			ResolutionDescription->"Automatically set to the MagnetizationRack specified by the selected Method. If Method is set to Custom, MagnetizationRack is automatically set to Model[Item, MagnetizationRack, \"Alpaqua 96S Super Magnet 96-well Plate Rack\"].",
			AllowNull->True,
			NestedIndexMatching->False,
			Category->"Magnetic Bead Separation" 
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		PreWashCollectionContainerLabel,
		{
			OptionName->MagneticBeadSeparationPreWashCollectionContainerLabel,
			Default->Automatic,
			AllowNull->True,
			Description->"The user defined word or phrase used to identify the container for collecting the aspirated used MagneticBeadSeparationPreWashSolution after the elapse of PreWashMagnetizationTime.",
			ResolutionDescription->"Automatically set to the previously specified label if the same container has already been labeled in an upstream unit operation within the same sample preparation protocol. Otherwise, set to \"MBS collection container #\".",
			Category->"Magnetic Bead Separation" ,
			NestedIndexMatching->False
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		EquilibrationCollectionContainerLabel,
		{
			OptionName->MagneticBeadSeparationEquilibrationCollectionContainerLabel,
			Default->Automatic,
			AllowNull->True,
			Description->"The user defined word or phrase used to identify the container for collecting the aspirated used MagneticBeadSeparationEquilibrationSolution after the elapse of EquilibrationMagnetizationTime.",
			ResolutionDescription->"Automatically set to the previously specified label if the same container has already been labeled in an upstream unit operation within the same sample preparation protocol. Otherwise, set to \"MBS collection container #\".",
			Category->"Magnetic Bead Separation" ,
			NestedIndexMatching->False
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		LoadingCollectionContainerLabel,
		{
			OptionName->MagneticBeadSeparationLoadingCollectionContainerLabel,
			Default->Automatic,
			AllowNull->True,
			Description->"The user defined word or phrase used to identify the container for collecting the aspirated sample containing components that are not bound to the magnetic beads after the elapse of EquilibrationMagnetizationTime.",
			ResolutionDescription->"Automatically set to the previously specified label if the same container has already been labeled in an upstream unit operation within the same sample preparation protocol. Otherwise, set to \"MBS collection container #\".",
			Category->"Magnetic Bead Separation" ,
			NestedIndexMatching->False
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		WashCollectionContainerLabel,
		{
			OptionName->MagneticBeadSeparationWashCollectionContainerLabel,
			Default->Automatic,
			AllowNull->True,
			Description->"The user defined word or phrase used to identify the container for collecting the aspirated used MagneticBeadSeparationWashSolution after the elapse of WashMagnetizationTime.",
			ResolutionDescription->"Automatically set to the previously specified label if the same container has already been labeled in an upstream unit operation within the same sample preparation protocol. Otherwise, set to \"MBS collection container #\".",
			Category->"Magnetic Bead Separation" ,
			NestedIndexMatching->False
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		SecondaryWashCollectionContainerLabel,
		{
			OptionName->MagneticBeadSeparationSecondaryWashCollectionContainerLabel,
			Default->Automatic,
			AllowNull->True,
			Description->"The user defined word or phrase used to identify the container for collecting the aspirated used MagneticBeadSeparationSecondaryWashSolution after the elapse of SecondaryWashMagnetizationTime.",
			ResolutionDescription->"Automatically set to the previously specified label if the same container has already been labeled in an upstream unit operation within the same sample preparation protocol. Otherwise, set to \"MBS collection container #\".",
			Category->"Magnetic Bead Separation" ,
			NestedIndexMatching->False
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		TertiaryWashCollectionContainerLabel,
		{
			OptionName->MagneticBeadSeparationTertiaryWashCollectionContainerLabel,
			Default->Automatic,
			AllowNull->True,
			Description->"The user defined word or phrase used to identify the container for collecting the aspirated used MagneticBeadSeparationTertiarySolution after the elapse of TertiaryWashMagnetizationTime.",
			ResolutionDescription->"Automatically set to the previously specified label if the same container has already been labeled in an upstream unit operation within the same sample preparation protocol. Otherwise, set to \"MBS collection container #\".",
			Category->"Magnetic Bead Separation" ,
			NestedIndexMatching->False
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		QuaternaryWashCollectionContainerLabel,
		{
			OptionName->MagneticBeadSeparationQuaternaryWashCollectionContainerLabel,
			Default->Automatic,
			AllowNull->True,
			Description->"The user defined word or phrase used to identify the container for collecting the aspirated used MagneticBeadSeparationQuaternaryWashSolution after the elapse of QuaternaryWashMagnetizationTime.",
			ResolutionDescription->"Automatically set to the previously specified label if the same container has already been labeled in an upstream unit operation within the same sample preparation protocol. Otherwise, set to \"MBS collection container #\".",
			Category->"Magnetic Bead Separation" ,
			NestedIndexMatching->False
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		QuinaryWashCollectionContainerLabel,
		{
			OptionName->MagneticBeadSeparationQuinaryWashCollectionContainerLabel,
			Default->Automatic,
			AllowNull->True,
			Description->"The user defined word or phrase used to identify the container for collecting the aspirated used MagneticBeadSeparationQuinaryWashSolution after the elapse of QuinaryWashMagnetizationTime.",
			ResolutionDescription->"Automatically set to the previously specified label if the same container has already been labeled in an upstream unit operation within the same sample preparation protocol. Otherwise, set to \"MBS collection container #\".",
			Category->"Magnetic Bead Separation" ,
			NestedIndexMatching->False
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		SenaryWashCollectionContainerLabel,
		{
			OptionName->MagneticBeadSeparationSenaryWashCollectionContainerLabel,
			Default->Automatic,
			AllowNull->True,
			Description->"The user defined word or phrase used to identify the container for collecting the aspirated used MagneticBeadSeparationSenaryWashSolution after the elapse of SenaryWashMagnetizationTime.",
			ResolutionDescription->"Automatically set to the previously specified label if the same container has already been labeled in an upstream unit operation within the same sample preparation protocol. Otherwise, set to \"MBS collection container #\".",
			Category->"Magnetic Bead Separation" ,
			NestedIndexMatching->False
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		SeptenaryWashCollectionContainerLabel,
		{
			OptionName->MagneticBeadSeparationSeptenaryWashCollectionContainerLabel,
			Default->Automatic,
			AllowNull->True,
			Description->"The user defined word or phrase used to identify the container for collecting the aspirated used MagneticBeadSeparationSeptenaryWashSolution after the elapse of SeptenaryWashMagnetizationTime.",
			ResolutionDescription->"Automatically set to the previously specified label if the same container has already been labeled in an upstream unit operation within the same sample preparation protocol. Otherwise, set to \"MBS collection container #\".",
			Category->"Magnetic Bead Separation" ,
			NestedIndexMatching->False
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		ElutionCollectionContainerLabel,
		{
			OptionName->MagneticBeadSeparationElutionCollectionContainerLabel,
			Default->Automatic,
			AllowNull->True,
			Description->"The user defined word or phrase used to identify the container for collecting the aspirated samples after the elapse of ElutionMagnetizationTime.",
			ResolutionDescription->"Automatically set to the previously specified label if the same container has already been labeled in an upstream unit operation within the same sample preparation protocol. Otherwise, set to \"MBS collection container #\".",
			Category->"Magnetic Bead Separation" ,
			NestedIndexMatching->False
		}
	],

	(*--- PREWASH OPTIONS---*)

	ModifyOptions[ExperimentMagneticBeadSeparation,
		PreWash,
		{
			OptionName->MagneticBeadSeparationPreWash,
			Default->Automatic,
			Description->"Indicates if the magnetic beads are rinsed prior to equilibration in order to remove the storage buffer.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationPreWash specified by the selected Method. If Method is set to Custom, automatically set to True if other MagneticBeadSeparationPreWash options are set, or False otherwise.", 
			AllowNull->True,
			NestedIndexMatching->False,
			Category->"Magnetic Bead Separation" 
		}
	],

	ModifyOptions[ExperimentMagneticBeadSeparation,
		PreWashBuffer,
		{
			OptionName -> MagneticBeadSeparationPreWashSolution,
			Default -> Automatic,
			Description -> "The solution used to rinse the magnetic beads in order to remove the storage buffer prior to equilibration.",
			ResolutionDescription -> "Automatically set to the MagneticBeadSeparationPreWashSolution specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationPreWashSolution is automatically set to match the MagneticBeadSeparationElutionSolution if MagneticBeadSeparationPreWash is set to True.", 
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation" 
		}
	],
	{
		OptionName -> MagneticBeadSeparationPreWashSolutionVolume,
		Description -> "The amount of MagneticBeadSeparationPreWashSolution that is added to the magnetic beads for each prewash prior to equilibration.", 
		ResolutionDescription -> "Automatically set to the same as the sample volume to load (MagneticBeadSeparationSampleVolume) if MagneticBeadSeparationPreWash is set to True.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> RangeP[$MinRoboticTransferVolume, $MaxRoboticTransferVolume], 
			Units -> {Microliter, {Microliter, Milliliter}}
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		PreWashMix,
		{
			OptionName -> MagneticBeadSeparationPreWashMix,
			Description -> "Indicates if the solution is mixed following combination of MagneticBeadSeparationPreWashSolution and the magnetic beads during each prewash.", 
			ResolutionDescription -> "Automatically set to the MagneticBeadSeparationPreWashMix specified by the selected Method. If Method is Custom, MagneticBeadSeparationPreWashMix is automatically set to True if MagneticBeadSeparationPreWash is set to Tru and MagneticBeadSeparationPreWashMixType is not set to Null.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName -> MagneticBeadSeparationPreWashMixType,
		AllowNull -> True,
		Default -> Automatic,
		Widget -> Widget[
			Type -> Enumeration,
			Pattern :> Shake | Pipette
		], 
		Description -> "The style of motion used to mix the suspension following the addition of the MagneticBeadSeparationPreWashSolution to the magnetic beads.", 
		ResolutionDescription -> "Automatically set to the MagneticBeadSeparationPreWashMixType specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationPreWashMix is set to True, MagneticBeadSeparationPreWashMixType is automatically set based on the volume-to-mix (i.e. the volume of the combined MagneticBeadSeparationPreWashSolution and magnetic beads) and the preWash mix options. Specifically, MagneticBeadSeparationPreWashMixType is automatically set to Pipette when the volume-to-mix is greater than 20 Microliter and none of MagneticBeadSeparationPreWashMixRate, MagneticBeadSeparationPreWashMixTemperature, and MagneticBeadSeparationPreWashMixTime is specified to non-default values. Otherwise, MagneticBeadSeparationPreWashMixType is automatically set to Shake.",
		NestedIndexMatching -> False,
		Category -> "Magnetic Bead Separation"
		},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		PreWashMixTime,
		{
			OptionName -> MagneticBeadSeparationPreWashMixTime,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "The duration during which the combined MagneticBeadSeparationPreWashSolution and magnetic beads are mixed by the selected MagneticBeadSeparationPreWashMixType.", 
			ResolutionDescription -> "Automatically set to the MagneticBeadSeparationPreWashMixTime specified by the selected Method. If Method is set to Custom, automatically set to 5 Minute if MagneticBeadSeparationPreWashMixType is set to Shake.", 
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName -> MagneticBeadSeparationPreWashMixRate,
		Description -> "The number of rotations per minute at which the combined MagneticBeadSeparationPreWashSolution and magnetic beads is shaken in order to fully mix.",
		ResolutionDescription -> "Automatically set to the MagneticBeadSeparationPreWashMixRate specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationPreWashMixType is set to Shake, MagneticBeadSeparationPreWashMixRate is automatically set to 300 RPM.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> RangeP[$MinBioSTARMixRate, $MaxBioSTARMixRate],
			Units -> RPM
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		NumberOfPreWashMixes,
		{
			OptionName -> NumberOfMagneticBeadSeparationPreWashMixes,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "The number of times that the combined MagneticBeadSeparationPreWashSolution and magnetic beads is mixed by pipetting the MagneticBeadSeparationPreWashMixVolume up and down following the addition of MagneticBeadSeparationPreWashSolution to the magnetic beads during each prewash in order to fully mix.", 
			ResolutionDescription -> "Automatically set to the NumberOfMagneticBeadSeparationPreWashMixes specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationPreWashMixType is set to Pipette, NumberOfMagneticBeadSeparationPreWashMixes is automatically set to 10.",
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName -> MagneticBeadSeparationPreWashMixVolume,
		Description -> "The volume of the combined MagneticBeadSeparationPreWashSolution and magnetic beads that is displaced during each mix-by-pipette mix cycle.",
		ResolutionDescription -> "Automatically set to 970 Microliter if 1/2*volume-to-mix (i.e.volume-to-mix is the volume of the combined MagneticBeadSeparationPreWashSolution and magnetic beads) is greater than 970 Microliter, and otherwise is set to the greater of 10 Microliter and 1/2*volume-to-mix.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> RangeP[$MinRoboticTransferVolume, $MaxRoboticSingleTransferVolume],
			Units -> {Microliter, {Microliter, Milliliter}}
		],
		Category -> "Magnetic Bead Separation"
	},
	{
		OptionName -> MagneticBeadSeparationPreWashMixTemperature,
		Description -> "The temperature at which the Instrument heating or cooling the combined MagneticBeadSeparationPreWashSolution and magnetic beads is maintained during the MagneticBeadSeparationPreWashMix, which occurs after adding MagneticBeadSeparationPreWashSolution to the magnetic beads and before the MagneticBeadSeparationPreWashMagnetizationTime.",
		ResolutionDescription -> "Automatically set to the MagneticBeadSeparationPreWashMixTemperature specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationPreWashMixType is not Null, MagneticBeadSeparationPreWashMixTemperature is automatically set to Ambient.", (*Need to change for different targets*)
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Alternatives[
			Widget[
				Type -> Quantity,
				Pattern :> RangeP[$MinRoboticIncubationTemperature, $MaxRoboticIncubationTemperature],
				Units -> {Celsius, {Celsius, Fahrenheit}}
			],
			Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[Ambient]
			]
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		PreWashMixTipType,
		{
			OptionName -> MagneticBeadSeparationPreWashMixTipType,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "The type of pipette tips used to mix the combined MagneticBeadSeparationPreWashSolution and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator.",
			ResolutionDescription -> "Automatically set to WideBore if MagneticBeadSeparationPreWashMixType is Pipette.",
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		PreWashMixTipMaterial,
		{
			OptionName -> MagneticBeadSeparationPreWashMixTipMaterial,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "The material of the pipette tips used to aspirate and dispense the requested volume during the MagneticBeadSeparationPreWashMix.",
			ResolutionDescription -> "Automatically set to Polypropylene if MagneticBeadSeparationPreWashMixType is Pipette.",
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],

	ModifyOptions[ExperimentMagneticBeadSeparation,
		PreWashMagnetizationTime,
		{
			OptionName -> PreWashMagnetizationTime,
			Description -> "The duration of magnetizing the magnetic beads after MagneticBeadSeparationPreWashMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used MagneticBeadSeparationPreWashSolution.",
			ResolutionDescription -> "Automatically set to the PreWashMagnetizationTime specified by the selected Method. If Method is set to Custom, PreWashMagnetizationTime is automatically set to 5 minutes if MagneticBeadSeparationPreWash is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName -> MagneticBeadSeparationPreWashAspirationVolume,
		Description -> "The volume of used MagneticBeadSeparationPreWashSolution to aspirate out while the magnetic beads are magnetized and gathered to the side after the elapse of PreWashMagnetizationTime during each prewash.",
		ResolutionDescription -> "Automatically set to the MagneticBeadSeparationPreWashAspirationVolume specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationPreWashAspirationVolume is automatically set to the MagneticBeadSeparationPreWashSolutionVolume if MagneticBeadSeparationPreWash is True.", 
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Alternatives[
			"All" -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[All]
			],
			"Volume" -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[$MinRoboticTransferVolume, $MaxRoboticTransferVolume],
				Units -> {Microliter, {Microliter, Milliliter}}
			]
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		PreWashCollectionContainer,
		{
			OptionName -> MagneticBeadSeparationPreWashCollectionContainer,
			Description -> "The container used to collect the aspirated used MagneticBeadSeparationPreWashSolution during the prewash(es) prior to equilibration.",
			ResolutionDescription -> "Automatically set to the MagneticBeadSeparationPreWashCollectionContainer specified by the selected Method. Otherwise set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"].",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		PreWashCollectionStorageCondition,
		{
			OptionName -> MagneticBeadSeparationPreWashCollectionStorageCondition,
			Description -> "The non-default condition under which the aspirate used MagneticBeadSeparationPreWashSolution during the prewashes prior to equilibration are stored after the protocol is completed.",
			ResolutionDescription -> "Automatically set to the MagneticBeadSeparationPreWashCollectionStorageCondition specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationPreWashCollectionStorageCondition is automatically set to Refrigerator if MagneticBeadSeparationPreWash is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		NumberOfPreWashes,
		{
			OptionName -> NumberOfMagneticBeadSeparationPreWashes,
			Description -> "The number of times that the magnetic beads are washed by adding MagneticBeadSeparationPreWashSolution, mixing, magnetization, and aspirating solution prior to equilibration.",
			ResolutionDescription -> "Automatically set to the NumberOfMagneticBeadSeparationPreWashes specified by the selected Method. If Method is set to Custom, NumberOfMagneticBeadSeparationPreWashes is automatically set to 1 if MagneticBeadSeparationPreWash is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		PreWashAirDry,
		{
			OptionName -> MagneticBeadSeparationPreWashAirDry,
			Description -> "Indicates if the magnetic beads are exposed to open air to evaporate the remaining MagneticBeadSeparationPreWashSolution following the final prewash prior to equilibration.",
			ResolutionDescription -> "Automatically set to the MagneticBeadSeparationPreWashAirDry specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationPreWashAirDry is automatically set to False if MagneticBeadSeparationPreWash is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		PreWashAirDryTime,
		{
			OptionName -> MagneticBeadSeparationPreWashAirDryTime,
			Default -> Automatic,
			Description -> "The duration that the magnetic beads are exposed to open air to evaporate the remaining MagneticBeadSeparationPreWashSolution following the final prewash prior to equilibration.",
			ResolutionDescription -> "Automatically set to the MagneticBeadSeparationPreWashAirDryTime specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationPreWashAirDryTime is automatically set to 1 Minute if MagneticBeadSeparationPreWashAirDry is set to True.",
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],

	(*--- EQUILIBRATION OPTIONS---*)

	ModifyOptions[ExperimentMagneticBeadSeparation,
		Equilibration,
		{
			OptionName->MagneticBeadSeparationEquilibration,
			Default->Automatic,
			Description->"Indicates if the magnetic beads are equilibrated to a condition for optimal bead-target binding prior to adding the samples to the magnetic beads.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationEquilibration specified by the selected Method. If Method is set to Custom, automatically set to True if other MagneticBeadSeparationEquilibration options are set, or False otherwise.", 
			AllowNull->True,
			NestedIndexMatching->False,
			Category->"Magnetic Bead Separation" 
		}
	],

	ModifyOptions[ExperimentMagneticBeadSeparation,
		EquilibrationBuffer,
		{
			OptionName->MagneticBeadSeparationEquilibrationSolution,
			Description->"The solution that is added to the magnetic beads in order to equilibrate them to a condition for optimal bead-target binding prior to sample loading.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationEquilibrationSolution specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationEquilibrationSolution is automatically set to Model[Sample,\"Milli-Q water\"] if MagneticBeadSeparationEquilibration is set to True.",
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName -> MagneticBeadSeparationEquilibrationSolutionVolume,
		Description -> "The amount of MagneticBeadSeparationEquilibrationSolution that is added to the magnetic beads in order to equilibrate them to a condition for optimal bead-target binding prior to sample loading.", 
		ResolutionDescription -> "If MagneticBeadSeparationEquilibration is set to True, MagneticBeadSeparationEquilibrationSolutionVolume is automatically set to MagneticBeadSeparationPreWashSolutionVolume when MagneticBeadSeparationPreWash is set to True, and is set to MagneticBeadSeparationSampleVolume when MagneticBeadSeparationPreWash is set to False.",
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> RangeP[$MinRoboticTransferVolume, $MaxRoboticTransferVolume], 
			Units -> {Microliter, {Microliter, Milliliter}}
		],
		AllowNull->True,
		Default->Automatic,
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		EquilibrationMix,
		{
			OptionName->MagneticBeadSeparationEquilibrationMix,
			Description->"Indicates if the solution is mixed following combination of MagneticBeadSeparationEquilibrationSolution and the magnetic beads.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationEquilibrationMix specified by the selected Method. If Method is Custom, MagneticBeadSeparationEquilibrationMix is automatically set to True if MagneticBeadSeparationEquilibration is set to True and MagneticBeadSeparationEquilibrationMixType is not set to Null.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName -> MagneticBeadSeparationEquilibrationMixType,
		Description -> "The style of motion used to mix the suspension following the addition of the MagneticBeadSeparationEquilibrationSolution to the magnetic beads.",
		ResolutionDescription -> "Automatically set to the MagneticBeadSeparationEquilibrationMixType specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationEquilibrationMix is set to True, MagneticBeadSeparationEquilibrationMixType is automatically set based on the volume-to-mix (i.e. the volume of the combined MagneticBeadSeparationEquilibrationSolution and magnetic beads) and the equilibration mix options. Specifically, MagneticBeadSeparationEquilibrationMixType is automatically set to Pipette when the volume-to-mix is greater than 20 Microliter and none of MagneticBeadSeparationEquilibrationMixRate, MagneticBeadSeparationEquilibrationMixTemperature, and MagneticBeadSeparationEquilibrationMixTime is specified to non-default values. Otherwise, MagneticBeadSeparationEquilibrationMixType is automatically set to Shake.",
		AllowNull -> True,
		Default -> Automatic,
		Widget -> Widget[
			Type -> Enumeration,
			Pattern :> Shake | Pipette
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		EquilibrationMixTime, 
		{
			OptionName -> MagneticBeadSeparationEquilibrationMixTime,
			Description -> "The duration during which the combined MagneticBeadSeparationEquilibrationSolution and magnetic beads are mixed by the selected MagneticBeadSeparationEquilibrationMixType.",
			ResolutionDescription -> "Automatically set to the MagneticBeadSeparationEquilibrationMixTime specified by the selected Method. If Method is set to Custom, automatically set to 5 Minute if MagneticBeadSeparationEquilibrationMixType is set to Shake.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName->MagneticBeadSeparationEquilibrationMixRate,
		Description->"The number of rotations per minute at which the combined MagneticBeadSeparationEquilibrationSolution and magnetic beads is shaken in order to fully mix.",
		ResolutionDescription->"Automatically set to the MagneticBeadSeparationEquilibrationMixRate specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationEquilibrationMixType is set to Shake, MagneticBeadSeparationEquilibrationMixRate is automatically set to 300 RPM.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> RangeP[$MinBioSTARMixRate, $MaxBioSTARMixRate],
			Units -> RPM
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		NumberOfEquilibrationMixes,
		{
			OptionName->NumberOfMagneticBeadSeparationEquilibrationMixes,
			Description->"The number of times that the combined MagneticBeadSeparationEquilibrationSolution and magnetic beads is mixed by pipetting the MagneticBeadSeparationEquilibrationMixVolume up and down following the addition of MagneticBeadSeparationEquilibrationSolution to the magnetic beads in order to fully mix.", 
			ResolutionDescription->"Automatically set to the NumberOfMagneticBeadSeparationEquilibrationMixes specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationEquilibrationMixType is set to Pipette, NumberOfMagneticBeadSeparationEquilibrationMixes is automatically set to 10.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName->MagneticBeadSeparationEquilibrationMixVolume,
		Description->"The volume of the combined MagneticBeadSeparationEquilibrationSolution and magnetic beads that is displaced during each mix-by-pipette mix cycle.",
		ResolutionDescription->"Automatically set to 970 Microliter if 1/2*volume-to-mix (i.e.volume-to-mix is the volume of the combined MagneticBeadSeparationEquilibrationSolution and magnetic beads) is greater than 970 Microliter, and otherwise is set to the greater of 10 Microliter and 1/2*volume-to-mix.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> RangeP[$MinRoboticTransferVolume, $MaxRoboticSingleTransferVolume],
			Units -> {Microliter, {Microliter, Milliliter}}
		],
		Category -> "Magnetic Bead Separation"
	},
	{
		OptionName->MagneticBeadSeparationEquilibrationMixTemperature,
		Description->"The temperature at which the Instrument heating or cooling the combined MagneticBeadSeparationEquilibrationSolution and magnetic beads is maintained during the MagneticBeadSeparationEquilibrationMix, which occurs after adding MagneticBeadSeparationEquilibrationSolution to the magnetic beads and before the EquilibrationMagnetizationTime.",
		ResolutionDescription->"Automatically set to the MagneticBeadSeparationEquilibrationMixTemperature specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationEquilibrationMixType is not Null, MagneticBeadSeparationEquilibrationMixTemperature is automatically set to Ambient.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Alternatives[
			Widget[
				Type -> Quantity,
				Pattern :> RangeP[$MinRoboticIncubationTemperature, $MaxRoboticIncubationTemperature],
				Units -> {Celsius, {Celsius, Fahrenheit}}
			],
			Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[Ambient]
			]
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		EquilibrationMixTipType,
		{
			OptionName -> MagneticBeadSeparationEquilibrationMixTipType,
			Description -> "The type of pipette tips used to mix the combined MagneticBeadSeparationEquilibrationSolution and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator.",
			ResolutionDescription -> "Automatically set to WideBore if MagneticBeadSeparationEquilibrationMixType is Pipette.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		EquilibrationMixTipMaterial,
		{
			OptionName -> MagneticBeadSeparationEquilibrationMixTipMaterial,
			Description -> "The material of the pipette tips used to aspirate and dispense the requested volume during the MagneticBeadSeparationEquilibrationMix.",
			ResolutionDescription -> "Automatically set to Polypropylene if MagneticBeadSeparationEquilibrationMixType is Pipette.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		EquilibrationMagnetizationTime,
		{
			OptionName->EquilibrationMagnetizationTime,
			Description->"The duration of magnetizing the magnetic beads after MagneticBeadSeparationEquilibrationMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used MagneticBeadSeparationEquilibrationSolution.",
			ResolutionDescription->"Automatically set to the EquilibrationMagnetizationTime specified by the selected Method. If Method is set to Custom, EquilibrationMagnetizationTime is automatically set to 5 minutes if MagneticBeadSeparationEquilibration is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName->MagneticBeadSeparationEquilibrationAspirationVolume,
		Description->"The volume of used MagneticBeadSeparationEquilibrationSolution to aspirate out while the magnetic beads are magnetized and gathered to the side after the elapse of EquilibrationMagnetizationTime.",
		ResolutionDescription->"Automatically set to the MagneticBeadSeparationEquilibrationAspirationVolume specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationEquilibrationAspirationVolume is automatically set to the MagneticBeadSeparationEquilibrationSolutionVolume if MagneticBeadSeparationEquilibration is True.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Alternatives[
			"All" -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[All]
			],
			"Volume" -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[$MinRoboticTransferVolume, $MaxRoboticTransferVolume],
				Units -> {Microliter, {Microliter, Milliliter}}
			]
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		EquilibrationCollectionContainer,
		{
			OptionName->MagneticBeadSeparationEquilibrationCollectionContainer,
			Description->"The container used to collect the used MagneticBeadSeparationEquilibrationSolution during the equilibration.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationEquilibrationCollectionContainer specified by the selected Method. Otherwise set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"].",
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Alternatives[
				"Container" -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Container], Model[Container]}]
				],
				"Container with Index" -> {
					"Index" -> Widget[
						Type -> Number,
						Pattern :> GreaterEqualP[1, 1]
					],
					"Container" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Container]}],
						PreparedSample -> False,
						PreparedContainer -> False
					]
				},
				"Container with Well" -> {
					"Well" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
						PatternTooltip -> "Enumeration must be any well from A1 to P24."
					],
					"Container" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Object[Container],Model[Container]}],
						PreparedSample -> False,
						PreparedContainer -> False
					]
				},
				"Container with Well and Index" -> {
					"Well" -> Widget[
						Type->Enumeration,
						Pattern:>Alternatives@@Flatten[AllWells[NumberOfWells->384]],
						PatternTooltip->"Enumeration must be any well from A1 to P24."
					],
					"Index and Container" -> {
						"Index" -> Widget[
							Type -> Number,
							Pattern :> GreaterEqualP[1, 1]
						],
						"Container" -> Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Container]}],
							PreparedSample -> False,
							PreparedContainer -> False
						]
					}
				}
			],
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		EquilibrationCollectionStorageCondition,
		{
			OptionName->MagneticBeadSeparationEquilibrationCollectionStorageCondition,
			Description->"The non-default condition under which the aspirated used MagneticBeadSeparationEquilibrationSolution during equilibration are stored after the protocol is completed.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationEquilibrationCollectionStorageCondition specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationEquilibrationCollectionStorageCondition is automatically set to Refrigerator if MagneticBeadSeparationEquilibration is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		EquilibrationAirDry,
		{
			OptionName->MagneticBeadSeparationEquilibrationAirDry,
			Description->"Indicates if the magnetic beads are exposed to open air to evaporate the remaining solution after aspiration of the used MagneticBeadSeparationEquilibrationSolution and prior to sample loading.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationEquilibrationAirDry specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationEquilibrationAirDry is automatically set to False if MagneticBeadSeparationEquilibration is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		EquilibrationAirDryTime,
		{
			OptionName->MagneticBeadSeparationEquilibrationAirDryTime,
			Description->"The duration that the magnetic beads are exposed to open air to evaporate the remaining MagneticBeadSeparationEquilibrationSolution after aspiration of the used MagneticBeadSeparationEquilibrationSolution and prior to sample loading.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationEquilibrationAirDryTime specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationEquilibrationAirDryTime is automatically set to 1 Minute if MagneticBeadSeparationEquilibrationAirDry is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],

	(*--- LOADING OPTIONS---*)

	ModifyOptions[ExperimentMagneticBeadSeparation,
		LoadingMix,
		{
			OptionName->MagneticBeadSeparationLoadingMix,
			Description->"Indicates if the solution is mixed following combination of the sample and the magnetic beads.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationLoadingMix specified by the selected Method. If Method is Custom, MagneticBeadSeparationLoadingMix is automatically set to True and MagneticBeadSeparationLoadingMixType is not set to Null.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName -> MagneticBeadSeparationLoadingMixType,
		Description -> "The style of motion used to mix the suspension following the addition of the sample to the magnetic beads.",
		ResolutionDescription -> "Automatically set to the MagneticBeadSeparationLoadingMixType specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationLoadingMix is set to True, MagneticBeadSeparationLoadingMixType is automatically set based on the volume-to-mix (i.e. the volume of the combined sample and magnetic beads) and the loading mix options. Specifically, MagneticBeadSeparationLoadingMixType is automatically set to Pipette when the volume-to-mix is greater than 20 Microliter and none of MagneticBeadSeparationLoadingMixRate, MagneticBeadSeparationLoadingMixTemperature, and MagneticBeadSeparationLoadingMixTime is specified to non-default values. Otherwise, MagneticBeadSeparationLoadingMixType is automatically set to Shake.",
		AllowNull -> True,
		Default -> Automatic,
		Widget -> Widget[
			Type -> Enumeration,
			Pattern :> Shake | Pipette
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		LoadingMixTime,
		{
			OptionName -> MagneticBeadSeparationLoadingMixTime,
			Description -> "The duration during which the combined sample and magnetic beads are mixed by the selected MagneticBeadSeparationLoadingMixType.",
			ResolutionDescription -> "Automatically set to the MagneticBeadSeparationLoadingMixTime specified by the selected Method. If Method is set to Custom, automatically set to 5 Minute if MagneticBeadSeparationLoadingMixType is set to Shake.",
			Default -> Automatic,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName->MagneticBeadSeparationLoadingMixRate,
		Description->"The number of rotations per minute at which the combined sample and magnetic beads is shaken in order to fully mix.",
		ResolutionDescription->"Automatically set to the MagneticBeadSeparationLoadingMixRate specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationLoadingMixType is set to Shake, MagneticBeadSeparationLoadingMixRate is automatically set to 300 RPM.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> RangeP[$MinBioSTARMixRate, $MaxBioSTARMixRate],
			Units -> RPM
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		NumberOfLoadingMixes,
		{
			OptionName->NumberOfMagneticBeadSeparationLoadingMixes,
			Description->"The number of times that the combined sample and magnetic beads is mixed by pipetting the MagneticBeadSeparationLoadingMixVolume up and down following the addition of sample to the magnetic beads in order to fully mix.", 
			ResolutionDescription->"Automatically set to the NumberOfMagneticBeadSeparationLoadingMixes specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationLoadingMixType is set to Pipette, NumberOfMagneticBeadSeparationLoadingMixes is automatically set to 10.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName->MagneticBeadSeparationLoadingMixVolume,
		Description->"The volume of the combined sample and magnetic beads that is displaced during each mix-by-pipette mix cycle.",
		ResolutionDescription->"Automatically set to 970 Microliter if 1/2*volume-to-mix (i.e.volume-to-mix is the volume of the combined sample and magnetic beads) is greater than 970 Microliter, and otherwise is set to the greater of 10 Microliter and 1/2*volume-to-mix.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> RangeP[$MinRoboticTransferVolume, $MaxRoboticSingleTransferVolume],
			Units -> {Microliter, {Microliter, Milliliter}}
		],
		Category -> "Magnetic Bead Separation"
	},
	{
		OptionName->MagneticBeadSeparationLoadingMixTemperature,
		Description->"The temperature at which the Instrument heating or cooling the combined sample and magnetic beads is maintained during the MagneticBeadSeparationLoadingMix, which occurs after adding sample to the magnetic beads and before the LoadingMagnetizationTime.",
		ResolutionDescription->"Automatically set to the MagneticBeadSeparationLoadingMixTemperature specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationLoadingMixType is not Null, MagneticBeadSeparationLoadingMixTemperature is automatically set to Ambient.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Alternatives[
			Widget[
				Type -> Quantity,
				Pattern :> RangeP[$MinRoboticIncubationTemperature, $MaxRoboticIncubationTemperature],
				Units -> {Celsius, {Celsius, Fahrenheit}}
			],
			Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[Ambient]
			]
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		LoadingMixTipType,
		{
			OptionName -> MagneticBeadSeparationLoadingMixTipType,
			Description -> "The type of pipette tips used to mix the combined sample and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator.",
			ResolutionDescription -> "Automatically set to WideBore if MagneticBeadSeparationLoadingMixType is Pipette.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		LoadingMixTipMaterial,
		{
			OptionName -> MagneticBeadSeparationLoadingMixTipMaterial,
			Description -> "The material of the pipette tips used to aspirate and dispense the requested volume during the MagneticBeadSeparationLoadingMix.",
			ResolutionDescription -> "Automatically set to Polypropylene if MagneticBeadSeparationLoadingMixType is Pipette.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		LoadingMagnetizationTime,
		{
			OptionName->LoadingMagnetizationTime,
			Description->"The duration of magnetizing the magnetic beads after MagneticBeadSeparationLoadingMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the sample solution containing components that are not bound to the magnetic beads.",
			ResolutionDescription->"Automatically set to the LoadingMagnetizationTime specified by the selected Method. If Method is set to Custom, LoadingMagnetizationTime is automatically set to 5 minutes.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName->MagneticBeadSeparationLoadingAspirationVolume,
		Description->"The volume of used sample to aspirate out while the magnetic beads are magnetized and gathered to the side after the elapse of LoadingMagnetizationTime.",
		ResolutionDescription->"Automatically set to the MagneticBeadSeparationLoadingAspirationVolume specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationLoadingAspirationVolume is automatically set to the MagneticBeadSeparationSampleVolume.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Alternatives[
			"All" -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[All]
			],
			"Volume" -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[$MinRoboticTransferVolume, $MaxRoboticTransferVolume],
				Units -> {Microliter, {Microliter, Milliliter}}
			]
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		LoadingCollectionContainer,
		{
			OptionName->MagneticBeadSeparationLoadingCollectionContainer,
			Description->"The container used to collect the sample solution containing components that are not bound to the magnetic beads after the elapse of LoadingMagnetizationTime.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationLoadingCollectionContainer specified by the selected Method. Otherwise set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"].",
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Alternatives[
				"Container" -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Container], Model[Container]}]
				],
				"Container with Index" -> {
					"Index" -> Widget[
						Type -> Number,
						Pattern :> GreaterEqualP[1, 1]
					],
					"Container" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Container]}],
						PreparedSample -> False,
						PreparedContainer -> False
					]
				},
				"Container with Well" -> {
					"Well" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
						PatternTooltip -> "Enumeration must be any well from A1 to P24."
					],
					"Container" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Object[Container],Model[Container]}],
						PreparedSample -> False,
						PreparedContainer -> False
					]
				},
				"Container with Well and Index" -> {
					"Well" -> Widget[
						Type->Enumeration,
						Pattern:>Alternatives@@Flatten[AllWells[NumberOfWells->384]],
						PatternTooltip->"Enumeration must be any well from A1 to P24."
					],
					"Index and Container" -> {
						"Index" -> Widget[
							Type -> Number,
							Pattern :> GreaterEqualP[1, 1]
						],
						"Container" -> Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Container]}],
							PreparedSample -> False,
							PreparedContainer -> False
						]
					}
				}
			],
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		LoadingCollectionStorageCondition,
		{
			OptionName->MagneticBeadSeparationLoadingCollectionStorageCondition,
			Description->"The non-default condition under which the aspirated sample solution containing components that are not bound to the magnetic beads are stored after the protocol is completed.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationLoadingCollectionStorageCondition specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationLoadingCollectionStorageCondition is automatically set to Refrigerator.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		LoadingAirDry,
		{
			OptionName->MagneticBeadSeparationLoadingAirDry,
			Description->"Indicates if the magnetic beads are exposed to open air to evaporate the remaining sample solution after aspiration of sample solution containing components that are not bound to the magnetic beads and prior to elution.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationLoadingAirDry specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationLoadingAirDry is automatically set to False.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		LoadingAirDryTime,
		{
			OptionName->MagneticBeadSeparationLoadingAirDryTime,
			Description->"The duration that the magnetic beads are exposed to open air to evaporate the remaining sample after aspiration of sample solution containing components that are not bound to the magnetic beads and prior to elution.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationLoadingAirDryTime specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationLoadingAirDryTime is automatically set to 1 Minute if MagneticBeadSeparationLoadingAirDry is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],

	(*--- PRIMARY WASH OPTIONS---*)

	ModifyOptions[ExperimentMagneticBeadSeparation,
		Wash,
		{
			OptionName->MagneticBeadSeparationWash,
			Default->Automatic,
			Description->"Indicates if the magnetic beads with bound targets or contaminants are rinsed in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional MagneticBeadSeparationSecondaryWash.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationWash specified by the selected Method. If Method is set to Custom, automatically set to True if other MagneticBeadSeparationWash options are set, or False otherwise.", 
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			NestedIndexMatching->False,
			Category->"Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		WashBuffer,
		{
			OptionName->MagneticBeadSeparationWashSolution,
			Description->"The solution used to rinse the magnetic beads during Wash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional MagneticBeadSeparationSecondaryWash.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationWashSolution specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationWashSolution is automatically set to Model[Sample,\"Milli-Q water\"] if MagneticBeadSeparationWash is set to True.",
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation" 
		}
	],
	{
		OptionName -> MagneticBeadSeparationWashSolutionVolume,
		Description -> "The amount of MagneticBeadSeparationWashSolution that is added to the magnetic beads for each wash.",
		ResolutionDescription -> "If MagneticBeadSeparationWash is set to True, MagneticBeadSeparationWashSolutionVolume is automatically set to MagneticBeadSeparationPreWashSolutionVolume when MagneticBeadSeparationPreWash is set to True, and is set to MagneticBeadSeparationSampleVolume when MagneticBeadSeparationPreWash is set to False.",
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> RangeP[$MinRoboticTransferVolume, $MaxRoboticTransferVolume], 
			Units -> {Microliter, {Microliter, Milliliter}}
		],
		AllowNull->True,
		Default->Automatic,
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		WashMix,
		{
			OptionName->MagneticBeadSeparationWashMix,
			Description->"Indicates if the solution is mixed following combination of MagneticBeadSeparationWashSolution and the magnetic beads.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationWashMix specified by the selected Method. If Method is Custom, MagneticBeadSeparationWashMix is automatically set to True if MagneticBeadSeparationWash is set to True and MagneticBeadSeparationWashMixType is not set to Null.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName -> MagneticBeadSeparationWashMixType,
		Description -> "The style of motion used to mix the suspension following the addition of the MagneticBeadSeparationWashSolution to the magnetic beads.",
		ResolutionDescription -> "Automatically set to the MagneticBeadSeparationWashMixType specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationWashMix is set to True, MagneticBeadSeparationWashMixType is automatically set based on the volume-to-mix (i.e. the volume of the combined MagneticBeadSeparationWashSolution and magnetic beads) and the wash mix options. Specifically, MagneticBeadSeparationWashMixType is automatically set to Pipette when the volume-to-mix is greater than 20 Microliter and none of MagneticBeadSeparationWashMixRate, MagneticBeadSeparationWashMixTemperature, and MagneticBeadSeparationWashMixTime is specified to non-default values. Otherwise, MagneticBeadSeparationWashMixType is automatically set to Shake.",
		AllowNull -> True,
		Default -> Automatic,
		Widget -> Widget[
			Type -> Enumeration,
			Pattern :> Shake | Pipette
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		WashMixTime,
		{
			OptionName -> MagneticBeadSeparationWashMixTime,
			Description -> "The duration during which the combined MagneticBeadSeparationWashSolution and magnetic beads are mixed by the selected MagneticBeadSeparationWashMixType.",
			ResolutionDescription -> "Automatically set to the MagneticBeadSeparationWashMixTime specified by the selected Method. If Method is set to Custom, automatically set to 5 Minute if MagneticBeadSeparationWashMixType is set to Shake.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName->MagneticBeadSeparationWashMixRate,
		Description->"The number of rotations per minute at which the combined MagneticBeadSeparationWashSolution and magnetic beads is shaken in order to fully mix.",
		ResolutionDescription->"Automatically set to the MagneticBeadSeparationWashMixRate specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationWashMixType is set to Shake, MagneticBeadSeparationWashMixRate is automatically set to 300 RPM.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> RangeP[$MinBioSTARMixRate, $MaxBioSTARMixRate],
			Units -> RPM
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		NumberOfWashMixes,
		{
			OptionName->NumberOfMagneticBeadSeparationWashMixes,
			Description->"The number of times that the combined MagneticBeadSeparationWashSolution and magnetic beads is mixed by pipetting the MagneticBeadSeparationWashMixVolume up and down following the addition of MagneticBeadSeparationWashSolution to the magnetic beads in order to fully mix.", 
			ResolutionDescription->"Automatically set to the NumberOfMagneticBeadSeparationWashMixes specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationWashMixType is set to Pipette, NumberOfMagneticBeadSeparationWashMixes is automatically set to 10.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName->MagneticBeadSeparationWashMixVolume,
		Description->"The volume of the combined MagneticBeadSeparationWashSolution and magnetic beads that is displaced during each mix-by-pipette mix cycle.",
		ResolutionDescription->"Automatically set to 970 Microliter if 1/2*volume-to-mix (i.e.volume-to-mix is the volume of the combined MagneticBeadSeparationWashSolution and magnetic beads) is greater than 970 Microliter, and otherwise is set to the greater of 10 Microliter and 1/2*volume-to-mix.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> RangeP[$MinRoboticTransferVolume, $MaxRoboticSingleTransferVolume],
			Units -> {Microliter, {Microliter, Milliliter}}
		],
		Category -> "Magnetic Bead Separation"
	},
	{
		OptionName->MagneticBeadSeparationWashMixTemperature,
		Description->"The temperature at which the Instrument heating or cooling the combined MagneticBeadSeparationWashSolution and magnetic beads is maintained during the MagneticBeadSeparationWashMix, which occurs after adding MagneticBeadSeparationWashSolution to the magnetic beads and before the WashMagnetizationTime.",
		ResolutionDescription->"Automatically set to the MagneticBeadSeparationWashMixTemperature specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationWashMixType is not Null, MagneticBeadSeparationWashMixTemperature is automatically set to Ambient.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Alternatives[
			Widget[
				Type -> Quantity,
				Pattern :> RangeP[$MinRoboticIncubationTemperature, $MaxRoboticIncubationTemperature],
				Units -> {Celsius, {Celsius, Fahrenheit}}
			],
			Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[Ambient]
			]
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		WashMixTipType,
		{
			OptionName -> MagneticBeadSeparationWashMixTipType,
			Description -> "The type of pipette tips used to mix the combined MagneticBeadSeparationWashSolution and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator.",
			ResolutionDescription -> "Automatically set to WideBore if MagneticBeadSeparationWashMixType is Pipette.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		WashMixTipMaterial,
		{
			OptionName -> MagneticBeadSeparationWashMixTipMaterial,
			Description -> "The material of the pipette tips used to aspirate and dispense the requested volume during the MagneticBeadSeparationWashMix.",
			ResolutionDescription -> "Automatically set to Polypropylene if MagneticBeadSeparationWashMixType is Pipette.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		WashMagnetizationTime,
		{
			OptionName->WashMagnetizationTime,
			Description->"The duration of magnetizing the magnetic beads after MagneticBeadSeparationWashMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used MagneticBeadSeparationWashSolution.",
			ResolutionDescription->"Automatically set to the WashMagnetizationTime specified by the selected Method. If Method is set to Custom, WashMagnetizationTime is automatically set to 5 minutes if MagneticBeadSeparationWash is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName->MagneticBeadSeparationWashAspirationVolume,
		Description->"The volume of used MagneticBeadSeparationWashSolution to aspirate out while the magnetic beads are magnetized and gathered to the side after the elapse of WashMagnetizationTime.",
		ResolutionDescription->"Automatically set to the MagneticBeadSeparationWashAspirationVolume specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationWashAspirationVolume is automatically set to the MagneticBeadSeparationWashSolutionVolume if MagneticBeadSeparationWash is True.",Default -> Automatic,
		AllowNull -> True,
		Widget -> Alternatives[
			"All" -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[All]
			],
			"Volume" -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[$MinRoboticTransferVolume, $MaxRoboticTransferVolume],
				Units -> {Microliter, {Microliter, Milliliter}}
			]
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		WashCollectionContainer,
		{
			OptionName->MagneticBeadSeparationWashCollectionContainer,
			Description->"The container used to collect the used MagneticBeadSeparationWashSolution aspirated during wash.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationWashCollectionContainer specified by the selected Method. Otherwise set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"].",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		WashCollectionStorageCondition,
		{
			OptionName->MagneticBeadSeparationWashCollectionStorageCondition,
			Description->"The non-default condition under which the aspirated used MagneticBeadSeparationWashSolution during wash are stored after the protocol is completed.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationWashCollectionStorageCondition specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationWashCollectionStorageCondition is automatically set to Refrigerator if MagneticBeadSeparationWash is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		NumberOfWashes,
		{
			OptionName->NumberOfMagneticBeadSeparationWashes,
			Description->"The number of times that the magnetic beads are washed by adding MagneticBeadSeparationWashSolution, mixing, magnetization, and aspirating solution prior to elution or optional MagneticBeadSeparationSecondaryWash.",
			ResolutionDescription->"Automatically set to the NumberOfMagneticBeadSeparationWashes specified by the selected Method. If Method is set to Custom, NumberOfMagneticBeadSeparationWashes is automatically set to 1 if MagneticBeadSeparationWash is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		WashAirDry,
		{
			OptionName->MagneticBeadSeparationWashAirDry,
			Description->"Indicates if the magnetic beads are exposed to open air to evaporate the remaining solution after aspiration of the used MagneticBeadSeparationWashSolution and prior to elution or optional MagneticBeadSeparationSecondaryWash.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationWashAirDry specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationWashAirDry is automatically set to False if MagneticBeadSeparationWash is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		WashAirDryTime,
		{
			OptionName->MagneticBeadSeparationWashAirDryTime,
			Description->"The duration that the magnetic beads are exposed to open air to evaporate the remaining MagneticBeadSeparationWashSolution after aspiration of the used MagneticBeadSeparationWashSolution and prior to elution or optional MagneticBeadSeparationSecondaryWash.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationWashAirDryTime specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationWashAirDryTime is automatically set to 1 Minute if MagneticBeadSeparationWashAirDry is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],

	(*--- SECONDARY WASH OPTIONS---*)

	ModifyOptions[ExperimentMagneticBeadSeparation,
		SecondaryWash,
		{
			OptionName->MagneticBeadSeparationSecondaryWash,
			Default->Automatic,
			Description->"Indicates if the magnetic beads with bound targets or contaminants are further rinsed after MagneticBeadSeparationWash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional MagneticBeadSeparationTertiaryWash.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationSecondaryWash specified by the selected Method. If Method is set to Custom, automatically set to True if other MagneticBeadSeparationSecondaryWash options are set, or False otherwise.", 
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			NestedIndexMatching->False,
			Category->"Magnetic Bead Separation" 
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		SecondaryWashBuffer,
		{
			OptionName->MagneticBeadSeparationSecondaryWashSolution,
			Description->"The solution used to rinse the magnetic beads during secondary wash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional MagneticBeadSeparationTertiaryWash.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationSecondaryWashSolution specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationSecondaryWashSolution is automatically set to Model[Sample,\"Milli-Q water\"] if MagneticBeadSeparationSecondaryWash is set to True.",
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation" 
		}
	],
	{
		OptionName -> MagneticBeadSeparationSecondaryWashSolutionVolume,
		Description -> "The amount of MagneticBeadSeparationSecondaryWashSolution that is added to the magnetic beads for each secondary wash.",
		ResolutionDescription -> "If MagneticBeadSeparationSecondaryWash is set to True, MagneticBeadSeparationSecondaryWashSolutionVolume is automatically set to MagneticBeadSeparationPreWashSolutionVolume when MagneticBeadSeparationPreWash is set to True, and is set to MagneticBeadSeparationSampleVolume when MagneticBeadSeparationPreWash is set to False.",
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> RangeP[$MinRoboticTransferVolume, $MaxRoboticTransferVolume], 
			Units -> {Microliter, {Microliter, Milliliter}}
		],
		AllowNull->True,
		Default->Automatic,
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		SecondaryWashMix,
		{
			OptionName->MagneticBeadSeparationSecondaryWashMix,
			Description->"Indicates if the solution is mixed following combination of MagneticBeadSeparationSecondaryWashSolution and the magnetic beads.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationSecondaryWashMix specified by the selected Method. If Method is Custom, MagneticBeadSeparationSecondaryWashMix is automatically set to True if MagneticBeadSeparationSecondaryWash is set to True and MagneticBeadSeparationSecondaryWashMixType is not set to Null.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName -> MagneticBeadSeparationSecondaryWashMixType,
		Description -> "The style of motion used to mix the suspension following the addition of the MagneticBeadSeparationSecondaryWashSolution to the magnetic beads.",
		ResolutionDescription -> "Automatically set to the MagneticBeadSeparationSecondaryWashMixType specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationSecondaryWashMix is set to True, MagneticBeadSeparationSecondaryWashMixType is automatically set based on the volume-to-mix (i.e. the volume of the combined MagneticBeadSeparationSecondaryWashSolution and magnetic beads) and the secondaryWash mix options. Specifically, MagneticBeadSeparationSecondaryWashMixType is automatically set to Pipette when the volume-to-mix is greater than 20 Microliter and none of MagneticBeadSeparationSecondaryWashMixRate, MagneticBeadSeparationSecondaryWashMixTemperature, and MagneticBeadSeparationSecondaryWashMixTime is specified to non-default values. Otherwise, MagneticBeadSeparationSecondaryWashMixType is automatically set to Shake.",
		AllowNull -> True,
		Default -> Automatic,
		Widget -> Widget[
			Type -> Enumeration,
			Pattern :> Shake | Pipette
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		SecondaryWashMixTime,
		{
			OptionName -> MagneticBeadSeparationSecondaryWashMixTime,
			Description -> "The duration during which the combined MagneticBeadSeparationSecondaryWashSolution and magnetic beads is mixed by the selected MagneticBeadSeparationSecondaryWashMixType.",
			ResolutionDescription -> "Automatically set to the MagneticBeadSeparationSecondaryWashMixTime specified by the selected Method. If Method is set to Custom, automatically set to 5 Minute if MagneticBeadSeparationSecondaryWashMixType is set to Shake.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName->MagneticBeadSeparationSecondaryWashMixRate,
		Description->"The number of rotations per minute at which the combined MagneticBeadSeparationSecondaryWashSolution and magnetic beads is shaken in order to fully mix.",
		ResolutionDescription->"Automatically set to the MagneticBeadSeparationSecondaryWashMixRate specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationSecondaryWashMixType is set to Shake, MagneticBeadSeparationSecondaryWashMixRate is automatically set to 300 RPM.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> RangeP[$MinBioSTARMixRate, $MaxBioSTARMixRate],
			Units -> RPM
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		NumberOfSecondaryWashMixes,
		{
			OptionName->NumberOfMagneticBeadSeparationSecondaryWashMixes,
			Description->"The number of times that the combined MagneticBeadSeparationSecondaryWashSolution and magnetic beads is mixed by pipetting the MagneticBeadSeparationSecondaryWashMixVolume up and down following the addition of MagneticBeadSeparationSecondaryWashSolution to the magnetic beads in order to fully mix.", 
			ResolutionDescription->"Automatically set to the NumberOfMagneticBeadSeparationSecondaryWashMixes specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationSecondaryWashMixType is set to Pipette, NumberOfMagneticBeadSeparationSecondaryWashMixes is automatically set to 10.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName->MagneticBeadSeparationSecondaryWashMixVolume,
		Description->"The volume of the combined MagneticBeadSeparationSecondaryWashSolution and magnetic beads that is displaced during each mix-by-pipette mix cycle.",
		ResolutionDescription->"Automatically set to 970 Microliter if 1/2*volume-to-mix (i.e.volume-to-mix is the volume of the combined MagneticBeadSeparationSecondaryWashSolution and magnetic beads) is greater than 970 Microliter, and otherwise is set to the greater of 10 Microliter and 1/2*volume-to-mix.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> RangeP[$MinRoboticTransferVolume, $MaxRoboticSingleTransferVolume],
			Units -> {Microliter, {Microliter, Milliliter}}
		],
		Category -> "Magnetic Bead Separation"
	},
	{
		OptionName->MagneticBeadSeparationSecondaryWashMixTemperature,
		Description->"The temperature at which the Instrument heating or cooling the combined MagneticBeadSeparationSecondaryWashSolution and magnetic beads is maintained during the MagneticBeadSeparationSecondaryWashMix, which occurs after adding MagneticBeadSeparationSecondaryWashSolution to the magnetic beads and before the SecondaryWashMagnetizationTime.",
		ResolutionDescription->"Automatically set to the MagneticBeadSeparationSecondaryWashMixTemperature specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationSecondaryWashMixType is not Null, MagneticBeadSeparationSecondaryWashMixTemperature is automatically set to Ambient.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Alternatives[
			Widget[
				Type -> Quantity,
				Pattern :> RangeP[$MinRoboticIncubationTemperature, $MaxRoboticIncubationTemperature],
				Units -> {Celsius, {Celsius, Fahrenheit}}
			],
			Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[Ambient]
			]
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		SecondaryWashMixTipType,
		{
			OptionName -> MagneticBeadSeparationSecondaryWashMixTipType,
			Description -> "The type of pipette tips used to mix the combined MagneticBeadSeparationSecondaryWashSolution and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator.",
			ResolutionDescription -> "Automatically set to WideBore if MagneticBeadSeparationSecondaryWashMixType is Pipette.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		SecondaryWashMixTipMaterial,
		{
			OptionName -> MagneticBeadSeparationSecondaryWashMixTipMaterial,
			Description -> "The material of the pipette tips used to aspirate and dispense the requested volume during the MagneticBeadSeparationSecondaryWashMix.",
			ResolutionDescription -> "Automatically set to Polypropylene if MagneticBeadSeparationSecondaryWashMixType is Pipette.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		SecondaryWashMagnetizationTime,
		{
			OptionName->SecondaryWashMagnetizationTime,
			Description->"The duration of magnetizing the magnetic beads after MagneticBeadSeparationSecondaryWashMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used MagneticBeadSeparationSecondaryWashSolution.",
			ResolutionDescription->"Automatically set to the SecondaryWashMagnetizationTime specified by the selected Method. If Method is set to Custom, SecondaryWashMagnetizationTime is automatically set to 5 minutes if MagneticBeadSeparationSecondaryWash is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName->MagneticBeadSeparationSecondaryWashAspirationVolume,
		Description->"The volume of used MagneticBeadSeparationSecondaryWashSolution to aspirate out while the magnetic beads are magnetized and gathered to the side after the elapse of SecondaryWashMagnetizationTime.",
		ResolutionDescription->"Automatically set to the MagneticBeadSeparationSecondaryWashAspirationVolume specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationSecondaryWashAspirationVolume is automatically set to the MagneticBeadSeparationSecondaryWashSolutionVolume if MagneticBeadSeparationSecondaryWash is True.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Alternatives[
			"All" -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[All]
			],
			"Volume" -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[$MinRoboticTransferVolume, $MaxRoboticTransferVolume],
				Units -> {Microliter, {Microliter, Milliliter}}
			]
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		SecondaryWashCollectionContainer,
		{
			OptionName->MagneticBeadSeparationSecondaryWashCollectionContainer,
			Description->"The container used to collect the used MagneticBeadSeparationSecondaryWashSolution aspirated during secondary wash.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationSecondaryWashCollectionContainer specified by the selected Method. Otherwise set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"].",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		SecondaryWashCollectionStorageCondition,
		{
			OptionName->MagneticBeadSeparationSecondaryWashCollectionStorageCondition,
			Description->"The non-default condition under which the aspirated used MagneticBeadSeparationSecondaryWashSolution during secondary wash are stored after the protocol is completed.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationSecondaryWashCollectionStorageCondition specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationSecondaryWashCollectionStorageCondition is automatically set to Disposal if MagneticBeadSeparationSecondaryWash is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		NumberOfSecondaryWashes,
		{
			OptionName->NumberOfMagneticBeadSeparationSecondaryWashes,
			Description->"The number of times that the magnetic beads are washed by adding MagneticBeadSeparationSecondaryWashSolution, mixing, magnetization, and aspirating solution prior to elution or optional MagneticBeadSeparationTertiaryWash.",
			ResolutionDescription->"Automatically set to the NumberOfMagneticBeadSeparationSecondaryWashes specified by the selected Method. If Method is set to Custom, NumberOfMagneticBeadSeparationSecondaryWashes is automatically set to 1 if MagneticBeadSeparationSecondaryWash is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		SecondaryWashAirDry,
		{
			OptionName->MagneticBeadSeparationSecondaryWashAirDry,
			Description->"Indicates if the magnetic beads are exposed to open air to evaporate the remaining solution after aspiration of the used MagneticBeadSeparationSecondaryWashSolution and prior to elution or optional MagneticBeadSeparationTertiaryWash.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationSecondaryWashAirDry specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationSecondaryWashAirDry is automatically set to False if MagneticBeadSeparationSecondaryWash is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		SecondaryWashAirDryTime,
		{
			OptionName->MagneticBeadSeparationSecondaryWashAirDryTime,
			Description->"The duration that the magnetic beads are exposed to open air to evaporate the remaining MagneticBeadSeparationSecondaryWashSolution after aspiration of the used MagneticBeadSeparationSecondaryWashSolution and prior to elution or optional MagneticBeadSeparationTertiaryWash.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationSecondaryWashAirDryTime specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationSecondaryWashAirDryTime is automatically set to 1 Minute if MagneticBeadSeparationSecondaryWashAirDry is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],

	(*--- TERTIARY WASH OPTIONS---*)

	ModifyOptions[ExperimentMagneticBeadSeparation,
		TertiaryWash,
		{
			OptionName->MagneticBeadSeparationTertiaryWash,
			Default->Automatic,
			Description->"Indicates if the magnetic beads with bound targets or contaminants are further rinsed after MagneticBeadSeparationSecondaryWash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional MagneticBeadSeparationQuaternaryWash.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationTertiaryWash specified by the selected Method. If Method is set to Custom, automatically set to True if other MagneticBeadSeparationTertiaryWash options are set, or False otherwise.", 
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			NestedIndexMatching->False,
			Category->"Magnetic Bead Separation" 
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		TertiaryWashBuffer,
		{
			OptionName->MagneticBeadSeparationTertiaryWashSolution,
			Description->"The solution used to rinse the magnetic beads during tertiary wash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional MagneticBeadSeparationQuaternaryWash.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationTertiaryWashSolution specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationTertiaryWashSolution is automatically set to Model[Sample,\"Milli-Q water\"] if MagneticBeadSeparationTertiaryWash is set to True.",
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation" 
		}
	],
	{
		OptionName -> MagneticBeadSeparationTertiaryWashSolutionVolume,
		Description -> "The amount of MagneticBeadSeparationTertiaryWashSolution that is added to the magnetic beads for each tertiary wash.",
		ResolutionDescription -> "If MagneticBeadSeparationTertiaryWash is set to True, MagneticBeadSeparationTertiaryWashSolutionVolume is automatically set to MagneticBeadSeparationPreWashSolutionVolume when MagneticBeadSeparationPreWash is set to True, and is set to MagneticBeadSeparationSampleVolume when MagneticBeadSeparationPreWash is set to False.",
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> RangeP[$MinRoboticTransferVolume, $MaxRoboticTransferVolume],
			Units -> {Microliter, {Microliter, Milliliter}}
		],
		AllowNull->True,
		Default->Automatic,
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		WashMix,
		{
			OptionName->MagneticBeadSeparationTertiaryWashMix,
			Description->"Indicates if the solution is mixed following combination of MagneticBeadSeparationTertiaryWashSolution and the magnetic beads.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationTertiaryWashMix specified by the selected Method. If Method is Custom, MagneticBeadSeparationTertiaryWashMix is automatically set to True if MagneticBeadSeparationTertiaryWash is set to True and MagneticBeadSeparationTertiaryWashMixType is not set to Null.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName -> MagneticBeadSeparationTertiaryWashMixType,
		Description -> "The style of motion used to mix the suspension following the addition of the MagneticBeadSeparationTertiaryWashSolution to the magnetic beads.",
		ResolutionDescription -> "Automatically set to the MagneticBeadSeparationTertiaryWashMixType specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationTertiaryWashMix is set to True, MagneticBeadSeparationTertiaryWashMixType is automatically set based on the volume-to-mix (i.e. the volume of the combined MagneticBeadSeparationTertiaryWashSolution and magnetic beads) and the tertiaryWash mix options. Specifically, MagneticBeadSeparationTertiaryWashMixType is automatically set to Pipette when the volume-to-mix is greater than 20 Microliter and none of MagneticBeadSeparationTertiaryWashMixRate, MagneticBeadSeparationTertiaryWashMixTemperature, and MagneticBeadSeparationTertiaryWashMixTime is specified to non-default values. Otherwise, MagneticBeadSeparationTertiaryWashMixType is automatically set to Shake.",
		AllowNull -> True,
		Default -> Automatic,
		Widget -> Widget[
			Type -> Enumeration,
			Pattern :> Shake | Pipette
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		TertiaryWashMixTime,
		{
			OptionName -> MagneticBeadSeparationTertiaryWashMixTime,
			Description -> "The duration during which the combined MagneticBeadSeparationTertiaryWashSolution and magnetic beads is mixed by the selected MagneticBeadSeparationTertiaryWashMixType.",
			ResolutionDescription -> "Automatically set to the MagneticBeadSeparationTertiaryWashMixTime specified by the selected Method. If Method is set to Custom, automatically set to 5 Minute if MagneticBeadSeparationTertiaryWashMixType is set to Shake.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName->MagneticBeadSeparationTertiaryWashMixRate,
		Description->"The number of rotations per minute at which the combined MagneticBeadSeparationTertiaryWashSolution and magnetic beads is shaken in order to fully mix.",
		ResolutionDescription->"Automatically set to the MagneticBeadSeparationTertiaryWashMixRate specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationTertiaryWashMixType is set to Shake, MagneticBeadSeparationTertiaryWashMixRate is automatically set to 300 RPM.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> RangeP[$MinBioSTARMixRate, $MaxBioSTARMixRate],
			Units -> RPM
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		NumberOfTertiaryWashMixes,
		{
			OptionName->NumberOfMagneticBeadSeparationTertiaryWashMixes,
			Description->"The number of times that the combined MagneticBeadSeparationTertiaryWashSolution and magnetic beads is mixed by pipetting the MagneticBeadSeparationTertiaryWashMixVolume up and down following the addition of MagneticBeadSeparationTertiaryWashSolution to the magnetic beads in order to fully mix.", 
			ResolutionDescription->"Automatically set to the NumberOfMagneticBeadSeparationTertiaryWashMixes specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationTertiaryWashMixType is set to Pipette, NumberOfMagneticBeadSeparationTertiaryWashMixes is automatically set to 10.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName->MagneticBeadSeparationTertiaryWashMixVolume,
		Description->"The volume of teh combined MagneticBeadSeparationTertiaryWashSolution and magnetic beads that is displaced during each mix-by-pipette mix cycle.",
		ResolutionDescription->"Automatically set to 970 Microliter if 1/2*volume-to-mix (i.e.volume-to-mix is the volume of the combined MagneticBeadSeparationTertiaryWashSolution and magnetic beads) is greater than 970 Microliter, and otherwise is set to the greater of 10 Microliter and 1/2*volume-to-mix.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> RangeP[$MinRoboticTransferVolume, $MaxRoboticSingleTransferVolume],
			Units -> {Microliter, {Microliter, Milliliter}}
		],
		Category -> "Magnetic Bead Separation"
	},
	{
		OptionName->MagneticBeadSeparationTertiaryWashMixTemperature,
		Description->"The temperature at which the Instrument heating or cooling the combined MagneticBeadSeparationTertiaryWashSolution and magnetic beads is maintained during the MagneticBeadSeparationTertiaryWashMix, which occurs after adding MagneticBeadSeparationTertiaryWashSolution to the magnetic beads and before the TertiaryWashMagnetizationTime.",
		ResolutionDescription->"Automatically set to the MagneticBeadSeparationTertiaryWashMixTemperature specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationTertiaryWashMixType is not Null, MagneticBeadSeparationTertiaryWashMixTemperature is automatically set to Ambient.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Alternatives[
			Widget[
				Type -> Quantity,
				Pattern :> RangeP[$MinRoboticIncubationTemperature, $MaxRoboticIncubationTemperature],
				Units -> {Celsius, {Celsius, Fahrenheit}}
			],
			Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[Ambient]
			]
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		TertiaryWashMixTipType,
		{
			OptionName -> MagneticBeadSeparationTertiaryWashMixTipType,
			Description -> "The type of pipette tips used to mix the combined MagneticBeadSeparationTertiaryWashSolution and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator.",
			ResolutionDescription -> "Automatically set to WideBore if MagneticBeadSeparationTertiaryWashMixType is Pipette.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		TertiaryWashMixTipMaterial,
		{
			OptionName -> MagneticBeadSeparationTertiaryWashMixTipMaterial,
			Description -> "The material of the pipette tips used to aspirate and dispense the requested volume during the MagneticBeadSeparationTertiaryWashMix.",
			ResolutionDescription -> "Automatically set to Polypropylene if MagneticBeadSeparationTertiaryWashMixType is Pipette.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		TertiaryWashMagnetizationTime,
		{
			OptionName->TertiaryWashMagnetizationTime,
			Description->"The duration of magnetizing the magnetic beads after MagneticBeadSeparationTertiaryWashMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used MagneticBeadSeparationTertiaryWashSolution.",
			ResolutionDescription->"Automatically set to the TertiaryWashMagnetizationTime specified by the selected Method. If Method is set to Custom, TertiaryWashMagnetizationTime is automatically set to 5 minutes if MagneticBeadSeparationTertiaryWash is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName->MagneticBeadSeparationTertiaryWashAspirationVolume,
		Description->"The volume of used MagneticBeadSeparationTertiaryWashSolution to aspirate out while the magnetic beads are magnetized and gathered to the side after the elapse of TertiaryWashMagnetizationTime.",
		ResolutionDescription->"Automatically set to the MagneticBeadSeparationTertiaryWashAspirationVolume specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationTertiaryWashAspirationVolume is automatically set to the MagneticBeadSeparationTertiaryWashSolutionVolume if MagneticBeadSeparationTertiaryWash is True.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Alternatives[
			"All" -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[All]
			],
			"Volume" -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[$MinRoboticTransferVolume, $MaxRoboticTransferVolume],
				Units -> {Microliter, {Microliter, Milliliter}}
			]
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		TertiaryWashCollectionContainer,
		{
			OptionName->MagneticBeadSeparationTertiaryWashCollectionContainer,
			Description->"The container used to collect the used MagneticBeadSeparationTertiaryWashSolution aspirated during tertiary wash.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationTertiaryWashCollectionContainer specified by the selected Method. Otherwise set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"].",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		WashCollectionStorageCondition,
		{
			OptionName->MagneticBeadSeparationTertiaryWashCollectionStorageCondition,
			Description->"The non-default condition under which the aspirated used MagneticBeadSeparationTertiaryWashSolution during tertiary wash are stored after the protocol is completed.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationTertiaryWashCollectionStorageCondition specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationTertiaryWashCollectionStorageCondition is automatically set to Disposal if MagneticBeadSeparationTertiaryWash is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		NumberOfTertiaryWashes,
		{
			OptionName->NumberOfMagneticBeadSeparationTertiaryWashes,
			Description->"The number of times that the magnetic beads are washed by adding MagneticBeadSeparationTertiaryWashSolution, mixing, magnetization, and aspirating solution prior to elution or optional MagneticBeadSeparationQuaternaryWash.",
			ResolutionDescription->"Automatically set to the NumberOfMagneticBeadSeparationTertiaryWashes specified by the selected Method. If Method is set to Custom, NumberOfMagneticBeadSeparationTertiaryWashes is automatically set to 1 if MagneticBeadSeparationTertiaryWash is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		TertiaryWashAirDry,
		{
			OptionName->MagneticBeadSeparationTertiaryWashAirDry,
			Description->"Indicates if the magnetic beads are exposed to open air to evaporate the remaining solution after aspiration of the used MagneticBeadSeparationTertiaryWashSolution and prior to elution or optional MagneticBeadSeparationQuaternaryWash.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationTertiaryWashAirDry specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationTertiaryWashAirDry is automatically set to False if MagneticBeadSeparationTertiaryWash is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		TertiaryWashAirDryTime,
		{
			OptionName->MagneticBeadSeparationTertiaryWashAirDryTime,
			Description->"The duration that the magnetic beads are exposed to open air to evaporate the remaining MagneticBeadSeparationTertiaryWashSolution after aspiration of the used MagneticBeadSeparationTertiaryWashSolution and prior to elution or optional MagneticBeadSeparationQuaternaryWash.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationTertiaryWashAirDryTime specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationTertiaryWashAirDryTime is automatically set to 1 Minute if MagneticBeadSeparationTertiaryWashAirDry is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],

	(*--- QUATERNARY WASH OPTIONS---*)

	ModifyOptions[ExperimentMagneticBeadSeparation,
		QuaternaryWash,
		{
			OptionName->MagneticBeadSeparationQuaternaryWash,
			Default->Automatic,
			Description->"Indicates if the magnetic beads with bound targets or contaminants are further rinsed after MagneticBeadSeparationTertiaryWash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional MagneticBeadSeparationQuinaryWash.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationQuaternaryWash specified by the selected Method. If Method is set to Custom, automatically set to True if other MagneticBeadSeparationQuaternaryWash options are set, or False otherwise.", 
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			NestedIndexMatching->False,
			Category->"Magnetic Bead Separation" 
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		QuaternaryWashBuffer,
		{
			OptionName->MagneticBeadSeparationQuaternaryWashSolution,
			Description->"The solution used to rinse the magnetic beads during quaternary wash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional MagneticBeadSeparationQuinaryWash.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationQuaternaryWashSolution specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationQuaternaryWashSolution is automatically set to Model[Sample,\"Milli-Q water\"] if MagneticBeadSeparationQuaternaryWash is set to True.",
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation" 
		}
	],
	{
		OptionName -> MagneticBeadSeparationQuaternaryWashSolutionVolume,
		Description -> "The amount of MagneticBeadSeparationQuaternaryWashSolution that is added to the magnetic beads for each quaternary wash.",
		ResolutionDescription -> "If MagneticBeadSeparationQuaternaryWash is set to True, MagneticBeadSeparationQuaternaryWashSolutionVolume is automatically set to MagneticBeadSeparationPreWashSolutionVolume when MagneticBeadSeparationPreWash is set to True, and is set to MagneticBeadSeparationSampleVolume when MagneticBeadSeparationPreWash is set to False.",
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> RangeP[$MinRoboticTransferVolume, $MaxRoboticTransferVolume], 
			Units -> {Microliter, {Microliter, Milliliter}}
		],
		AllowNull->True,
		Default->Automatic,
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		QuaternaryWashMix,
		{
			OptionName->MagneticBeadSeparationQuaternaryWashMix,
			Description->"Indicates if the solution is mixed following combination of MagneticBeadSeparationQuaternaryWashSolution and the magnetic beads.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationQuaternaryWashMix specified by the selected Method. If Method is Custom, MagneticBeadSeparationQuaternaryWashMix is automatically set to True if MagneticBeadSeparationQuaternaryWash is set to True and MagneticBeadSeparationQuaternaryWashMixType is not set to Null.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName -> MagneticBeadSeparationQuaternaryWashMixType,
		Description -> "The style of motion used to mix the suspension following the addition of the MagneticBeadSeparationQuaternaryWashSolution to the magnetic beads.",
		ResolutionDescription -> "Automatically set to the MagneticBeadSeparationQuaternaryWashMixType specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationQuaternaryWashMix is set to True, MagneticBeadSeparationQuaternaryWashMixType is automatically set based on the volume-to-mix (i.e. the volume of the combined MagneticBeadSeparationQuaternaryWashSolution and magnetic beads) and the quaternaryWash mix options. Specifically, MagneticBeadSeparationQuaternaryWashMixType is automatically set to Pipette when the volume-to-mix is greater than 20 Microliter and none of MagneticBeadSeparationQuaternaryWashMixRate, MagneticBeadSeparationQuaternaryWashMixTemperature, and MagneticBeadSeparationQuaternaryWashMixTime is specified to non-default values. Otherwise, MagneticBeadSeparationQuaternaryWashMixType is automatically set to Shake.",
		AllowNull -> True,
		Default -> Automatic,
		Widget -> Widget[
			Type -> Enumeration,
			Pattern :> Shake | Pipette
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		QuaternaryWashMixTime,
		{
			OptionName -> MagneticBeadSeparationQuaternaryWashMixTime,
			Description -> "The duration during which the combined MagneticBeadSeparationQuaternaryWashSolution and magnetic beads is mixed by the selected MagneticBeadSeparationQuaternaryWashMixType.",
			ResolutionDescription -> "Automatically set to the MagneticBeadSeparationQuaternaryWashMixTime specified by the selected Method. If Method is set to Custom, automatically set to 5 Minute if MagneticBeadSeparationQuaternaryWashMixType is set to Shake.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName->MagneticBeadSeparationQuaternaryWashMixRate,
		Description->"The number of rotations per minute at which the combined MagneticBeadSeparationQuaternaryWashSolution and magnetic beads is shaken in order to fully mix.",
		ResolutionDescription->"Automatically set to the MagneticBeadSeparationQuaternaryWashMixRate specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationQuaternaryWashMixType is set to Shake, MagneticBeadSeparationQuaternaryWashMixRate is automatically set to 300 RPM.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> RangeP[$MinBioSTARMixRate, $MaxBioSTARMixRate],
			Units -> RPM
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		NumberOfQuaternaryWashMixes,
		{
			OptionName->NumberOfMagneticBeadSeparationQuaternaryWashMixes,
			Description->"The number of times that the combined MagneticBeadSeparationQuaternaryWashSolution and magnetic beads is mixed by pipetting the MagneticBeadSeparationQuaternaryWashMixVolume up and down following the addition of MagneticBeadSeparationQuaternaryWashSolution to the magnetic beads in order to fully mix.", 
			ResolutionDescription->"Automatically set to the NumberOfMagneticBeadSeparationQuaternaryWashMixes specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationQuaternaryWashMixType is set to Pipette, NumberOfMagneticBeadSeparationQuaternaryWashMixes is automatically set to 10.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName->MagneticBeadSeparationQuaternaryWashMixVolume,
		Description->"The volume of the combined MagneticBeadSeparationQuaternaryWashSolution and magnetic beads that is displaced during each mix-by-pipette mix cycle.",
		ResolutionDescription->"Automatically set to 970 Microliter if 1/2*volume-to-mix (i.e.volume-to-mix is the volume of the combined MagneticBeadSeparationQuaternaryWashSolution and magnetic beads) is greater than 970 Microliter, and otherwise is set to the greater of 10 Microliter and 1/2*volume-to-mix.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> RangeP[$MinRoboticTransferVolume, $MaxRoboticSingleTransferVolume],
			Units -> {Microliter, {Microliter, Milliliter}}
		],
		Category -> "Magnetic Bead Separation"
	},
	{
		OptionName->MagneticBeadSeparationQuaternaryWashMixTemperature,
		Description->"The temperature at which the Instrument heating or cooling the combined MagneticBeadSeparationQuaternaryWashSolution and magnetic beads is maintained during the MagneticBeadSeparationQuaternaryWashMix, which occurs after adding MagneticBeadSeparationQuaternaryWashSolution to the magnetic beads and before the QuaternaryWashMagnetizationTime.",
		ResolutionDescription->"Automatically set to the MagneticBeadSeparationQuaternaryWashMixTemperature specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationQuaternaryWashMixType is not Null, MagneticBeadSeparationQuaternaryWashMixTemperature is automatically set to Ambient.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Alternatives[
			Widget[
				Type -> Quantity,
				Pattern :> RangeP[$MinRoboticIncubationTemperature, $MaxRoboticIncubationTemperature],
				Units -> {Celsius, {Celsius, Fahrenheit}}
			],
			Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[Ambient]
			]
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		QuaternaryWashMixTipType,
		{
			OptionName -> MagneticBeadSeparationQuaternaryWashMixTipType,
			Description -> "The type of pipette tips used to mix the combined MagneticBeadSeparationQuaternaryWashSolution and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator.",
			ResolutionDescription -> "Automatically set to WideBore if MagneticBeadSeparationQuaternaryWashMixType is Pipette.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		QuaternaryWashMixTipMaterial,
		{
			OptionName -> MagneticBeadSeparationQuaternaryWashMixTipMaterial,
			Description -> "The material of the pipette tips used to aspirate and dispense the requested volume during the MagneticBeadSeparationQuaternaryWashMix.",
			ResolutionDescription -> "Automatically set to Polypropylene if MagneticBeadSeparationQuaternaryWashMixType is Pipette.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		QuaternaryWashMagnetizationTime,
		{
			OptionName->QuaternaryWashMagnetizationTime,
			Description->"The duration of magnetizing the magnetic beads after MagneticBeadSeparationQuaternaryWashMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used MagneticBeadSeparationQuaternaryWashSolution.",
			ResolutionDescription->"Automatically set to the QuaternaryWashMagnetizationTime specified by the selected Method. If Method is set to Custom, QuaternaryWashMagnetizationTime is automatically set to 5 minutes if MagneticBeadSeparationQuaternaryWash is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName->MagneticBeadSeparationQuaternaryWashAspirationVolume,
		Description->"The volume of used MagneticBeadSeparationQuaternaryWashSolution to aspirate out while the magnetic beads are magnetized and gathered to the side after the elapse of QuaternaryWashMagnetizationTime.",
		ResolutionDescription->"Automatically set to the MagneticBeadSeparationQuaternaryWashAspirationVolume specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationQuaternaryWashAspirationVolume is automatically set to the MagneticBeadSeparationQuaternaryWashSolutionVolume if MagneticBeadSeparationQuaternaryWash is True.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Alternatives[
			"All" -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[All]
			],
			"Volume" -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[$MinRoboticTransferVolume, $MaxRoboticTransferVolume],
				Units -> {Microliter, {Microliter, Milliliter}}
			]
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		QuaternaryWashCollectionContainer,
		{
			OptionName->MagneticBeadSeparationQuaternaryWashCollectionContainer,
			Description->"The container used to collect the used MagneticBeadSeparationQuaternaryWashSolution aspirated during quaternary wash.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationQuaternaryWashCollectionContainer specified by the selected Method. Otherwise set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"].",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		QuaternaryWashCollectionStorageCondition,
		{
			OptionName->MagneticBeadSeparationQuaternaryWashCollectionStorageCondition,
			Description->"The non-default condition under which the aspirated used MagneticBeadSeparationQuaternaryWashSolution during quaternary wash are stored after the protocol is completed.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationQuaternaryWashCollectionStorageCondition specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationQuaternaryWashCollectionStorageCondition is automatically set to Refrigerator if MagneticBeadSeparationQuaternaryWash is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		NumberOfQuaternaryWashes,
		{
			OptionName->NumberOfMagneticBeadSeparationQuaternaryWashes,
			Description->"The number of times that the magnetic beads are washed by adding MagneticBeadSeparationQuaternaryWashSolution, mixing, magnetization, and aspirating solution prior to elution or optional MagneticBeadSeparationQuinaryWash.",
			ResolutionDescription->"Automatically set to the NumberOfMagneticBeadSeparationQuaternaryWashes specified by the selected Method. If Method is set to Custom, NumberOfMagneticBeadSeparationQuaternaryWashes is automatically set to 1 if MagneticBeadSeparationQuaternaryWash is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		QuaternaryWashAirDry,
		{
			OptionName->MagneticBeadSeparationQuaternaryWashAirDry,
			Description->"Indicates if the magnetic beads are exposed to open air to evaporate the remaining solution after aspiration of the used MagneticBeadSeparationQuaternaryWashSolution and prior to elution or optional MagneticBeadSeparationQuinaryWash.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationQuaternaryWashAirDry specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationQuaternaryWashAirDry is automatically set to False if MagneticBeadSeparationQuaternaryWash is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		QuaternaryWashAirDryTime,
		{
			OptionName->MagneticBeadSeparationQuaternaryWashAirDryTime,
			Description->"The duration that the magnetic beads are exposed to open air to evaporate the remaining MagneticBeadSeparationQuaternaryWashSolution after aspiration of the used MagneticBeadSeparationQuaternaryWashSolution and prior to elution or optional MagneticBeadSeparationQuinaryWash.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationQuaternaryWashAirDryTime specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationQuaternaryWashAirDryTime is automatically set to 1 Minute if MagneticBeadSeparationQuaternaryWashAirDry is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
		
	(*--- QUINARY WASH OPTIONS---*)

	ModifyOptions[ExperimentMagneticBeadSeparation,
		QuinaryWash,
		{
			OptionName->MagneticBeadSeparationQuinaryWash,
			Default->Automatic,
			Description->"Indicates if the magnetic beads with bound targets or contaminants are further rinsed after MagneticBeadSeparationQuaternaryWash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional SenaryWash.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationQuinaryWash specified by the selected Method. If Method is set to Custom, automatically set to True if other MagneticBeadSeparationQuinaryWash options are set, or False otherwise.", 
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			NestedIndexMatching->False,
			Category->"Magnetic Bead Separation" 
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		QuinaryWashBuffer,
		{
			OptionName->MagneticBeadSeparationQuinaryWashSolution,
			Description->"The solution used to rinse the magnetic beads during quinary wash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional SenaryWash.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationQuinaryWashSolution specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationQuinaryWashSolution is automatically set to Model[Sample,\"Milli-Q water\"] if MagneticBeadSeparationQuinaryWash is set to True.",
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation" 
		}
	],
	{
		OptionName -> MagneticBeadSeparationQuinaryWashSolutionVolume,
		Description -> "The amount of MagneticBeadSeparationQuinaryWashSolution that is added to the magnetic beads for each quinary wash.",
		ResolutionDescription -> "If MagneticBeadSeparationQuinaryWash is set to True, MagneticBeadSeparationQuinaryWashSolutionVolume is automatically set to MagneticBeadSeparationPreWashSolutionVolume when MagneticBeadSeparationPreWash is set to True, and is set to MagneticBeadSeparationSampleVolume when MagneticBeadSeparationPreWash is set to False.",
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> RangeP[$MinRoboticTransferVolume, $MaxRoboticTransferVolume], 
			Units -> {Microliter, {Microliter, Milliliter}}
		],
		AllowNull->True,
		Default->Automatic,
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		QuinaryWashMix,
		{
			OptionName->MagneticBeadSeparationQuinaryWashMix,
			Description->"Indicates if the solution is mixed following combination of MagneticBeadSeparationQuinaryWashSolution and the magnetic beads.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationQuinaryWashMix specified by the selected Method. If Method is Custom, MagneticBeadSeparationQuinaryWashMix is automatically set to True if MagneticBeadSeparationQuinaryWash is set to True and MagneticBeadSeparationQuinaryWashMixType is not set to Null.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName -> MagneticBeadSeparationQuinaryWashMixType,
		Description -> "The style of motion used to mix the suspension following the addition of the MagneticBeadSeparationQuinaryWashSolution to the magnetic beads.",
		ResolutionDescription -> "Automatically set to the MagneticBeadSeparationQuinaryWashMixType specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationQuinaryWashMix is set to True, MagneticBeadSeparationQuinaryWashMixType is automatically set based on the volume-to-mix (i.e. the volume of the combined MagneticBeadSeparationQuinaryWashSolution and magnetic beads) and the quinaryWash mix options. Specifically, MagneticBeadSeparationQuinaryWashMixType is automatically set to Pipette when the volume-to-mix is greater than 20 Microliter and none of MagneticBeadSeparationQuinaryWashMixRate, MagneticBeadSeparationQuinaryWashMixTemperature, and MagneticBeadSeparationQuinaryWashMixTime is specified to non-default values. Otherwise, MagneticBeadSeparationQuinaryWashMixType is automatically set to Shake.",
		AllowNull -> True,
		Default -> Automatic,
		Widget -> Widget[
			Type -> Enumeration,
			Pattern :> Shake | Pipette
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		QuinaryWashMixTime,
		{
			OptionName -> MagneticBeadSeparationQuinaryWashMixTime,
			Description -> "The duration during which the combined MagneticBeadSeparationQuinaryWashSolution and magnetic beads is mixed by the selected MagneticBeadSeparationQuinaryWashMixType.",
			ResolutionDescription -> "Automatically set to the MagneticBeadSeparationQuinaryWashMixTime specified by the selected Method. If Method is set to Custom, automatically set to 5 Minute if MagneticBeadSeparationQuinaryWashMixType is set to Shake.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName->MagneticBeadSeparationQuinaryWashMixRate,
		Description->"The number of rotations per minute at which the combined MagneticBeadSeparationQuinaryWashSolution and magnetic beads is shaken in order to fully mix.",
		ResolutionDescription->"Automatically set to the MagneticBeadSeparationQuinaryWashMixRate specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationQuinaryWashMixType is set to Shake, MagneticBeadSeparationQuinaryWashMixRate is automatically set to 300 RPM.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> RangeP[$MinBioSTARMixRate, $MaxBioSTARMixRate],
			Units -> RPM
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		NumberOfQuinaryWashMixes,
		{
			OptionName->NumberOfMagneticBeadSeparationQuinaryWashMixes,
			Description->"The number of times that the combined MagneticBeadSeparationQuinaryWashSolution and magnetic beads is mixed by pipetting the MagneticBeadSeparationQuinaryWashMixVolume up and down following the addition of MagneticBeadSeparationQuinaryWashSolution to the magnetic beads in order to fully mix.", 
			ResolutionDescription->"Automatically set to the NumberOfMagneticBeadSeparationQuinaryWashMixes specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationQuinaryWashMixType is set to Pipette, NumberOfMagneticBeadSeparationQuinaryWashMixes is automatically set to 10.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName->MagneticBeadSeparationQuinaryWashMixVolume,
		Description->"The volume of combined MagneticBeadSeparationQuinaryWashSolution and magnetic beads that is displaced during each mix-by-pipette mix cycle.",
		ResolutionDescription->"Automatically set to 970 Microliter if 1/2*volume-to-mix (i.e.volume-to-mix is the volume of the combined MagneticBeadSeparationQuinaryWashSolution and magnetic beads) is greater than 970 Microliter, and otherwise is set to the greater of 10 Microliter and 1/2*volume-to-mix.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> RangeP[$MinRoboticTransferVolume, $MaxRoboticSingleTransferVolume],
			Units -> {Microliter, {Microliter, Milliliter}}
		],
		Category -> "Magnetic Bead Separation"
	},
	{
		OptionName->MagneticBeadSeparationQuinaryWashMixTemperature,
		Description->"The temperature at which the Instrument heating or cooling the sample is maintained during the MagneticBeadSeparationQuinaryWashMix, which occurs after adding MagneticBeadSeparationQuinaryWashSolution to the magnetic beads and before the QuinaryWashMagnetizationTime.",
		ResolutionDescription->"Automatically set to the MagneticBeadSeparationQuinaryWashMixTemperature specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationQuinaryWashMixType is not Null, MagneticBeadSeparationQuinaryWashMixTemperature is automatically set to Ambient.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Alternatives[
			Widget[
				Type -> Quantity,
				Pattern :> RangeP[$MinRoboticIncubationTemperature, $MaxRoboticIncubationTemperature],
				Units -> {Celsius, {Celsius, Fahrenheit}}
			],
			Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[Ambient]
			]
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		QuinaryWashMixTipType,
		{
			OptionName -> MagneticBeadSeparationQuinaryWashMixTipType,
			Description -> "The type of pipette tips used to mix the combined MagneticBeadSeparationQuinaryWashSolution and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator.",
			ResolutionDescription -> "Automatically set to WideBore if MagneticBeadSeparationQuinaryWashMixType is Pipette.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		QuinaryWashMixTipMaterial,
		{
			OptionName -> MagneticBeadSeparationQuinaryWashMixTipMaterial,
			Description -> "The material of the pipette tips used to aspirate and dispense the requested volume during the MagneticBeadSeparationQuinaryWashMix.",
			ResolutionDescription -> "Automatically set to Polypropylene if MagneticBeadSeparationQuinaryWashMixType is Pipette.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		QuinaryWashMagnetizationTime,
		{
			OptionName->QuinaryWashMagnetizationTime,
			Description->"The duration of magnetizing the magnetic beads after MagneticBeadSeparationQuinaryWashMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used MagneticBeadSeparationQuinaryWashSolution.",
			ResolutionDescription->"Automatically set to the QuinaryWashMagnetizationTime specified by the selected Method. If Method is set to Custom, QuinaryWashMagnetizationTime is automatically set to 5 minutes if MagneticBeadSeparationQuinaryWash is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName->MagneticBeadSeparationQuinaryWashAspirationVolume,
		Description->"The volume of used MagneticBeadSeparationQuinaryWashSolution to aspirate out while the magnetic beads are magnetized and gathered to the side after the elapse of QuinaryWashMagnetizationTime.",
		ResolutionDescription->"Automatically set to the MagneticBeadSeparationQuinaryWashAspirationVolume specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationQuinaryWashAspirationVolume is automatically set to the MagneticBeadSeparationQuinaryWashSolutionVolume if MagneticBeadSeparationQuinaryWash is True.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Alternatives[
			"All" -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[All]
			],
			"Volume" -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[$MinRoboticTransferVolume, $MaxRoboticTransferVolume],
				Units -> {Microliter, {Microliter, Milliliter}}
			]
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		QuinaryWashCollectionContainer,
		{
			OptionName->MagneticBeadSeparationQuinaryWashCollectionContainer,
			Description->"The container used to collect the used MagneticBeadSeparationQuinaryWashSolution aspirated during quinary wash.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationQuinaryWashCollectionContainer specified by the selected Method. Otherwise set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"].",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		QuinaryWashCollectionStorageCondition,
		{
			OptionName->MagneticBeadSeparationQuinaryWashCollectionStorageCondition,
			Description->"The non-default condition under which the aspirated used MagneticBeadSeparationQuinaryWashSolution during quinary wash are stored after the protocol is completed.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationQuinaryWashCollectionStorageCondition specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationQuinaryWashCollectionStorageCondition is automatically set to Refrigerator if MagneticBeadSeparationQuinaryWash is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		NumberOfQuinaryWashes,
		{
			OptionName->NumberOfMagneticBeadSeparationQuinaryWashes,
			Description->"The number of times that the magnetic beads are washed by adding MagneticBeadSeparationQuinaryWashSolution, mixing, magnetization, and aspirating solution prior to elution or optional SenaryWash.",
			ResolutionDescription->"Automatically set to the NumberOfMagneticBeadSeparationQuinaryWashes specified by the selected Method. If Method is set to Custom, NumberOfMagneticBeadSeparationQuinaryWashes is automatically set to 1 if MagneticBeadSeparationQuinaryWash is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		QuinaryWashAirDry,
		{
			OptionName->MagneticBeadSeparationQuinaryWashAirDry,
			Description->"Indicates if the magnetic beads are exposed to open air to evaporate the remaining solution after aspiration of the used MagneticBeadSeparationQuinaryWashSolution and prior to elution or optional SenaryWash.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationQuinaryWashAirDry specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationQuinaryWashAirDry is automatically set to False if MagneticBeadSeparationQuinaryWash is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		QuinaryWashAirDryTime,
		{
			OptionName->MagneticBeadSeparationQuinaryWashAirDryTime,
			Description->"The duration that the magnetic beads are exposed to open air to evaporate the remaining MagneticBeadSeparationQuinaryWashSolution after aspiration of the used MagneticBeadSeparationQuinaryWashSolution and prior to elution.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationQuinaryWashAirDryTime specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationQuinaryWashAirDryTime is automatically set to 1 Minute if MagneticBeadSeparationQuinaryWashAirDry is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	(*--- SENARY WASH OPTIONS---*)

	ModifyOptions[ExperimentMagneticBeadSeparation,
		SenaryWash,
		{
			OptionName->MagneticBeadSeparationSenaryWash,
			Default->Automatic,
			Description->"Indicates if the magnetic beads with bound targets or contaminants are further rinsed after MagneticBeadSeparationQuinaryWash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional SeptenaryWash.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationSenaryWash specified by the selected Method. If Method is set to Custom, automatically set to True if other MagneticBeadSeparationSenaryWash options are set, or False otherwise.", 
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			NestedIndexMatching->False,
			Category->"Magnetic Bead Separation" 
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		SenaryWashBuffer,
		{
			OptionName->MagneticBeadSeparationSenaryWashSolution,
			Description->"The solution used to rinse the magnetic beads during senary wash in order to better separate the bead-bound components from the unbound components in the sample prior to elution or optional SeptenaryWash.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationSenaryWashSolution specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationSenaryWashSolution is automatically set to Model[Sample,\"Milli-Q water\"] if MagneticBeadSeparationSenaryWash is set to True.",
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation" 
		}
	],
	{
		OptionName -> MagneticBeadSeparationSenaryWashSolutionVolume,
		Description -> "The amount of MagneticBeadSeparationSenaryWashSolution that is added to the magnetic beads for each senary wash.",
		ResolutionDescription -> "If MagneticBeadSeparationSenaryWash is set to True, MagneticBeadSeparationSenaryWashSolutionVolume is automatically set to MagneticBeadSeparationPreWashSolutionVolume when MagneticBeadSeparationPreWash is set to True, and is set to MagneticBeadSeparationSampleVolume when MagneticBeadSeparationPreWash is set to False.",
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> RangeP[$MinRoboticTransferVolume, $MaxRoboticTransferVolume], 
			Units -> {Microliter, {Microliter, Milliliter}}
		],
		AllowNull->True,
		Default->Automatic,
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		SenaryWashMix,
		{
			OptionName->MagneticBeadSeparationSenaryWashMix,
			Description->"Indicates if the solution is mixed following combination of MagneticBeadSeparationSenaryWashSolution and the magnetic beads.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationSenaryWashMix specified by the selected Method. If Method is Custom, MagneticBeadSeparationSenaryWashMix is automatically set to True if MagneticBeadSeparationSenaryWash is set to True and MagneticBeadSeparationSenaryWashMixType is not set to Null.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName -> MagneticBeadSeparationSenaryWashMixType,
		Description -> "The style of motion used to mix the suspension following the addition of the MagneticBeadSeparationSenaryWashSolution to the magnetic beads.",
		ResolutionDescription -> "Automatically set to the MagneticBeadSeparationSenaryWashMixType specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationSenaryWashMix is set to True, MagneticBeadSeparationSenaryWashMixType is automatically set based on the volume-to-mix (i.e. the volume of the combined MagneticBeadSeparationSenaryWashSolution and magnetic beads) and the senaryWash mix options. Specifically, MagneticBeadSeparationSenaryWashMixType is automatically set to Pipette when the volume-to-mix is greater than 20 Microliter and none of MagneticBeadSeparationSenaryWashMixRate, MagneticBeadSeparationSenaryWashMixTemperature, and MagneticBeadSeparationSenaryWashMixTime is specified to non-default values. Otherwise, MagneticBeadSeparationSenaryWashMixType is automatically set to Shake.",
		AllowNull -> True,
		Default -> Automatic,
		Widget -> Widget[
			Type -> Enumeration,
			Pattern :> Shake | Pipette
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		SenaryWashMixTime,
		{
			OptionName -> MagneticBeadSeparationSenaryWashMixTime,
			Description -> "The duration during which the combined MagneticBeadSeparationSenaryWashSolution and magnetic beads is mixed by the selected MagneticBeadSeparationSenaryWashMixType.",
			ResolutionDescription -> "Automatically set to the MagneticBeadSeparationSenaryWashMixTime specified by the selected Method. If Method is set to Custom, automatically set to 5 Minute if MagneticBeadSeparationSenaryWashMixType is set to Shake.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName->MagneticBeadSeparationSenaryWashMixRate,
		Description->"The number of rotations per minute at which the combined MagneticBeadSeparationSenaryWashSolution and magnetic beads is shaken in order to fully mix.",
		ResolutionDescription->"Automatically set to the MagneticBeadSeparationSenaryWashMixRate specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationSenaryWashMixType is set to Shake, MagneticBeadSeparationSenaryWashMixRate is automatically set to 300 RPM.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> RangeP[$MinBioSTARMixRate, $MaxBioSTARMixRate],
			Units -> RPM
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		NumberOfSenaryWashMixes,
		{
			OptionName->NumberOfMagneticBeadSeparationSenaryWashMixes,
			Description->"The number of times that the combined MagneticBeadSeparationSenaryWashSolution and magnetic beads is mixed by pipetting the MagneticBeadSeparationSenaryWashMixVolume up and down following the addition of MagneticBeadSeparationSenaryWashSolution to the magnetic beads in order to fully mix.", 
			ResolutionDescription->"Automatically set to the NumberOfMagneticBeadSeparationSenaryWashMixes specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationSenaryWashMixType is set to Pipette, NumberOfMagneticBeadSeparationSenaryWashMixes is automatically set to 10.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName->MagneticBeadSeparationSenaryWashMixVolume,
		Description->"The volume of combined MagneticBeadSeparationSenaryWashSolution and magnetic beads that is displaced during each mix-by-pipette mix cycle.",
		ResolutionDescription->"Automatically set to 970 Microliter if 1/2*volume-to-mix (i.e.volume-to-mix is the volume of the combined MagneticBeadSeparationSenaryWashSolution and magnetic beads) is greater than 970 Microliter, and otherwise is set to the greater of 10 Microliter and 1/2*volume-to-mix.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> RangeP[$MinRoboticTransferVolume, $MaxRoboticSingleTransferVolume],
			Units -> {Microliter, {Microliter, Milliliter}}
		],
		Category -> "Magnetic Bead Separation"
	},
	{
		OptionName->MagneticBeadSeparationSenaryWashMixTemperature,
		Description->"The temperature at which the Instrument heating or cooling the sample is maintained during the MagneticBeadSeparationSenaryWashMix, which occurs after adding MagneticBeadSeparationSenaryWashSolution to the magnetic beads and before the SenaryWashMagnetizationTime.",
		ResolutionDescription->"Automatically set to the MagneticBeadSeparationSenaryWashMixTemperature specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationSenaryWashMixType is not Null, MagneticBeadSeparationSenaryWashMixTemperature is automatically set to Ambient.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Alternatives[
			Widget[
				Type -> Quantity,
				Pattern :> RangeP[$MinRoboticIncubationTemperature, $MaxRoboticIncubationTemperature],
				Units -> {Celsius, {Celsius, Fahrenheit}}
			],
			Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[Ambient]
			]
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		SenaryWashMixTipType,
		{
			OptionName -> MagneticBeadSeparationSenaryWashMixTipType,
			Description -> "The type of pipette tips used to mix the combined MagneticBeadSeparationSenaryWashSolution and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator.",
			ResolutionDescription -> "Automatically set to WideBore if MagneticBeadSeparationSenaryWashMixType is Pipette.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		SenaryWashMixTipMaterial,
		{
			OptionName -> MagneticBeadSeparationSenaryWashMixTipMaterial,
			Description -> "The material of the pipette tips used to aspirate and dispense the requested volume during the MagneticBeadSeparationSenaryWashMix.",
			ResolutionDescription -> "Automatically set to Polypropylene if MagneticBeadSeparationSenaryWashMixType is Pipette.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		SenaryWashMagnetizationTime,
		{
			OptionName->SenaryWashMagnetizationTime,
			Description->"The duration of magnetizing the magnetic beads after MagneticBeadSeparationSenaryWashMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used MagneticBeadSeparationSenaryWashSolution.",
			ResolutionDescription->"Automatically set to the SenaryWashMagnetizationTime specified by the selected Method. If Method is set to Custom, SenaryWashMagnetizationTime is automatically set to 5 minutes if MagneticBeadSeparationSenaryWash is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName->MagneticBeadSeparationSenaryWashAspirationVolume,
		Description->"The volume of used MagneticBeadSeparationSenaryWashSolution to aspirate out while the magnetic beads are magnetized and gathered to the side after the elapse of SenaryWashMagnetizationTime.",
		ResolutionDescription->"Automatically set to the MagneticBeadSeparationSenaryWashAspirationVolume specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationSenaryWashAspirationVolume is automatically set to the MagneticBeadSeparationSenaryWashSolutionVolume if MagneticBeadSeparationSenaryWash is True.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Alternatives[
			"All" -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[All]
			],
			"Volume" -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[$MinRoboticTransferVolume, $MaxRoboticTransferVolume],
				Units -> {Microliter, {Microliter, Milliliter}}
			]
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		SenaryWashCollectionContainer,
		{
			OptionName->MagneticBeadSeparationSenaryWashCollectionContainer,
			Description->"The container used to collect the used MagneticBeadSeparationSenaryWashSolution aspirated during senary wash.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationSenaryWashCollectionContainer specified by the selected Method. Otherwise set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"].",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		SenaryWashCollectionStorageCondition,
		{
			OptionName->MagneticBeadSeparationSenaryWashCollectionStorageCondition,
			Description->"The non-default condition under which the aspirated used MagneticBeadSeparationSenaryWashSolution during senary wash are stored after the protocol is completed.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationSenaryWashCollectionStorageCondition specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationSenaryWashCollectionStorageCondition is automatically set to Refrigerator if MagneticBeadSeparationSenaryWash is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		NumberOfSenaryWashes,
		{
			OptionName->NumberOfMagneticBeadSeparationSenaryWashes,
			Description->"The number of times that the magnetic beads are washed by adding MagneticBeadSeparationSenaryWashSolution, mixing, magnetization, and aspirating solution prior to elution or optional SeptenaryWash.",
			ResolutionDescription->"Automatically set to the NumberOfMagneticBeadSeparationSenaryWashes specified by the selected Method. If Method is set to Custom, NumberOfMagneticBeadSeparationSenaryWashes is automatically set to 1 if MagneticBeadSeparationSenaryWash is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		SenaryWashAirDry,
		{
			OptionName->MagneticBeadSeparationSenaryWashAirDry,
			Description->"Indicates if the magnetic beads are exposed to open air to evaporate the remaining solution after aspiration of the used MagneticBeadSeparationSenaryWashSolution and prior to elution or optional SeptenaryWash.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationSenaryWashAirDry specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationSenaryWashAirDry is automatically set to False if MagneticBeadSeparationSenaryWash is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		SenaryWashAirDryTime,
		{
			OptionName->MagneticBeadSeparationSenaryWashAirDryTime,
			Description->"The duration that the magnetic beads are exposed to open air to evaporate the remaining MagneticBeadSeparationSenaryWashSolution after aspiration of the used MagneticBeadSeparationSenaryWashSolution and prior to elution.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationSenaryWashAirDryTime specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationSenaryWashAirDryTime is automatically set to 1 Minute if MagneticBeadSeparationSenaryWashAirDry is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],

	(*--- SEPTENARY WASH OPTIONS---*)

	ModifyOptions[ExperimentMagneticBeadSeparation,
		SeptenaryWash,
		{
			OptionName->MagneticBeadSeparationSeptenaryWash,
			Default->Automatic,
			Description->"Indicates if the magnetic beads with bound targets or contaminants are further rinsed after MagneticBeadSeparationSenaryWash in order to better separate the bead-bound components from the unbound components in the sample prior to elution.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationSeptenaryWash specified by the selected Method. If Method is set to Custom, automatically set to True if other MagneticBeadSeparationSeptenaryWash options are set, or False otherwise.", 
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			NestedIndexMatching->False,
			Category->"Magnetic Bead Separation" 
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		SeptenaryWashBuffer,
		{
			OptionName->MagneticBeadSeparationSeptenaryWashSolution,
			Description->"The solution used to rinse the magnetic beads during septenary wash in order to better separate the bead-bound components from the unbound components in the sample prior to elution.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationSeptenaryWashSolution specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationSeptenaryWashSolution is automatically set to Model[Sample,\"Milli-Q water\"] if MagneticBeadSeparationSeptenaryWash is set to True.",
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation" 
		}
	],
	{
		OptionName -> MagneticBeadSeparationSeptenaryWashSolutionVolume,
		Description -> "The amount of MagneticBeadSeparationSeptenaryWashSolution that is added to the magnetic beads for each septenary wash.",
		ResolutionDescription -> "If MagneticBeadSeparationSeptenaryWash is set to True, MagneticBeadSeparationSeptenaryWashSolutionVolume is automatically set to MagneticBeadSeparationPreWashSolutionVolume when MagneticBeadSeparationPreWash is set to True, and is set to MagneticBeadSeparationSampleVolume when MagneticBeadSeparationPreWash is set to False.",
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> RangeP[$MinRoboticTransferVolume, $MaxRoboticTransferVolume], 
			Units -> {Microliter, {Microliter, Milliliter}}
		],
		AllowNull->True,
		Default->Automatic,
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		SeptenaryWashMix,
		{
			OptionName->MagneticBeadSeparationSeptenaryWashMix,
			Description->"Indicates if the solution is mixed following combination of MagneticBeadSeparationSeptenaryWashSolution and the magnetic beads.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationSeptenaryWashMix specified by the selected Method. If Method is Custom, MagneticBeadSeparationSeptenaryWashMix is automatically set to True if MagneticBeadSeparationSeptenaryWash is set to True and MagneticBeadSeparationSeptenaryWashMixType is not set to Null.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName -> MagneticBeadSeparationSeptenaryWashMixType,
		Description -> "The style of motion used to mix the suspension following the addition of the MagneticBeadSeparationSeptenaryWashSolution to the magnetic beads.",
		ResolutionDescription -> "Automatically set to the MagneticBeadSeparationSeptenaryWashMixType specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationSeptenaryWashMix is set to True, MagneticBeadSeparationSeptenaryWashMixType is automatically set based on the volume-to-mix (i.e. the volume of the combined MagneticBeadSeparationSeptenaryWashSolution and magnetic beads) and the septenaryWash mix options. Specifically, MagneticBeadSeparationSeptenaryWashMixType is automatically set to Pipette when the volume-to-mix is greater than 20 Microliter and none of MagneticBeadSeparationSeptenaryWashMixRate, MagneticBeadSeparationSeptenaryWashMixTemperature, and MagneticBeadSeparationSeptenaryWashMixTime is specified to non-default values. Otherwise, MagneticBeadSeparationSeptenaryWashMixType is automatically set to Shake.",
		AllowNull -> True,
		Default -> Automatic,
		Widget -> Widget[
			Type -> Enumeration,
			Pattern :> Shake | Pipette
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		SeptenaryWashMixTime,
		{
			OptionName -> MagneticBeadSeparationSeptenaryWashMixTime,
			Description -> "The duration during which the combined MagneticBeadSeparationSeptenaryWashSolution and magnetic beads is mixed by the selected MagneticBeadSeparationSeptenaryWashMixType.",
			ResolutionDescription -> "Automatically set to the MagneticBeadSeparationSeptenaryWashMixTime specified by the selected Method. If Method is set to Custom, automatically set to 5 Minute if MagneticBeadSeparationSeptenaryWashMixType is set to Shake.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName->MagneticBeadSeparationSeptenaryWashMixRate,
		Description->"The number of rotations per minute at which the combined MagneticBeadSeparationSeptenaryWashSolution and magnetic beads is shaken in order to fully mix.",
		ResolutionDescription->"Automatically set to the MagneticBeadSeparationSeptenaryWashMixRate specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationSeptenaryWashMixType is set to Shake, MagneticBeadSeparationSeptenaryWashMixRate is automatically set to 300 RPM.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> RangeP[$MinBioSTARMixRate, $MaxBioSTARMixRate],
			Units -> RPM
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		NumberOfSeptenaryWashMixes,
		{
			OptionName->NumberOfMagneticBeadSeparationSeptenaryWashMixes,
			Description->"The number of times that the combined MagneticBeadSeparationSeptenaryWashSolution and magnetic beads is mixed by pipetting the MagneticBeadSeparationSeptenaryWashMixVolume up and down following the addition of MagneticBeadSeparationSeptenaryWashSolution to the magnetic beads in order to fully mix.",
			ResolutionDescription->"Automatically set to the NumberOfMagneticBeadSeparationSeptenaryWashMixes specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationSeptenaryWashMixType is set to Pipette, NumberOfMagneticBeadSeparationSeptenaryWashMixes is automatically set to 10.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName->MagneticBeadSeparationSeptenaryWashMixVolume,
		Description->"The volume of combined MagneticBeadSeparationSeptenaryWashSolution and magnetic beads that is displaced during each mix-by-pipette mix cycle.",
		ResolutionDescription->"Automatically set to 970 Microliter if 1/2*volume-to-mix (i.e.volume-to-mix is the volume of the combined MagneticBeadSeparationSeptenaryWashSolution and magnetic beads) is greater than 970 Microliter, and otherwise is set to the greater of 10 Microliter and 1/2*volume-to-mix",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> RangeP[$MinRoboticTransferVolume, $MaxRoboticSingleTransferVolume],
			Units -> {Microliter, {Microliter, Milliliter}}
		],
		Category -> "Magnetic Bead Separation"
	},
	{
		OptionName->MagneticBeadSeparationSeptenaryWashMixTemperature,
		Description->"The temperature at which the Instrument heating or cooling the sample is maintained during the MagneticBeadSeparationSeptenaryWashMix, which occurs after adding MagneticBeadSeparationSeptenaryWashSolution to the magnetic beads and before the SeptenaryWashMagnetizationTime.",
		ResolutionDescription->"Automatically set to the MagneticBeadSeparationSeptenaryWashMixTemperature specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationSeptenaryWashMixType is not Null, MagneticBeadSeparationSeptenaryWashMixTemperature is automatically set to Ambient.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Alternatives[
			Widget[
				Type -> Quantity,
				Pattern :> RangeP[$MinRoboticIncubationTemperature, $MaxRoboticIncubationTemperature],
				Units -> {Celsius, {Celsius, Fahrenheit}}
			],
			Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[Ambient]
			]
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		SeptenaryWashMixTipType,
		{
			OptionName -> MagneticBeadSeparationSeptenaryWashMixTipType,
			Description -> "The type of pipette tips used to mix the combined MagneticBeadSeparationSeptenaryWashSolution and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator.",
			ResolutionDescription -> "Automatically set to WideBore if MagneticBeadSeparationSeptenaryWashMixType is Pipette.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		SeptenaryWashMixTipMaterial,
		{
			OptionName -> MagneticBeadSeparationSeptenaryWashMixTipMaterial,
			Description -> "The material of the pipette tips used to aspirate and dispense the requested volume during the MagneticBeadSeparationSeptenaryWashMix.",
			ResolutionDescription -> "Automatically set to Polypropylene if MagneticBeadSeparationSeptenaryWashMixType is Pipette.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		SeptenaryWashMagnetizationTime,
		{
			OptionName->SeptenaryWashMagnetizationTime,
			Description->"The duration of magnetizing the magnetic beads after MagneticBeadSeparationSeptenaryWashMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used MagneticBeadSeparationSeptenaryWashSolution.",
			ResolutionDescription->"Automatically set to the SeptenaryWashMagnetizationTime specified by the selected Method. If Method is set to Custom, SeptenaryWashMagnetizationTime is automatically set to 5 minutes if MagneticBeadSeparationSeptenaryWash is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName->MagneticBeadSeparationSeptenaryWashAspirationVolume,
		Description->"The volume of used MagneticBeadSeparationSeptenaryWashSolution to aspirate out while the magnetic beads are magnetized and gathered to the side after the elapse of SeptenaryWashMagnetizationTime.",
		ResolutionDescription->"Automatically set to the MagneticBeadSeparationSeptenaryWashAspirationVolume specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationSeptenaryWashAspirationVolume is automatically set to the MagneticBeadSeparationSeptenaryWashSolutionVolume if MagneticBeadSeparationSeptenaryWash is True.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Alternatives[
			"All" -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[All]
			],
			"Volume" -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[$MinRoboticTransferVolume, $MaxRoboticTransferVolume],
				Units -> {Microliter, {Microliter, Milliliter}}
			]
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		SeptenaryWashCollectionContainer,
		{
			OptionName->MagneticBeadSeparationSeptenaryWashCollectionContainer,
			Description->"The container used to collect the used MagneticBeadSeparationSeptenaryWashSolution aspirated during septenary wash.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationSeptenaryWashCollectionContainer specified by the selected Method. Otherwise set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"].",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		SeptenaryWashCollectionStorageCondition,
		{
			OptionName->MagneticBeadSeparationSeptenaryWashCollectionStorageCondition,
			Description->"The non-default condition under which the aspirated used MagneticBeadSeparationSeptenaryWashSolution during septenary wash are stored after the protocol is completed.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationSeptenaryWashCollectionStorageCondition specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationSeptenaryWashCollectionStorageCondition is automatically set to Refrigerator if MagneticBeadSeparationSeptenaryWash is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		NumberOfSeptenaryWashes,
		{
			OptionName->NumberOfMagneticBeadSeparationSeptenaryWashes,
			Description->"The number of times that the magnetic beads are washed by adding MagneticBeadSeparationSeptenaryWashSolution, mixing, magnetization, and aspirating solution prior to elution.",
			ResolutionDescription->"Automatically set to the NumberOfMagneticBeadSeparationSeptenaryWashes specified by the selected Method. If Method is set to Custom, NumberOfMagneticBeadSeparationSeptenaryWashes is automatically set to 1 if MagneticBeadSeparationSeptenaryWash is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		SeptenaryWashAirDry,
		{
			OptionName->MagneticBeadSeparationSeptenaryWashAirDry,
			Description->"Indicates if the magnetic beads are exposed to open air to evaporate the remaining solution after aspiration of the used MagneticBeadSeparationSeptenaryWashSolution and prior to elution.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationSeptenaryWashAirDry specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationSeptenaryWashAirDry is automatically set to False if MagneticBeadSeparationSeptenaryWash is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		SeptenaryWashAirDryTime,
		{
			OptionName->MagneticBeadSeparationSeptenaryWashAirDryTime,
			Description->"The duration that the magnetic beads are exposed to open air to evaporate the remaining MagneticBeadSeparationSeptenaryWashSolution after aspiration of the used MagneticBeadSeparationSeptenaryWashSolution and prior to elution.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationSeptenaryWashAirDryTime specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationSeptenaryWashAirDryTime is automatically set to 1 Minute if MagneticBeadSeparationSeptenaryWashAirDry is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],

	(*--- ELUTION OPTIONS---*)

	ModifyOptions[ExperimentMagneticBeadSeparation,
		Elution,
		{
			OptionName->MagneticBeadSeparationElution,
			Default->Automatic,
			Description->"Indicates if the magnetic beads are rinsed in a different buffer condition in order to release the components bound to the magnetic beads.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationElution specified by the selected Method. If Method is set to Custom, automatically set to True if other MagneticBeadSeparationElution options are set or MagneticBeadSeparationSelectionStrategy is Positive, or False otherwise.",
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			NestedIndexMatching->False,
			Category->"Magnetic Bead Separation" 
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		ElutionBuffer,
		{
			OptionName->MagneticBeadSeparationElutionSolution,
			Description->"The solution used to rinse the magnetic beads, providing a buffer condition in order to release the components bound to the magnetic beads.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationElutionSolution specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationElutionSolution is automatically set to Model[Sample,\"Milli-Q water\"] if MagneticBeadSeparationElution is set to True.",
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation" 
		}
	],
	{
		OptionName -> MagneticBeadSeparationElutionSolutionVolume,
		Description -> "The amount of MagneticBeadSeparationElutionSolution that is added to the magnetic beads for each elution.",
		ResolutionDescription -> "Automatically set to 1/10 of MagneticBeadSeparationSampleVolume if MagneticBeadSeparationElution is set to True.",
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> RangeP[$MinRoboticTransferVolume, $MaxRoboticTransferVolume],
			Units -> {Microliter, {Microliter, Milliliter}}
		],
		AllowNull->True,
		Default->Automatic,
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		ElutionMix,
		{
			OptionName->MagneticBeadSeparationElutionMix,
			Description->"Indicates if the solution is mixed following combination of MagneticBeadSeparationElutionSolution and the magnetic beads.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationElutionMix specified by the selected Method. If Method is Custom, MagneticBeadSeparationElutionMix is automatically set to True if MagneticBeadSeparationElution is set to True and ElutionMixType is not set to Null.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName -> MagneticBeadSeparationElutionMixType,
		Description -> "The style of motion used to mix the suspension following the addition of the MagneticBeadSeparationElutionSolution to the magnetic beads.",
		ResolutionDescription -> "Automatically set to the MagneticBeadSeparationElutionMixType specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationElutionMix is set to True, MagneticBeadSeparationElutionMixType is automatically set based on the volume-to-mix (i.e. the volume of the combined MagneticBeadSeparationElutionSolution and magnetic beads) and the elution mix options. Specifically, MagneticBeadSeparationElutionMixType is automatically set to Pipette when the volume-to-mix is greater than 20 Microliter and none of MagneticBeadSeparationElutionMixRate, MagneticBeadSeparationElutionMixTemperature, and MagneticBeadSeparationElutionMixTime is specified to non-default values. Otherwise, MagneticBeadSeparationElutionMixType is automatically set to Shake.",
		AllowNull -> True,
		Default -> Automatic,
		Widget -> Widget[
			Type -> Enumeration,
			Pattern :> Shake | Pipette
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		ElutionMixTime,
		{
			OptionName -> MagneticBeadSeparationElutionMixTime,
			Description -> "The duration during which the combined MagneticBeadSeparationElutionSolution and magnetic beads is mixed by the selected MagneticBeadSeparationElutionMixType.",
			ResolutionDescription -> "Automatically set to the MagneticBeadSeparationElutionMixTime specified by the selected Method. If Method is set to Custom, automatically set to 5 Minute if MagneticBeadSeparationElutionMixType is set to Shake.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName->MagneticBeadSeparationElutionMixRate,
		Description->"The number of rotations per minute at which the combined MagneticBeadSeparationElutionSolution and magnetic beads is shaken in order to fully mix.",
		ResolutionDescription->"Automatically set to the MagneticBeadSeparationElutionMixRate specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationElutionMixType is set to Shake, MagneticBeadSeparationElutionMixRate is automatically set to 300 RPM.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> RangeP[$MinBioSTARMixRate, $MaxBioSTARMixRate],
			Units -> RPM
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		NumberOfElutionMixes,
		{
			OptionName->NumberOfMagneticBeadSeparationElutionMixes,
			Description->"The number of times that the combined MagneticBeadSeparationElutionSolution and magnetic beads is mixed by pipetting the MagneticBeadSeparationElutionMixVolume up and down following the addition of MagneticBeadSeparationElutionSolution to the magnetic beads in order to fully mix.", 
			ResolutionDescription->"Automatically set to the NumberOfMagneticBeadSeparationElutionMixes specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationElutionMixType is set to Pipette, NumberOfMagneticBeadSeparationElutionMixes is automatically set to 10.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName->MagneticBeadSeparationElutionMixVolume,
		Description->"The volume of the combined MagneticBeadSeparationElutionSolution and magnetic beads that is displaced during each mix-by-pipette mix cycle.",
		ResolutionDescription->"Automatically set to 970 Microliter if 1/2*volume-to-mix (i.e.volume-to-mix is the volume of the combined MagneticBeadSeparationElutionSolution and magnetic beads) is greater than 970 Microliter, and otherwise is set to the greater of 10 Microliter and 1/2*volume-to-mix",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Widget[
			Type -> Quantity,
			Pattern :> RangeP[$MinRoboticTransferVolume, $MaxRoboticSingleTransferVolume],
			Units -> {Microliter, {Microliter, Milliliter}}
		],
		Category -> "Magnetic Bead Separation"
	},
	{
		OptionName->MagneticBeadSeparationElutionMixTemperature,
		Description->"The temperature at which the Instrument heating or cooling the combined MagneticBeadSeparationElutionSolution and magnetic beads is maintained during the MagneticBeadSeparationElutionMix, which occurs after adding MagneticBeadSeparationElutionSolution to the magnetic beads and before the ElutionMagnetizationTime.",
		ResolutionDescription->"Automatically set to the MagneticBeadSeparationElutionMixTemperature specified by the selected Method. If Method is set to Custom and MagneticBeadSeparationElutionMixType is not Null, MagneticBeadSeparationElutionMixTemperature is automatically set to Ambient.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Alternatives[
			Widget[
				Type -> Quantity,
				Pattern :> RangeP[$MinRoboticIncubationTemperature, $MaxRoboticIncubationTemperature],
				Units -> {Celsius, {Celsius, Fahrenheit}}
			],
			Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[Ambient]
			]
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		ElutionMixTipType,
		{
			OptionName -> MagneticBeadSeparationElutionMixTipType,
			Description -> "The type of pipette tips used to mix the combined MagneticBeadSeparationElutionSolution and magnetic beads. Options include Normal, Barrier, WideBore, GelLoading, Aspirator.",
			ResolutionDescription -> "Automatically set to WideBore if MagneticBeadSeparationElutionMixType is Pipette.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		ElutionMixTipMaterial,
		{
			OptionName -> MagneticBeadSeparationElutionMixTipMaterial,
			Description -> "The material of the pipette tips used to aspirate and dispense the requested volume during the MagneticBeadSeparationElutionMix.",
			ResolutionDescription -> "Automatically set to Polypropylene if MagneticBeadSeparationElutionMixType is Pipette.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		ElutionMagnetizationTime,
		{
			OptionName->ElutionMagnetizationTime,
			Description->"The duration of magnetizing the magnetic beads after MagneticBeadSeparationElutionMixTime has elapsed, in order to pull the magnetic beads to the perimeter of the container by applying a magnetic force, thus enables maximal aspiration of the used MagneticBeadSeparationElutionSolution.",
			ResolutionDescription->"Automatically set to the ElutionMagnetizationTime specified by the selected Method. If Method is set to Custom, ElutionMagnetizationTime is automatically set to 5 minutes if MagneticBeadSeparationElution is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	{
		OptionName->MagneticBeadSeparationElutionAspirationVolume,
		Description->"The volume of used MagneticBeadSeparationElutionSolution to aspirate out while the magnetic beads are magnetized and gathered to the side after the elapse of ElutionMagnetizationTime.",
		ResolutionDescription->"Automatically set to the MagneticBeadSeparationElutionAspirationVolume specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationElutionAspirationVolume is automatically set to the MagneticBeadSeparationElutionSolutionVolume if MagneticBeadSeparationElution is True.",
		Default -> Automatic,
		AllowNull -> True,
		Widget -> Alternatives[
			"All" -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[All]
			],
			"Volume" -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[$MinRoboticTransferVolume, $MaxRoboticTransferVolume],
				Units -> {Microliter, {Microliter, Milliliter}}
			]
		],
		Category -> "Magnetic Bead Separation"
	},
	ModifyOptions[ExperimentMagneticBeadSeparation,
		ElutionCollectionContainer,
		{
			OptionName->MagneticBeadSeparationElutionCollectionContainer,
			Description->"The container used to collect the aspirated samples(s) during the elution. Samples collected from multiple elutions are pooled.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationElutionCollectionContainer specified by the selected Method. Otherwise set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"].",
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Alternatives[
				"Container" -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Container], Model[Container]}]
				],
				"Container with Index" -> {
					"Index" -> Widget[
						Type -> Number,
						Pattern :> GreaterEqualP[1, 1]
					],
					"Container" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Container]}],
						PreparedSample -> False,
						PreparedContainer -> False
					]
				},
				"Container with Well" -> {
					"Well" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
						PatternTooltip -> "Enumeration must be any well from A1 to P24."
					],
					"Container" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Object[Container],Model[Container]}],
						PreparedSample -> False,
						PreparedContainer -> False
					]
				},
				"Container with Well and Index" -> {
					"Well" -> Widget[
						Type->Enumeration,
						Pattern:>Alternatives@@Flatten[AllWells[NumberOfWells->384]],
						PatternTooltip->"Enumeration must be any well from A1 to P24."
					],
					"Index and Container" -> {
						"Index" -> Widget[
							Type -> Number,
							Pattern :> GreaterEqualP[1, 1]
						],
						"Container" -> Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Container]}],
							PreparedSample -> False,
							PreparedContainer -> False
						]
					}
				}
			],
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		ElutionCollectionStorageCondition,
		{
			OptionName->MagneticBeadSeparationElutionCollectionStorageCondition,
			Description->"The non-default condition under which the aspirated sample(s) during elution are stored after the protocol is completed.",
			ResolutionDescription->"Automatically set to the MagneticBeadSeparationElutionCollectionStorageCondition specified by the selected Method. If Method is set to Custom, MagneticBeadSeparationElutionCollectionStorageCondition is automatically set to Refrigerator if MagneticBeadSeparationElution is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	],
	ModifyOptions[ExperimentMagneticBeadSeparation,
		NumberOfElutions,
		{
			OptionName->NumberOfMagneticBeadSeparationElutions,
			Description->"The number of times the bound components on the magnetic beads are eluted by adding MagneticBeadSeparationElutionSolution, mixing, magnetization, and aspiration.",
			ResolutionDescription->"Automatically set to the NumberOfMagneticBeadSeparationElutions specified by the selected Method. If Method is set to Custom, NumberOfMagneticBeadSeparationElutions is automatically set to 1 if MagneticBeadSeparationWash is set to True.",
			Default -> Automatic,
			AllowNull -> True,
			NestedIndexMatching -> False,
			Category -> "Magnetic Bead Separation"
		}
	]
}];


(* NOTE:Remember to call ExtractionMagneticBeadSharedOptions inside of index-matching in your experiment as well. *)
DefineOptionSet[NonIndexMatchedExtractionMagneticBeadSharedOptions:>{
		ModifyOptions[ExperimentMagneticBeadSeparation,
			SelectionStrategy,
			{
				OptionName->MagneticBeadSeparationSelectionStrategy,
				Default->Automatic,
				Description->"Specified if the target analyte (Positive) or contaminants (Negative) binds to the magnetic beads in order to isolate the target analyte. When the target analyte is bound to the magnetic beads (Positive), they are collected as SamplesOut during the elution step. When contaminants are bound to the magnetic beads (Negative), the target analyte remains in the supernatant and is collected as SamplesOut during the loading step.",
				ResolutionDescription->"Automatically set to the MagneticBeadSeparationSelectionStrategy specified by the selected Method. If Method is set to Custom, automatically set to Positive indicating that the target analyte is retained on the magnetic beads and collected as SamplesOut during the elution step.",
				AllowNull->True,
				NestedIndexMatching->False,
				Category->"Magnetic Bead Separation"
			}
		],
		ModifyOptions[ExperimentMagneticBeadSeparation,
			SeparationMode,
			{
				OptionName->MagneticBeadSeparationMode,
				Default->Automatic,
				Description->"The mechanism used to selectively isolate or remove targeted components from the samples by magnetic beads. Options include NormalPhase, ReversePhase, IonExchange, Affinity. In NormalPhase mode, magnetic beads are coated with polar molecules (mainly pure silica) and the mobile phase less polar causing the adsorption of polar targeted components. In ReversePhase mode, magnetic beads are coated with hydrophobic groups on the surface to bind targeted components. In IonExchange mode, magnetic beads coated with ion-exchange groups ionically bind charged targeted components. In Affinity mode, magnetic beads are coated with functional groups that can covalently conjugate ligands on targeted components.",
				ResolutionDescription->"Automatically set to the MagneticBeadSeparationMode specified by the selected Method. If Method is set to Custom, the MagneticBeadSeparationMode is set based on the target of the purification. If the target is a protein Model[Molecule], then MagneticBeadSeparationMode is set to Affinity. If the target is a nucleic acid (e.g. RNA, genomic DNA, plasmid DNA, and any non-mRNA cellular RNA), then MagneticBeadSeparationMode is set to NormalPhase. Otherwise, MagneticBeadSeparationMode is set to IonExchange.",
				AllowNull->True,
				NestedIndexMatching->False,
				Category->"Magnetic Bead Separation"
			}
		]
	}
];

(*---Helper function to unnest container options before returning to shared purification resolver*)
unnestResolvedMBSContainerForPurification[myResolvedOption:
	ListableP[Alternatives[Null,ObjectP[],{_Integer,ObjectP[]},{_String,ObjectP[]},{_String,{_Integer,ObjectP[]}}],4]
]:=Module[
	{indexMatchedContainer},
	indexMatchedContainer = If[MatchQ[myResolvedOption,{_List ..}],
		myResolvedOption[[1]],
		myResolvedOption
	];

	Switch[ToList[indexMatchedContainer],
		(*If it is a listable objects, just flatten it*)
		ListableP[ObjectP[Object[Container]]|ObjectP[Model[Container]],3],
		Flatten[ToList[indexMatchedContainer]],
		(*If it is a listable indices and containers, flatten to singletons*)
		ListableP[{GreaterEqualP[1, 1], ObjectP[Model[Container]]},3],
		Cases[ToList[indexMatchedContainer],{GreaterEqualP[1, 1], ObjectP[Model[Container]]},3],
		(*If it is a listable wells and containers, flatten to singletons*)
		ListableP[{_String,ObjectP[Model[Container]]},4],
		Cases[ToList[indexMatchedContainer],{_String,ObjectP[Model[Container]]},4],
		(*If it is a listable wells indices and containers, flatten to singletons *)
		ListableP[{_String, {GreaterEqualP[1, 1],ObjectP[Model[Container]]}},3],
		Cases[ToList[indexMatchedContainer],{_String, {GreaterEqualP[1, 1],ObjectP[Model[Container]]}},3],
		(*If it is a listable Null, just flatten it*)
		_,
		Flatten[ToList[indexMatchedContainer]]
	]
];

(*---Helper function to unnest container options before returning to shared purification resolver*)
unnestResolvedMBSContainer[myResolvedOption:
	ListableP[Alternatives[Null,ObjectP[],{_Integer,ObjectP[]},{_String,ObjectP[]},{_String,{_Integer,ObjectP[]}}],4]
]:=	Switch[ToList[myResolvedOption],
		(*If it is a listable objects, just flatten it*)
		ListableP[ObjectP[Object[Container]]|ObjectP[Model[Container]],3],
		Flatten[ToList[myResolvedOption]],
		(*If it is a listable indices and containers, flatten to singletons*)
		ListableP[{GreaterEqualP[1, 1], ObjectP[Model[Container]]},3],
		Cases[ToList[myResolvedOption],{GreaterEqualP[1, 1], ObjectP[Model[Container]]},3],
		(*If it is a listable wells and containers, flatten to singletons*)
		ListableP[{_String,ObjectP[Model[Container]]},4],
		Cases[ToList[myResolvedOption],{_String,ObjectP[Model[Container]]},4],
		(*If it is a listable wells indices and containers, flatten to singletons *)
		ListableP[{_String, {GreaterEqualP[1, 1],ObjectP[Model[Container]]}},3],
		Cases[ToList[myResolvedOption],{_String, {GreaterEqualP[1, 1],ObjectP[Model[Container]]}},3],
		(*If it is a listable Null, just flatten it*)
		_,
		Flatten[ToList[myResolvedOption]]
];

(* ::Subsection:: *)
(* mbsConflictingMethodsTest *)

Error::ConflictingMagneticBeadSeparationMethods = "For sample(s), `1`, at indices, `2`, the selected method(s), `3`, asked for a `4` of `5`, that is different from what is specified by other method or the user. For options MagneticBeadSeparationMode and MagneticBeadSeparationSelectionStrategy, the values are required to be the same within an experiment. Please make sure that your methods are compatible to run within one experiment.";

DefineOptions[
	mbsMethodsConflictingOptionsTests,
	Options :> {CacheOption}
];

mbsMethodsConflictingOptionsTests[mySamples : {ObjectP[Object[Sample]]...}, myResolvedOptions : {_Rule...}, gatherTestsQ : BooleanP, myResolutionOptions : OptionsPattern[mbsMethodsConflictingOptionsTests]] := Module[
	{safeOps, cache, messages,
		nonIndexMatchingFieldsToCheck,resolvedValues,methodValuesForAllCheckedOptions,resolvedMethods,
		mbsMethodsConflictingOptions, mbsMethodsConflictingOptionsTest, mbsMethodsConflictingOption},

	(*Pull out the safe options.*)
	safeOps = SafeOptions[mbsMethodsConflictingOptionsTests, ToList[myResolutionOptions]];

	(* Lookup our cache and simulation. *)
	cache = Lookup[ToList[safeOps], Cache, {}];

	(* Determine if we should keep a running list of tests (Output contains Test). *)
	messages = !gatherTestsQ;

	(*nonIndexMatchingFieldsToCheck*)
	nonIndexMatchingFieldsToCheck = {MagneticBeadSeparationSelectionStrategy,MagneticBeadSeparationMode};

	(* Pull out the resolved values. These two options were preresolved to singletons. *)
	resolvedValues = Lookup[myResolvedOptions,nonIndexMatchingFieldsToCheck];

	(* Pull out resolved methods *)
	resolvedMethods = Lookup[Association @@ myResolvedOptions, Method];

	(* Pull out the field values from the method object if there are any *)
	methodValuesForAllCheckedOptions = Transpose@Map[
		Function[{resolvedMethod},
			Map[
				Function[{nonIndexMatchingField},
					If[MatchQ[resolvedMethod,ObjectP[Object[Method]]],
						Download[resolvedMethod, nonIndexMatchingField, Cache -> cache],
						Null
					]
				],
				nonIndexMatchingFieldsToCheck
			]
		],
		resolvedMethods
	];

	(* ---- mbsMethodsConflictingOptionsTests --- *)

(*First MapThread layer over different options*)
	mbsMethodsConflictingOptions = Flatten[MapThread[
		Function[{nonIndexMatchingOption,resolvedValue,methodValuesOfOption},
			MapThread[
				Function[{sample, method, methodValueOfOption, index},
					(*If the method is an object, and resolved Value is not Automatic (i.e. MBS is not used so it was not sent to the preresolver) and it provides option value different from the resolved value, throw an error*)
					(*The case of user overwriting the method to have one with MBS and one without is caught by other error checking messages *)
					If[
						And[
							MatchQ[method, ObjectP[Object[Method, Extraction]]],
							MatchQ[resolvedValue, Except[Automatic]],
							!MatchQ[methodValueOfOption, resolvedValue],
							MatchQ[methodValueOfOption, Except[Null]]
						],
						{
							sample,
							index,
							method,
							nonIndexMatchingOption,
							methodValueOfOption
						},
						Nothing
					]
				],
				{mySamples, resolvedMethods, methodValuesOfOption, Range[Length[mySamples]]}
			]
		],
		{nonIndexMatchingFieldsToCheck,resolvedValues,methodValuesForAllCheckedOptions}
	],1];

	If[Length[mbsMethodsConflictingOptions] > 0 && messages,
		Message[
			Error::ConflictingMagneticBeadSeparationMethods,
			ObjectToString[mbsMethodsConflictingOptions[[All, 1]], Cache -> cache],
			mbsMethodsConflictingOptions[[All,2]],
			mbsMethodsConflictingOptions[[All,3]],
			mbsMethodsConflictingOptions[[All,4]],
			mbsMethodsConflictingOptions[[All,5]]
		];
	];

	mbsMethodsConflictingOptionsTest = If[gatherTestsQ,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = mbsMethodsConflictingOptions[[All, 1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["The sample(s) " <> ObjectToString[affectedSamples, Cache -> cache] <> " have consistent methods for non-index-matching options MagneticBeadSeparationSelectionStrategy and MagneticBeadSeparationMode:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cache] <> " have consistent methods for non-index-matching options MagneticBeadSeparationSelectionStrategy and MagneticBeadSeparationMode:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	mbsMethodsConflictingOption = If[Length[mbsMethodsConflictingOptions] > 0,
		{Method},
		{}
	];

	{
		{
			mbsMethodsConflictingOptionsTest
		},
		mbsMethodsConflictingOption
	}

];

(* ::Subsection::Closed:: *)
(*preResolveMagneticBeadSeparationSharedOptions*)

DefineOptions[
	preResolveMagneticBeadSeparationSharedOptions,
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
		CacheOption,
		SimulationOption
	}
];

preResolveMagneticBeadSeparationSharedOptions[
	mySamples:{ObjectP[Object[Sample]]...},
	myMethods:{(ObjectP[Object[Method]]|Custom)..},
	myOptionMap_List,
	myOptions_List,
	myMapThreadOptions:{_Association..},
	myResolutionOptions:OptionsPattern[preResolveMagneticBeadSeparationSharedOptions]
] := Module[
	{
		safeOps, expandedInputs, expandedSafeOps, cache, simulation, targets, sampleFields, samplePacketFields, samplePackets, methodFields, methodPacketFields, methodPackets, possibleLoadingContainers,containerPackets, resolvedMagneticBeadSeparationSelectionStrategy, resolvedMagneticBeadSeparationMode, preResolvedMagneticBeadSeparationSampleVolumes,preResolvedMagneticBeadSeparationAnalyteAffinityLabels,preResolvedMagneticBeadAffinityLabels,preResolvedMagneticBeads,preResolvedMagneticBeadVolumes,preResolvedMagneticBeadCollectionStorageConditions,preResolvedMagnetizationRacks, preResolvedMagneticBeadSeparationPreWashes,preResolvedMagneticBeadSeparationPreWashSolutions,preResolvedMagneticBeadSeparationPreWashSolutionVolumes,preResolvedMagneticBeadSeparationPreWashMixes,preResolvedMagneticBeadSeparationPreWashMixTypes,preResolvedMagneticBeadSeparationPreWashMixTimes,preResolvedMagneticBeadSeparationPreWashMixRates,preResolvedNumbersOfMagneticBeadSeparationPreWashMixes,preResolvedMagneticBeadSeparationPreWashMixVolumes,preResolvedMagneticBeadSeparationPreWashMixTemperatures,preResolvedMagneticBeadSeparationPreWashMixTipTypes,preResolvedMagneticBeadSeparationPreWashMixTipMaterials,preResolvedPreWashMagnetizationTimes,preResolvedMagneticBeadSeparationPreWashAspirationVolumes,preResolvedMagneticBeadSeparationPreWashCollectionContainers,preResolvedMagneticBeadSeparationPreWashCollectionStorageConditions,preResolvedMagneticBeadSeparationPreWashAirDries,preResolvedMagneticBeadSeparationPreWashAirDryTimes,preResolvedNumbersOfMagneticBeadSeparationPreWashes,preResolvedMagneticBeadSeparationEquilibrations,preResolvedMagneticBeadSeparationEquilibrationSolutions,preResolvedMagneticBeadSeparationEquilibrationSolutionVolumes,preResolvedMagneticBeadSeparationEquilibrationMixes,preResolvedMagneticBeadSeparationEquilibrationMixTypes,preResolvedMagneticBeadSeparationEquilibrationMixTimes,preResolvedMagneticBeadSeparationEquilibrationMixRates,preResolvedNumbersOfMagneticBeadSeparationEquilibrationMixes,preResolvedMagneticBeadSeparationEquilibrationMixVolumes,preResolvedMagneticBeadSeparationEquilibrationMixTemperatures,preResolvedMagneticBeadSeparationEquilibrationMixTipTypes,preResolvedMagneticBeadSeparationEquilibrationMixTipMaterials,preResolvedEquilibrationMagnetizationTimes,preResolvedMagneticBeadSeparationEquilibrationAspirationVolumes,preResolvedMagneticBeadSeparationEquilibrationCollectionContainers,preResolvedMagneticBeadSeparationEquilibrationCollectionStorageConditions,preResolvedMagneticBeadSeparationEquilibrationAirDries,preResolvedMagneticBeadSeparationEquilibrationAirDryTimes,
		preResolvedMagneticBeadSeparationLoadingMixes,preResolvedMagneticBeadSeparationLoadingMixTypes,preResolvedMagneticBeadSeparationLoadingMixTimes,preResolvedMagneticBeadSeparationLoadingMixRates,preResolvedNumbersOfMagneticBeadSeparationLoadingMixes,preResolvedMagneticBeadSeparationLoadingMixVolumes,preResolvedMagneticBeadSeparationLoadingMixTemperatures,preResolvedMagneticBeadSeparationLoadingMixTipTypes,preResolvedMagneticBeadSeparationLoadingMixTipMaterials,preResolvedLoadingMagnetizationTimes,preResolvedMagneticBeadSeparationLoadingAspirationVolumes,preResolvedMagneticBeadSeparationLoadingCollectionContainers,preResolvedMagneticBeadSeparationLoadingCollectionStorageConditions,preResolvedMagneticBeadSeparationLoadingAirDries,preResolvedMagneticBeadSeparationLoadingAirDryTimes,preResolvedMagneticBeadSeparationWashes,preResolvedMagneticBeadSeparationWashSolutions,preResolvedMagneticBeadSeparationWashSolutionVolumes,preResolvedMagneticBeadSeparationWashMixes,preResolvedMagneticBeadSeparationWashMixTypes,preResolvedMagneticBeadSeparationWashMixTimes,preResolvedMagneticBeadSeparationWashMixRates,preResolvedNumbersOfMagneticBeadSeparationWashMixes,preResolvedMagneticBeadSeparationWashMixVolumes,preResolvedMagneticBeadSeparationWashMixTemperatures,preResolvedMagneticBeadSeparationWashMixTipTypes,preResolvedMagneticBeadSeparationWashMixTipMaterials,preResolvedWashMagnetizationTimes,preResolvedMagneticBeadSeparationWashAspirationVolumes,preResolvedMagneticBeadSeparationWashCollectionContainers,preResolvedMagneticBeadSeparationWashCollectionStorageConditions,preResolvedMagneticBeadSeparationWashAirDries,preResolvedMagneticBeadSeparationWashAirDryTimes,preResolvedNumbersOfMagneticBeadSeparationWashes,preResolvedMagneticBeadSeparationSecondaryWashes,preResolvedMagneticBeadSeparationSecondaryWashSolutions,preResolvedMagneticBeadSeparationSecondaryWashSolutionVolumes,preResolvedMagneticBeadSeparationSecondaryWashMixes,preResolvedMagneticBeadSeparationSecondaryWashMixTypes,preResolvedMagneticBeadSeparationSecondaryWashMixTimes,preResolvedMagneticBeadSeparationSecondaryWashMixRates,preResolvedNumbersOfMagneticBeadSeparationSecondaryWashMixes,preResolvedMagneticBeadSeparationSecondaryWashMixVolumes,preResolvedMagneticBeadSeparationSecondaryWashMixTemperatures,preResolvedMagneticBeadSeparationSecondaryWashMixTipTypes,preResolvedMagneticBeadSeparationSecondaryWashMixTipMaterials,preResolvedSecondaryWashMagnetizationTimes,preResolvedMagneticBeadSeparationSecondaryWashAspirationVolumes,preResolvedMagneticBeadSeparationSecondaryWashCollectionContainers,preResolvedMagneticBeadSeparationSecondaryWashCollectionStorageConditions,preResolvedMagneticBeadSeparationSecondaryWashAirDries,preResolvedMagneticBeadSeparationSecondaryWashAirDryTimes,preResolvedNumbersOfMagneticBeadSeparationSecondaryWashes,preResolvedMagneticBeadSeparationTertiaryWashes,preResolvedMagneticBeadSeparationTertiaryWashSolutions,preResolvedMagneticBeadSeparationTertiaryWashSolutionVolumes,preResolvedMagneticBeadSeparationTertiaryWashMixes,preResolvedMagneticBeadSeparationTertiaryWashMixTypes,preResolvedMagneticBeadSeparationTertiaryWashMixTimes,preResolvedMagneticBeadSeparationTertiaryWashMixRates,preResolvedNumbersOfMagneticBeadSeparationTertiaryWashMixes,preResolvedMagneticBeadSeparationTertiaryWashMixVolumes,preResolvedMagneticBeadSeparationTertiaryWashMixTemperatures,preResolvedMagneticBeadSeparationTertiaryWashMixTipTypes,preResolvedMagneticBeadSeparationTertiaryWashMixTipMaterials,preResolvedTertiaryWashMagnetizationTimes,preResolvedMagneticBeadSeparationTertiaryWashAspirationVolumes,preResolvedMagneticBeadSeparationTertiaryWashCollectionContainers,preResolvedMagneticBeadSeparationTertiaryWashCollectionStorageConditions,preResolvedMagneticBeadSeparationTertiaryWashAirDries,preResolvedMagneticBeadSeparationTertiaryWashAirDryTimes,preResolvedNumbersOfMagneticBeadSeparationTertiaryWashes,preResolvedMagneticBeadSeparationQuaternaryWashes,preResolvedMagneticBeadSeparationQuaternaryWashSolutions,preResolvedMagneticBeadSeparationQuaternaryWashSolutionVolumes,preResolvedMagneticBeadSeparationQuaternaryWashMixes,preResolvedMagneticBeadSeparationQuaternaryWashMixTypes,preResolvedMagneticBeadSeparationQuaternaryWashMixTimes,preResolvedMagneticBeadSeparationQuaternaryWashMixRates,preResolvedNumbersOfMagneticBeadSeparationQuaternaryWashMixes,preResolvedMagneticBeadSeparationQuaternaryWashMixVolumes,preResolvedMagneticBeadSeparationQuaternaryWashMixTemperatures,preResolvedMagneticBeadSeparationQuaternaryWashMixTipTypes,preResolvedMagneticBeadSeparationQuaternaryWashMixTipMaterials,preResolvedQuaternaryWashMagnetizationTimes,preResolvedMagneticBeadSeparationQuaternaryWashAspirationVolumes,preResolvedMagneticBeadSeparationQuaternaryWashCollectionContainers,preResolvedMagneticBeadSeparationQuaternaryWashCollectionStorageConditions,preResolvedMagneticBeadSeparationQuaternaryWashAirDries,preResolvedMagneticBeadSeparationQuaternaryWashAirDryTimes,preResolvedNumbersOfMagneticBeadSeparationQuaternaryWashes,preResolvedMagneticBeadSeparationQuinaryWashes,preResolvedMagneticBeadSeparationQuinaryWashSolutions,preResolvedMagneticBeadSeparationQuinaryWashSolutionVolumes,preResolvedMagneticBeadSeparationQuinaryWashMixes,preResolvedMagneticBeadSeparationQuinaryWashMixTypes,preResolvedMagneticBeadSeparationQuinaryWashMixTimes,preResolvedMagneticBeadSeparationQuinaryWashMixRates,preResolvedNumbersOfMagneticBeadSeparationQuinaryWashMixes,preResolvedMagneticBeadSeparationQuinaryWashMixVolumes,preResolvedMagneticBeadSeparationQuinaryWashMixTemperatures,preResolvedMagneticBeadSeparationQuinaryWashMixTipTypes,preResolvedMagneticBeadSeparationQuinaryWashMixTipMaterials,preResolvedQuinaryWashMagnetizationTimes,preResolvedMagneticBeadSeparationQuinaryWashAspirationVolumes,preResolvedMagneticBeadSeparationQuinaryWashCollectionContainers,preResolvedMagneticBeadSeparationQuinaryWashCollectionStorageConditions,preResolvedMagneticBeadSeparationQuinaryWashAirDries,preResolvedMagneticBeadSeparationQuinaryWashAirDryTimes,preResolvedNumbersOfMagneticBeadSeparationQuinaryWashes,preResolvedMagneticBeadSeparationSenaryWashes,preResolvedMagneticBeadSeparationSenaryWashSolutions,preResolvedMagneticBeadSeparationSenaryWashSolutionVolumes,preResolvedMagneticBeadSeparationSenaryWashMixes,preResolvedMagneticBeadSeparationSenaryWashMixTypes,preResolvedMagneticBeadSeparationSenaryWashMixTimes,preResolvedMagneticBeadSeparationSenaryWashMixRates,preResolvedNumbersOfMagneticBeadSeparationSenaryWashMixes,preResolvedMagneticBeadSeparationSenaryWashMixVolumes,preResolvedMagneticBeadSeparationSenaryWashMixTemperatures,preResolvedMagneticBeadSeparationSenaryWashMixTipTypes,preResolvedMagneticBeadSeparationSenaryWashMixTipMaterials,preResolvedSenaryWashMagnetizationTimes,preResolvedMagneticBeadSeparationSenaryWashAspirationVolumes,preResolvedMagneticBeadSeparationSenaryWashCollectionContainers,preResolvedMagneticBeadSeparationSenaryWashCollectionStorageConditions,preResolvedMagneticBeadSeparationSenaryWashAirDries,preResolvedMagneticBeadSeparationSenaryWashAirDryTimes,preResolvedNumbersOfMagneticBeadSeparationSenaryWashes,preResolvedMagneticBeadSeparationSeptenaryWashes,preResolvedMagneticBeadSeparationSeptenaryWashSolutions,preResolvedMagneticBeadSeparationSeptenaryWashSolutionVolumes,preResolvedMagneticBeadSeparationSeptenaryWashMixes,preResolvedMagneticBeadSeparationSeptenaryWashMixTypes,preResolvedMagneticBeadSeparationSeptenaryWashMixTimes,preResolvedMagneticBeadSeparationSeptenaryWashMixRates,preResolvedNumbersOfMagneticBeadSeparationSeptenaryWashMixes,preResolvedMagneticBeadSeparationSeptenaryWashMixVolumes,preResolvedMagneticBeadSeparationSeptenaryWashMixTemperatures,preResolvedMagneticBeadSeparationSeptenaryWashMixTipTypes,preResolvedMagneticBeadSeparationSeptenaryWashMixTipMaterials,preResolvedSeptenaryWashMagnetizationTimes,preResolvedMagneticBeadSeparationSeptenaryWashAspirationVolumes,preResolvedMagneticBeadSeparationSeptenaryWashCollectionContainers,preResolvedMagneticBeadSeparationSeptenaryWashCollectionStorageConditions,preResolvedMagneticBeadSeparationSeptenaryWashAirDries,preResolvedMagneticBeadSeparationSeptenaryWashAirDryTimes,preResolvedNumbersOfMagneticBeadSeparationSeptenaryWashes,preResolvedMagneticBeadSeparationElutions,preResolvedMagneticBeadSeparationElutionSolutions,preResolvedMagneticBeadSeparationElutionSolutionVolumes,preResolvedMagneticBeadSeparationElutionMixes,preResolvedMagneticBeadSeparationElutionMixTypes,preResolvedMagneticBeadSeparationElutionMixTimes,preResolvedMagneticBeadSeparationElutionMixRates,preResolvedNumbersOfMagneticBeadSeparationElutionMixes,preResolvedMagneticBeadSeparationElutionMixVolumes,preResolvedMagneticBeadSeparationElutionMixTemperatures,preResolvedMagneticBeadSeparationElutionMixTipTypes,preResolvedMagneticBeadSeparationElutionMixTipMaterials,preResolvedElutionMagnetizationTimes,preResolvedMagneticBeadSeparationElutionAspirationVolumes,preResolvedMagneticBeadSeparationElutionCollectionContainers,
		preResolvedPackedMagneticBeadSeparationElutionCollectionContainers,
		expandedPackedMagneticBeadSeparationElutionCollectionContainers,preResolvedMagneticBeadSeparationElutionCollectionStorageConditions,preResolvedNumbersOfMagneticBeadSeparationElutions,
		preResolvedPackedMagneticBeadSeparationLoadingCollectionContainers,
		simplePreResolveOption, simplePreResolveOptionNoMethod,
		preResolvedMagneticBeadSeparationPreWashCollectionContainerLabels, preResolvedMagneticBeadSeparationEquilibrationCollectionContainerLabels, preResolvedMagneticBeadSeparationLoadingCollectionContainerLabels, preResolvedMagneticBeadSeparationWashCollectionContainerLabels, preResolvedMagneticBeadSeparationSecondaryWashCollectionContainerLabels, preResolvedMagneticBeadSeparationTertiaryWashCollectionContainerLabels, preResolvedMagneticBeadSeparationQuaternaryWashCollectionContainerLabels, preResolvedMagneticBeadSeparationQuinaryWashCollectionContainerLabels, preResolvedMagneticBeadSeparationSenaryWashCollectionContainerLabels, preResolvedMagneticBeadSeparationSeptenaryWashCollectionContainerLabels, preResolvedMagneticBeadSeparationElutionCollectionContainerLabels,

		preResolvedMBSSharedOptions, preResolvedOptions, modifiedOptionMap, mapThreadReadyPreResolvedMBSOptions, preResolvedMapThreadMBSOptions, preResolvedMapThreadOptions, outputSpecification, output, gatherTestsQ, resolvedMBSOptions, resolvedMBSSimulation, resolvedMBSTests, unNestedResolvedMBSOptions
	},

	(*Pull out the safe options.*)
	safeOps = SafeOptions[preResolveMagneticBeadSeparationSharedOptions, ToList[myResolutionOptions]];

	(* Expand the safe options. *)
	{expandedInputs, expandedSafeOps} = ExpandIndexMatchedInputs[preResolveMagneticBeadSeparationSharedOptions, {mySamples, myMethods, myOptionMap, myOptions, myMapThreadOptions}, safeOps];

	(* Lookup our cache and simulation. *)
	cache = Lookup[ToList[safeOps], Cache, {}];
	simulation = Lookup[ToList[safeOps], Simulation, Null];
	targets = Lookup[ToList[expandedSafeOps], TargetCellularComponent, Null];

	(* Determine the requested return value from the function (Result, Options, Tests, or multiple). *)
	outputSpecification=Lookup[myOptions, Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests (Output contains Test). *)
	gatherTestsQ=MemberQ[output,Tests];

	(* Download fields from samples that are required.*)
	(* NOTE: All fields downloaded below should already be included in the cache passed down to us by the main function. *)
	sampleFields = DeleteDuplicates[Flatten[{Name, Status, Model, Composition, CellType, Living, CultureAdhesion, Volume, Analytes, Density, Container, Position}]];
	samplePacketFields = Packet@@sampleFields;
	methodFields = DeleteDuplicates[Flatten[{
		(*General MBS*)
		MagneticBeadSeparationSelectionStrategy,MagneticBeadSeparationMode,MagneticBeadAffinityLabel,MagneticBeads,MagneticBeadSeparationAnalyteAffinityLabel,
		(*MBS PreWash*)
		MagneticBeadSeparationPreWash,MagneticBeadSeparationPreWashAirDry,MagneticBeadSeparationPreWashAirDryTime,MagneticBeadSeparationPreWashMix,MagneticBeadSeparationPreWashMixRate,MagneticBeadSeparationPreWashMixTemperature,MagneticBeadSeparationPreWashMixTime,MagneticBeadSeparationPreWashMixType,MagneticBeadSeparationPreWashSolution,PreWashMagnetizationTime,NumberOfMagneticBeadSeparationPreWashes,NumberOfMagneticBeadSeparationPreWashMixes,
		(*MBS Equilibration*)
		MagneticBeadSeparationEquilibration,MagneticBeadSeparationEquilibrationAirDry,MagneticBeadSeparationEquilibrationAirDryTime,MagneticBeadSeparationEquilibrationMix,MagneticBeadSeparationEquilibrationMixRate,MagneticBeadSeparationEquilibrationMixTemperature,MagneticBeadSeparationEquilibrationMixTime,MagneticBeadSeparationEquilibrationMixType,MagneticBeadSeparationEquilibrationSolution,NumberOfMagneticBeadSeparationEquilibrationMixes,EquilibrationMagnetizationTime,
		(*MBS Loading*)
		MagneticBeadSeparationLoadingAirDry,MagneticBeadSeparationLoadingAirDryTime,MagneticBeadSeparationLoadingMix,MagneticBeadSeparationLoadingMixRate,MagneticBeadSeparationLoadingMixTemperature,MagneticBeadSeparationLoadingMixTime,MagneticBeadSeparationLoadingMixType,NumberOfMagneticBeadSeparationLoadingMixes,LoadingMagnetizationTime,
		(*MBS Wash*)
		MagneticBeadSeparationWash,MagneticBeadSeparationWashAirDry,MagneticBeadSeparationWashAirDryTime,MagneticBeadSeparationWashMix,MagneticBeadSeparationWashMixRate,MagneticBeadSeparationWashMixTemperature,MagneticBeadSeparationWashMixTime,MagneticBeadSeparationWashMixType,MagneticBeadSeparationWashSolution,NumberOfMagneticBeadSeparationWashes,NumberOfMagneticBeadSeparationWashMixes,WashMagnetizationTime,
		(*MBS SecondaryWash*)
		MagneticBeadSeparationSecondaryWash,MagneticBeadSeparationSecondaryWashAirDry,MagneticBeadSeparationSecondaryWashAirDryTime,MagneticBeadSeparationSecondaryWashMix,MagneticBeadSeparationSecondaryWashMixRate,MagneticBeadSeparationSecondaryWashMixTemperature,MagneticBeadSeparationSecondaryWashMixTime,MagneticBeadSeparationSecondaryWashMixType,MagneticBeadSeparationSecondaryWashSolution,NumberOfMagneticBeadSeparationSecondaryWashes,NumberOfMagneticBeadSeparationSecondaryWashMixes,SecondaryWashMagnetizationTime,
		(*MBS TertiaryWash*)
		MagneticBeadSeparationTertiaryWash,MagneticBeadSeparationTertiaryWashAirDry,MagneticBeadSeparationTertiaryWashAirDryTime,MagneticBeadSeparationTertiaryWashMix,MagneticBeadSeparationTertiaryWashMixRate,MagneticBeadSeparationTertiaryWashMixTemperature,MagneticBeadSeparationTertiaryWashMixTime,MagneticBeadSeparationTertiaryWashMixType,MagneticBeadSeparationTertiaryWashSolution,NumberOfMagneticBeadSeparationTertiaryWashes,NumberOfMagneticBeadSeparationTertiaryWashMixes,TertiaryWashMagnetizationTime,
		(*MBS QuaternaryWash*)
		MagneticBeadSeparationQuaternaryWash,MagneticBeadSeparationQuaternaryWashAirDry,MagneticBeadSeparationQuaternaryWashAirDryTime,MagneticBeadSeparationQuaternaryWashMix,MagneticBeadSeparationQuaternaryWashMixRate,MagneticBeadSeparationQuaternaryWashMixTemperature,MagneticBeadSeparationQuaternaryWashMixTime,MagneticBeadSeparationQuaternaryWashMixType,MagneticBeadSeparationQuaternaryWashSolution,NumberOfMagneticBeadSeparationQuaternaryWashes,NumberOfMagneticBeadSeparationQuaternaryWashMixes,QuaternaryWashMagnetizationTime,
		(*MBS QuinaryWash*)
		MagneticBeadSeparationQuinaryWash,MagneticBeadSeparationQuinaryWashAirDry,MagneticBeadSeparationQuinaryWashAirDryTime,MagneticBeadSeparationQuinaryWashMix,MagneticBeadSeparationQuinaryWashMixRate,MagneticBeadSeparationQuinaryWashMixTemperature,MagneticBeadSeparationQuinaryWashMixTime,MagneticBeadSeparationQuinaryWashMixType,MagneticBeadSeparationQuinaryWashSolution,NumberOfMagneticBeadSeparationQuinaryWashes,NumberOfMagneticBeadSeparationQuinaryWashMixes,QuinaryWashMagnetizationTime,
		(*MBS SenaryWash*)
		MagneticBeadSeparationSenaryWash,MagneticBeadSeparationSenaryWashAirDry,MagneticBeadSeparationSenaryWashAirDryTime,MagneticBeadSeparationSenaryWashMix,MagneticBeadSeparationSenaryWashMixRate,MagneticBeadSeparationSenaryWashMixTemperature,MagneticBeadSeparationSenaryWashMixTime,MagneticBeadSeparationSenaryWashMixType,MagneticBeadSeparationSenaryWashSolution,NumberOfMagneticBeadSeparationSenaryWashes,NumberOfMagneticBeadSeparationSenaryWashMixes,SenaryWashMagnetizationTime,
		(*MBS SeptenaryWash*)
		MagneticBeadSeparationSeptenaryWash,MagneticBeadSeparationSeptenaryWashAirDry,MagneticBeadSeparationSeptenaryWashAirDryTime,MagneticBeadSeparationSeptenaryWashMix,MagneticBeadSeparationSeptenaryWashMixRate,MagneticBeadSeparationSeptenaryWashMixTemperature,MagneticBeadSeparationSeptenaryWashMixTime,MagneticBeadSeparationSeptenaryWashMixType,MagneticBeadSeparationSeptenaryWashSolution,NumberOfMagneticBeadSeparationSeptenaryWashes,NumberOfMagneticBeadSeparationSeptenaryWashMixes,SeptenaryWashMagnetizationTime,
		(*MBS Elution*)
		MagneticBeadSeparationElution,MagneticBeadSeparationElutionMix,MagneticBeadSeparationElutionMixRate,MagneticBeadSeparationElutionMixTemperature,MagneticBeadSeparationElutionMixTime,MagneticBeadSeparationElutionMixType,MagneticBeadSeparationElutionSolution,NumberOfMagneticBeadSeparationElutionMixes,NumberOfMagneticBeadSeparationElutions,ElutionMagnetizationTime
	}]];
	methodPacketFields = Packet@@methodFields;

	possibleLoadingContainers = Cases[
		Join[
			{Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]},
			Lookup[myOptions,MagneticBeadSeparationLoadingCollectionContainer]],
		ObjectP[{Object[Container],Model[Container]}]
	];

	{
		samplePackets,
		methodPackets,
		containerPackets
	} = Download[
		{
			mySamples,
			Replace[myMethods, {Custom -> Null}, 2],
			possibleLoadingContainers
		},
		{
			{samplePacketFields},
			{methodPacketFields},
			{Object,MaxVolume}
		},
		Cache -> cache,
		Simulation -> simulation
	];

	{
		samplePackets,
		methodPackets
	}=Flatten/@{
		samplePackets,
		methodPackets
	};

	(*Resolve magneticBeadSeparationSelectionStrategy*)
	resolvedMagneticBeadSeparationSelectionStrategy = Which[
		(*If specified by the user, set to user-specified value*)
		MatchQ[Lookup[myOptions, MagneticBeadSeparationSelectionStrategy], Except[Automatic]],
			Lookup[myOptions, MagneticBeadSeparationSelectionStrategy],
		(*If specified by any of the methods, set to the first method-specified value. Error checking will catching conflicting ones if there are any. Only one SelectionStrategy is allowed for MBS for one experiment call.*)
		MatchQ[Lookup[myOptions,Method], ListableP[ObjectP[Object[Method]]]] && MatchQ[FirstCase[methodPackets, KeyValuePattern[{MagneticBeadSeparationSelectionStrategy->MagneticBeadSeparationSelectionStrategyP}],Null],PacketP[]],
			Lookup[FirstCase[methodPackets, KeyValuePattern[{MagneticBeadSeparationSelectionStrategy->MagneticBeadSeparationSelectionStrategyP}]], MagneticBeadSeparationSelectionStrategy],
		(* If no samples use MBS, then can set to Null. *)
		!MemberQ[Flatten[Lookup[myOptions, Purification]], MagneticBeadSeparation],
			Null,
		True,
			Module[{unresolvedEssentialElutionOptions},
				unresolvedEssentialElutionOptions = Flatten@Lookup[myOptions,{
					MagneticBeadSeparationElutionSolution,MagneticBeadSeparationElutionSolutionVolume,ElutionMagnetizationTime,NumberOfMagneticBeadSeparationElutions,
					MagneticBeadSeparationElutionMix}];
				(*If Elution is set to False or any essential elution option is set to Null, set to Negative. Otherwise set to Positive*)
				If[MatchQ[Lookup[myOptions,MagneticBeadSeparationElution],ListableP[False]]||MemberQ[unresolvedEssentialElutionOptions,Null],
					Negative,
					Positive
				]
			]
	];

	(*Resolve magneticBeadSeparationMode*)
	resolvedMagneticBeadSeparationMode = Which[
		(*If specified by the user, set to user-specified value*)
		MatchQ[Lookup[myOptions, MagneticBeadSeparationMode], Except[Automatic]],
			Lookup[myOptions, MagneticBeadSeparationMode],
		(*If specified by any of the methods, set to the first method-specified value. Error checking will catching conflicting ones if there are any. Only one SeparationMode is allowed for MBS for one experiment call.*)
		MatchQ[Lookup[myOptions,Method], ListableP[ObjectP[Object[Method]]]] && MatchQ[FirstCase[methodPackets, KeyValuePattern[{MagneticBeadSeparationMode->MagneticBeadSeparationModeP}],Null],PacketP[]],
		Lookup[FirstCase[methodPackets, KeyValuePattern[{MagneticBeadSeparationMode->MagneticBeadSeparationModeP}]], MagneticBeadSeparationMode],
		(* If no samples use MBS, then can set to Null. *)
		!MemberQ[Flatten[Lookup[myOptions, Purification]], MagneticBeadSeparation],
			Null,
		(*If MagneticBeadSeparationMode is not specified as a Purification method by the user or the method, set based on myTarget*)
		True,
			Switch[
				targets,
				(*Set to Affinity if targets are Model[Molecule]s and mRNA*)
				{mRNA|ObjectP[Model[Molecule]]..},Affinity,
				(*Set to NormalPhase if myTargets are DNA or RNA*)
				{Alternatives[RNA,GenomicDNA,PlasmidDNA,Except[mRNA,CellularRNAP]]..},NormalPhase,
				(*Set to IonExchange if myTargets are Protein*)
				_,IonExchange
			]
	];

	(* helper function that does simple pre-resolution logic:*)
	simplePreResolveOption[myOptionName_Symbol, mapThreadedOptions_Association, myMethodPacket_, myMethodSpecifiedQ:BooleanP, myMBSUsedQ:BooleanP]:=Which[
		(* If specified by the user, set to user-specified value *)
		MatchQ[Lookup[mapThreadedOptions, myOptionName], Except[Automatic]],
			Lookup[mapThreadedOptions, myOptionName],
		(* NOTE: Empty single fields are Null, but empty multiple fields are {}, so we check for both. *)
		myMethodSpecifiedQ && MatchQ[Lookup[myMethodPacket, myOptionName, Null], Except[Null|{}]],
			Lookup[myMethodPacket, myOptionName],
		(* If MBS is not used and the option is not specified, it is set to Null. *)
		!myMBSUsedQ,
			Null,
		True,
			Automatic
	];

	(* helper function that does simple pre-resolution logic with no method:*)
	simplePreResolveOptionNoMethod[myOptionName_Symbol, mapThreadedOptions_Association, myMBSUsedQ:BooleanP]:=Which[
		(* If specified by the user, set to user-specified value *)
		MatchQ[Lookup[mapThreadedOptions, myOptionName], Except[Automatic]], Lookup[mapThreadedOptions, myOptionName],
		(* If MBS is not used and the option is not specified, it is set to Null. *)
		!myMBSUsedQ, Null,
		True, Automatic
	];


	(*Pre-resolve MBS shared options (MBS may need to resolve differently based on what function is being called).*)
	{
		(*3*)preResolvedMagneticBeadSeparationSampleVolumes,
		(*4*)preResolvedMagneticBeadSeparationAnalyteAffinityLabels,
		(*5*)preResolvedMagneticBeadAffinityLabels,
		(*6*)preResolvedMagneticBeads,
		(*6.1*)preResolvedMagneticBeadVolumes,
		(*7*)preResolvedMagneticBeadCollectionStorageConditions,
		(*8*)preResolvedMagnetizationRacks,

		(*9*)preResolvedMagneticBeadSeparationPreWashes,
		(*10*)preResolvedMagneticBeadSeparationPreWashSolutions,
		(*11*)preResolvedMagneticBeadSeparationPreWashSolutionVolumes,
		(*12*)preResolvedMagneticBeadSeparationPreWashMixes,
		(*13*)preResolvedMagneticBeadSeparationPreWashMixTypes,
		(*14*)preResolvedMagneticBeadSeparationPreWashMixTimes,
		(*15*)preResolvedMagneticBeadSeparationPreWashMixRates,
		(*16*)preResolvedNumbersOfMagneticBeadSeparationPreWashMixes,
		(*17*)preResolvedMagneticBeadSeparationPreWashMixVolumes,
		(*18*)preResolvedMagneticBeadSeparationPreWashMixTemperatures,
		(*19*)preResolvedMagneticBeadSeparationPreWashMixTipTypes,
		(*20*)preResolvedMagneticBeadSeparationPreWashMixTipMaterials,
		(*21*)preResolvedPreWashMagnetizationTimes,
		(*22*)preResolvedMagneticBeadSeparationPreWashAspirationVolumes,
		(*23*)preResolvedMagneticBeadSeparationPreWashCollectionContainers,
		(*24*)preResolvedMagneticBeadSeparationPreWashCollectionStorageConditions,
		(*25*)preResolvedMagneticBeadSeparationPreWashAirDries,
		(*26*)preResolvedMagneticBeadSeparationPreWashAirDryTimes,
		(*27*)preResolvedNumbersOfMagneticBeadSeparationPreWashes,

		(*28*)preResolvedMagneticBeadSeparationEquilibrations,
		(*29*)preResolvedMagneticBeadSeparationEquilibrationSolutions,
		(*30*)preResolvedMagneticBeadSeparationEquilibrationSolutionVolumes,
		(*31*)preResolvedMagneticBeadSeparationEquilibrationMixes,
		(*32*)preResolvedMagneticBeadSeparationEquilibrationMixTypes,
		(*33*)preResolvedMagneticBeadSeparationEquilibrationMixTimes,
		(*34*)preResolvedMagneticBeadSeparationEquilibrationMixRates,
		(*35*)preResolvedNumbersOfMagneticBeadSeparationEquilibrationMixes,
		(*36*)preResolvedMagneticBeadSeparationEquilibrationMixVolumes,
		(*37*)preResolvedMagneticBeadSeparationEquilibrationMixTemperatures,
		(*38*)preResolvedMagneticBeadSeparationEquilibrationMixTipTypes,
		(*39*)preResolvedMagneticBeadSeparationEquilibrationMixTipMaterials,
		(*40*)preResolvedEquilibrationMagnetizationTimes,
		(*41*)preResolvedMagneticBeadSeparationEquilibrationAspirationVolumes,
		(*42*)preResolvedMagneticBeadSeparationEquilibrationCollectionContainers,
		(*43*)preResolvedMagneticBeadSeparationEquilibrationCollectionStorageConditions,
		(*44*)preResolvedMagneticBeadSeparationEquilibrationAirDries,
		(*45*)preResolvedMagneticBeadSeparationEquilibrationAirDryTimes,

		(*46*)preResolvedMagneticBeadSeparationLoadingMixes,
		(*47*)preResolvedMagneticBeadSeparationLoadingMixTypes,
		(*48*)preResolvedMagneticBeadSeparationLoadingMixTimes,
		(*49*)preResolvedMagneticBeadSeparationLoadingMixRates,
		(*50*)preResolvedNumbersOfMagneticBeadSeparationLoadingMixes,
		(*51*)preResolvedMagneticBeadSeparationLoadingMixVolumes,
		(*52*)preResolvedMagneticBeadSeparationLoadingMixTemperatures,
		(*53*)preResolvedMagneticBeadSeparationLoadingMixTipTypes,
		(*54*)preResolvedMagneticBeadSeparationLoadingMixTipMaterials,
		(*55*)preResolvedLoadingMagnetizationTimes,
		(*56*)preResolvedMagneticBeadSeparationLoadingAspirationVolumes,
		(*57*)preResolvedMagneticBeadSeparationLoadingCollectionContainers,
		(*58*)preResolvedMagneticBeadSeparationLoadingCollectionStorageConditions,
		(*59*)preResolvedMagneticBeadSeparationLoadingAirDries,
		(*60*)preResolvedMagneticBeadSeparationLoadingAirDryTimes,

		(*61*)preResolvedMagneticBeadSeparationWashes,
		(*62*)preResolvedMagneticBeadSeparationWashSolutions,
		(*63*)preResolvedMagneticBeadSeparationWashSolutionVolumes,
		(*64*)preResolvedMagneticBeadSeparationWashMixes,
		(*65*)preResolvedMagneticBeadSeparationWashMixTypes,
		(*66*)preResolvedMagneticBeadSeparationWashMixTimes,
		(*67*)preResolvedMagneticBeadSeparationWashMixRates,
		(*68*)preResolvedNumbersOfMagneticBeadSeparationWashMixes,
		(*69*)preResolvedMagneticBeadSeparationWashMixVolumes,
		(*70*)preResolvedMagneticBeadSeparationWashMixTemperatures,
		(*71*)preResolvedMagneticBeadSeparationWashMixTipTypes,
		(*72*)preResolvedMagneticBeadSeparationWashMixTipMaterials,
		(*73*)preResolvedWashMagnetizationTimes,
		(*74*)preResolvedMagneticBeadSeparationWashAspirationVolumes,
		(*75*)preResolvedMagneticBeadSeparationWashCollectionContainers,
		(*76*)preResolvedMagneticBeadSeparationWashCollectionStorageConditions,
		(*77*)preResolvedMagneticBeadSeparationWashAirDries,
		(*78*)preResolvedMagneticBeadSeparationWashAirDryTimes,
		(*79*)preResolvedNumbersOfMagneticBeadSeparationWashes,

		(*80*)preResolvedMagneticBeadSeparationSecondaryWashes,
		(*81*)preResolvedMagneticBeadSeparationSecondaryWashSolutions,
		(*82*)preResolvedMagneticBeadSeparationSecondaryWashSolutionVolumes,
		(*83*)preResolvedMagneticBeadSeparationSecondaryWashMixes,
		(*84*)preResolvedMagneticBeadSeparationSecondaryWashMixTypes,
		(*85*)preResolvedMagneticBeadSeparationSecondaryWashMixTimes,
		(*86*)preResolvedMagneticBeadSeparationSecondaryWashMixRates,
		(*87*)preResolvedNumbersOfMagneticBeadSeparationSecondaryWashMixes,
		(*88*)preResolvedMagneticBeadSeparationSecondaryWashMixVolumes,
		(*89*)preResolvedMagneticBeadSeparationSecondaryWashMixTemperatures,
		(*90*)preResolvedMagneticBeadSeparationSecondaryWashMixTipTypes,
		(*91*)preResolvedMagneticBeadSeparationSecondaryWashMixTipMaterials,
		(*92*)preResolvedSecondaryWashMagnetizationTimes,
		(*93*)preResolvedMagneticBeadSeparationSecondaryWashAspirationVolumes,
		(*94*)preResolvedMagneticBeadSeparationSecondaryWashCollectionContainers,
		(*95*)preResolvedMagneticBeadSeparationSecondaryWashCollectionStorageConditions,
		(*96*)preResolvedMagneticBeadSeparationSecondaryWashAirDries,
		(*97*)preResolvedMagneticBeadSeparationSecondaryWashAirDryTimes,
		(*98*)preResolvedNumbersOfMagneticBeadSeparationSecondaryWashes,

		(*99*)preResolvedMagneticBeadSeparationTertiaryWashes,
		(*100*)preResolvedMagneticBeadSeparationTertiaryWashSolutions,
		(*101*)preResolvedMagneticBeadSeparationTertiaryWashSolutionVolumes,
		(*102*)preResolvedMagneticBeadSeparationTertiaryWashMixes,
		(*103*)preResolvedMagneticBeadSeparationTertiaryWashMixTypes,
		(*104*)preResolvedMagneticBeadSeparationTertiaryWashMixTimes,
		(*105*)preResolvedMagneticBeadSeparationTertiaryWashMixRates,
		(*106*)preResolvedNumbersOfMagneticBeadSeparationTertiaryWashMixes,
		(*107*)preResolvedMagneticBeadSeparationTertiaryWashMixVolumes,
		(*108*)preResolvedMagneticBeadSeparationTertiaryWashMixTemperatures,
		(*109*)preResolvedMagneticBeadSeparationTertiaryWashMixTipTypes,
		(*110*)preResolvedMagneticBeadSeparationTertiaryWashMixTipMaterials,
		(*111*)preResolvedTertiaryWashMagnetizationTimes,
		(*112*)preResolvedMagneticBeadSeparationTertiaryWashAspirationVolumes,
		(*113*)preResolvedMagneticBeadSeparationTertiaryWashCollectionContainers,
		(*114*)preResolvedMagneticBeadSeparationTertiaryWashCollectionStorageConditions,
		(*115*)preResolvedMagneticBeadSeparationTertiaryWashAirDries,
		(*116*)preResolvedMagneticBeadSeparationTertiaryWashAirDryTimes,
		(*117*)preResolvedNumbersOfMagneticBeadSeparationTertiaryWashes,


		(*118*)preResolvedMagneticBeadSeparationQuaternaryWashes,
		(*119*)preResolvedMagneticBeadSeparationQuaternaryWashSolutions,
		(*120*)preResolvedMagneticBeadSeparationQuaternaryWashSolutionVolumes,
		(*121*)preResolvedMagneticBeadSeparationQuaternaryWashMixes,
		(*122*)preResolvedMagneticBeadSeparationQuaternaryWashMixTypes,
		(*123*)preResolvedMagneticBeadSeparationQuaternaryWashMixTimes,
		(*124*)preResolvedMagneticBeadSeparationQuaternaryWashMixRates,
		(*125*)preResolvedNumbersOfMagneticBeadSeparationQuaternaryWashMixes,
		(*126*)preResolvedMagneticBeadSeparationQuaternaryWashMixVolumes,
		(*127*)preResolvedMagneticBeadSeparationQuaternaryWashMixTemperatures,
		(*128*)preResolvedMagneticBeadSeparationQuaternaryWashMixTipTypes,
		(*129*)preResolvedMagneticBeadSeparationQuaternaryWashMixTipMaterials,
		(*130*)preResolvedQuaternaryWashMagnetizationTimes,
		(*131*)preResolvedMagneticBeadSeparationQuaternaryWashAspirationVolumes,
		(*132*)preResolvedMagneticBeadSeparationQuaternaryWashCollectionContainers,
		(*133*)preResolvedMagneticBeadSeparationQuaternaryWashCollectionStorageConditions,
		(*134*)preResolvedMagneticBeadSeparationQuaternaryWashAirDries,
		(*135*)preResolvedMagneticBeadSeparationQuaternaryWashAirDryTimes,
		(*136*)preResolvedNumbersOfMagneticBeadSeparationQuaternaryWashes,

		(*137*)preResolvedMagneticBeadSeparationQuinaryWashes,
		(*138*)preResolvedMagneticBeadSeparationQuinaryWashSolutions,
		(*139*)preResolvedMagneticBeadSeparationQuinaryWashSolutionVolumes,
		(*140*)preResolvedMagneticBeadSeparationQuinaryWashMixes,
		(*141*)preResolvedMagneticBeadSeparationQuinaryWashMixTypes,
		(*142*)preResolvedMagneticBeadSeparationQuinaryWashMixTimes,
		(*143*)preResolvedMagneticBeadSeparationQuinaryWashMixRates,
		(*144*)preResolvedNumbersOfMagneticBeadSeparationQuinaryWashMixes,
		(*145*)preResolvedMagneticBeadSeparationQuinaryWashMixVolumes,
		(*146*)preResolvedMagneticBeadSeparationQuinaryWashMixTemperatures,
		(*147*)preResolvedMagneticBeadSeparationQuinaryWashMixTipTypes,
		(*148*)preResolvedMagneticBeadSeparationQuinaryWashMixTipMaterials,
		(*149*)preResolvedQuinaryWashMagnetizationTimes,
		(*150*)preResolvedMagneticBeadSeparationQuinaryWashAspirationVolumes,
		(*151*)preResolvedMagneticBeadSeparationQuinaryWashCollectionContainers,
		(*152*)preResolvedMagneticBeadSeparationQuinaryWashCollectionStorageConditions,
		(*153*)preResolvedMagneticBeadSeparationQuinaryWashAirDries,
		(*154*)preResolvedMagneticBeadSeparationQuinaryWashAirDryTimes,
		(*155*)preResolvedNumbersOfMagneticBeadSeparationQuinaryWashes,

		(*156*)preResolvedMagneticBeadSeparationSenaryWashes,
		(*157*)preResolvedMagneticBeadSeparationSenaryWashSolutions,
		(*158*)preResolvedMagneticBeadSeparationSenaryWashSolutionVolumes,
		(*159*)preResolvedMagneticBeadSeparationSenaryWashMixes,
		(*160*)preResolvedMagneticBeadSeparationSenaryWashMixTypes,
		(*161*)preResolvedMagneticBeadSeparationSenaryWashMixTimes,
		(*162*)preResolvedMagneticBeadSeparationSenaryWashMixRates,
		(*163*)preResolvedNumbersOfMagneticBeadSeparationSenaryWashMixes,
		(*164*)preResolvedMagneticBeadSeparationSenaryWashMixVolumes,
		(*165*)preResolvedMagneticBeadSeparationSenaryWashMixTemperatures,
		(*166*)preResolvedMagneticBeadSeparationSenaryWashMixTipTypes,
		(*167*)preResolvedMagneticBeadSeparationSenaryWashMixTipMaterials,
		(*168*)preResolvedSenaryWashMagnetizationTimes,
		(*169*)preResolvedMagneticBeadSeparationSenaryWashAspirationVolumes,
		(*170*)preResolvedMagneticBeadSeparationSenaryWashCollectionContainers,
		(*171*)preResolvedMagneticBeadSeparationSenaryWashCollectionStorageConditions,
		(*172*)preResolvedMagneticBeadSeparationSenaryWashAirDries,
		(*173*)preResolvedMagneticBeadSeparationSenaryWashAirDryTimes,
		(*174*)preResolvedNumbersOfMagneticBeadSeparationSenaryWashes,

		(*175*)preResolvedMagneticBeadSeparationSeptenaryWashes,
		(*176*)preResolvedMagneticBeadSeparationSeptenaryWashSolutions,
		(*177*)preResolvedMagneticBeadSeparationSeptenaryWashSolutionVolumes,
		(*178*)preResolvedMagneticBeadSeparationSeptenaryWashMixes,
		(*179*)preResolvedMagneticBeadSeparationSeptenaryWashMixTypes,
		(*180*)preResolvedMagneticBeadSeparationSeptenaryWashMixTimes,
		(*181*)preResolvedMagneticBeadSeparationSeptenaryWashMixRates,
		(*182*)preResolvedNumbersOfMagneticBeadSeparationSeptenaryWashMixes,
		(*183*)preResolvedMagneticBeadSeparationSeptenaryWashMixVolumes,
		(*184*)preResolvedMagneticBeadSeparationSeptenaryWashMixTemperatures,
		(*185*)preResolvedMagneticBeadSeparationSeptenaryWashMixTipTypes,
		(*186*)preResolvedMagneticBeadSeparationSeptenaryWashMixTipMaterials,
		(*187*)preResolvedSeptenaryWashMagnetizationTimes,
		(*188*)preResolvedMagneticBeadSeparationSeptenaryWashAspirationVolumes,
		(*189*)preResolvedMagneticBeadSeparationSeptenaryWashCollectionContainers,
		(*190*)preResolvedMagneticBeadSeparationSeptenaryWashCollectionStorageConditions,
		(*191*)preResolvedMagneticBeadSeparationSeptenaryWashAirDries,
		(*192*)preResolvedMagneticBeadSeparationSeptenaryWashAirDryTimes,
		(*193*)preResolvedNumbersOfMagneticBeadSeparationSeptenaryWashes,

		(*194*)preResolvedMagneticBeadSeparationElutions,
		(*195*)preResolvedMagneticBeadSeparationElutionSolutions,
		(*196*)preResolvedMagneticBeadSeparationElutionSolutionVolumes,
		(*197*)preResolvedMagneticBeadSeparationElutionMixes,
		(*198*)preResolvedMagneticBeadSeparationElutionMixTypes,
		(*199*)preResolvedMagneticBeadSeparationElutionMixTimes,
		(*200*)preResolvedMagneticBeadSeparationElutionMixRates,
		(*201*)preResolvedNumbersOfMagneticBeadSeparationElutionMixes,
		(*202*)preResolvedMagneticBeadSeparationElutionMixVolumes,
		(*203*)preResolvedMagneticBeadSeparationElutionMixTemperatures,
		(*204*)preResolvedMagneticBeadSeparationElutionMixTipTypes,
		(*205*)preResolvedMagneticBeadSeparationElutionMixTipMaterials,
		(*206*)preResolvedElutionMagnetizationTimes,
		(*207*)preResolvedMagneticBeadSeparationElutionAspirationVolumes,
		(*208*)preResolvedMagneticBeadSeparationElutionCollectionContainers,
		(*209*)preResolvedMagneticBeadSeparationElutionCollectionStorageConditions,
		(*210*)preResolvedNumbersOfMagneticBeadSeparationElutions,

		(*211*)preResolvedMagneticBeadSeparationPreWashCollectionContainerLabels,
		(*212*)preResolvedMagneticBeadSeparationEquilibrationCollectionContainerLabels,
		(*213*)preResolvedMagneticBeadSeparationLoadingCollectionContainerLabels,
		(*214*)preResolvedMagneticBeadSeparationWashCollectionContainerLabels,
		(*215*)preResolvedMagneticBeadSeparationSecondaryWashCollectionContainerLabels,
		(*216*)preResolvedMagneticBeadSeparationTertiaryWashCollectionContainerLabels,
		(*217*)preResolvedMagneticBeadSeparationQuaternaryWashCollectionContainerLabels,
		(*218*)preResolvedMagneticBeadSeparationQuinaryWashCollectionContainerLabels,
		(*219*)preResolvedMagneticBeadSeparationSenaryWashCollectionContainerLabels,
		(*220*)preResolvedMagneticBeadSeparationSeptenaryWashCollectionContainerLabels,
		(*221*)preResolvedMagneticBeadSeparationElutionCollectionContainerLabels
	}=Transpose@MapThread[
		Function[{sample,options, methodPacket, myTarget},
			Module[
				{
					methodSpecifiedQ, mbsUsedQ,defaultWashSolution,defaultElutionSolution,
					magneticBeadSeparationSelectionStrategy,magneticBeadSeparationMode,magneticBeadSeparationSampleVolume,magneticBeadSeparationAnalyteAffinityLabel,magneticBeadAffinityLabel,magneticBead,magneticBeadVolume,magneticBeadCollectionStorageCondition,magnetizationRack, magneticBeadSeparationPreWash,magneticBeadSeparationPreWashSolution,magneticBeadSeparationPreWashSolutionVolume,magneticBeadSeparationPreWashMix,magneticBeadSeparationPreWashMixType,magneticBeadSeparationPreWashMixTime,magneticBeadSeparationPreWashMixRate,numberOfMagneticBeadSeparationPreWashMixes,magneticBeadSeparationPreWashMixVolume,magneticBeadSeparationPreWashMixTemperature,magneticBeadSeparationPreWashMixTipType,magneticBeadSeparationPreWashMixTipMaterial,preWashMagnetizationTime,magneticBeadSeparationPreWashAspirationVolume,	magneticBeadSeparationPreWashCollectionContainer,magneticBeadSeparationPreWashCollectionStorageCondition,magneticBeadSeparationPreWashAirDry,magneticBeadSeparationPreWashAirDryTime,numberOfMagneticBeadSeparationPreWashes, magneticBeadSeparationEquilibration,magneticBeadSeparationEquilibrationSolution,magneticBeadSeparationEquilibrationSolutionVolume,magneticBeadSeparationEquilibrationMix,magneticBeadSeparationEquilibrationMixType,magneticBeadSeparationEquilibrationMixTime,magneticBeadSeparationEquilibrationMixRate,numberOfMagneticBeadSeparationEquilibrationMixes,magneticBeadSeparationEquilibrationMixVolume,magneticBeadSeparationEquilibrationMixTemperature,magneticBeadSeparationEquilibrationMixTipType,magneticBeadSeparationEquilibrationMixTipMaterial,equilibrationMagnetizationTime,magneticBeadSeparationEquilibrationAspirationVolume,	magneticBeadSeparationEquilibrationCollectionContainer,magneticBeadSeparationEquilibrationCollectionStorageCondition,magneticBeadSeparationEquilibrationAirDry,magneticBeadSeparationEquilibrationAirDryTime, magneticBeadSeparationLoadingMix,magneticBeadSeparationLoadingMixType,magneticBeadSeparationLoadingMixTime,magneticBeadSeparationLoadingMixRate,numberOfMagneticBeadSeparationLoadingMixes,magneticBeadSeparationLoadingMixVolume,magneticBeadSeparationLoadingMixTemperature,magneticBeadSeparationLoadingMixTipType,magneticBeadSeparationLoadingMixTipMaterial,loadingMagnetizationTime,magneticBeadSeparationLoadingAspirationVolume,	magneticBeadSeparationLoadingCollectionContainer,magneticBeadSeparationLoadingCollectionStorageCondition,magneticBeadSeparationLoadingAirDry,magneticBeadSeparationLoadingAirDryTime,magneticBeadSeparationWash,magneticBeadSeparationWashSolution,magneticBeadSeparationWashSolutionVolume,magneticBeadSeparationWashMix,magneticBeadSeparationWashMixType,magneticBeadSeparationWashMixTime,magneticBeadSeparationWashMixRate,numberOfMagneticBeadSeparationWashMixes,magneticBeadSeparationWashMixVolume,magneticBeadSeparationWashMixTemperature,magneticBeadSeparationWashMixTipType,magneticBeadSeparationWashMixTipMaterial,washMagnetizationTime,magneticBeadSeparationWashAspirationVolume,magneticBeadSeparationWashCollectionContainer,magneticBeadSeparationWashCollectionStorageCondition,magneticBeadSeparationWashAirDry,magneticBeadSeparationWashAirDryTime,numberOfMagneticBeadSeparationWashes,magneticBeadSeparationSecondaryWash,magneticBeadSeparationSecondaryWashSolution,magneticBeadSeparationSecondaryWashSolutionVolume,magneticBeadSeparationSecondaryWashMix,magneticBeadSeparationSecondaryWashMixType,magneticBeadSeparationSecondaryWashMixTime,magneticBeadSeparationSecondaryWashMixRate,numberOfMagneticBeadSeparationSecondaryWashMixes,magneticBeadSeparationSecondaryWashMixVolume,magneticBeadSeparationSecondaryWashMixTemperature,magneticBeadSeparationSecondaryWashMixTipType,magneticBeadSeparationSecondaryWashMixTipMaterial,secondaryWashMagnetizationTime,magneticBeadSeparationSecondaryWashAspirationVolume,	magneticBeadSeparationSecondaryWashCollectionContainer,magneticBeadSeparationSecondaryWashCollectionStorageCondition,magneticBeadSeparationSecondaryWashAirDry,magneticBeadSeparationSecondaryWashAirDryTime,numberOfMagneticBeadSeparationSecondaryWashes,magneticBeadSeparationTertiaryWash,magneticBeadSeparationTertiaryWashSolution,magneticBeadSeparationTertiaryWashSolutionVolume,magneticBeadSeparationTertiaryWashMix,magneticBeadSeparationTertiaryWashMixType,magneticBeadSeparationTertiaryWashMixTime,magneticBeadSeparationTertiaryWashMixRate,numberOfMagneticBeadSeparationTertiaryWashMixes,magneticBeadSeparationTertiaryWashMixVolume,magneticBeadSeparationTertiaryWashMixTemperature,magneticBeadSeparationTertiaryWashMixTipType,magneticBeadSeparationTertiaryWashMixTipMaterial,tertiaryWashMagnetizationTime,magneticBeadSeparationTertiaryWashAspirationVolume,	magneticBeadSeparationTertiaryWashCollectionContainer,magneticBeadSeparationTertiaryWashCollectionStorageCondition,magneticBeadSeparationTertiaryWashAirDry,magneticBeadSeparationTertiaryWashAirDryTime,numberOfMagneticBeadSeparationTertiaryWashes,magneticBeadSeparationQuaternaryWash,magneticBeadSeparationQuaternaryWashSolution,magneticBeadSeparationQuaternaryWashSolutionVolume,magneticBeadSeparationQuaternaryWashMix,magneticBeadSeparationQuaternaryWashMixType,magneticBeadSeparationQuaternaryWashMixTime,magneticBeadSeparationQuaternaryWashMixRate,numberOfMagneticBeadSeparationQuaternaryWashMixes,magneticBeadSeparationQuaternaryWashMixVolume,magneticBeadSeparationQuaternaryWashMixTemperature,magneticBeadSeparationQuaternaryWashMixTipType,magneticBeadSeparationQuaternaryWashMixTipMaterial,quaternaryWashMagnetizationTime,magneticBeadSeparationQuaternaryWashAspirationVolume,	magneticBeadSeparationQuaternaryWashCollectionContainer,magneticBeadSeparationQuaternaryWashCollectionStorageCondition,magneticBeadSeparationQuaternaryWashAirDry,magneticBeadSeparationQuaternaryWashAirDryTime,numberOfMagneticBeadSeparationQuaternaryWashes,magneticBeadSeparationQuinaryWash,magneticBeadSeparationQuinaryWashSolution,magneticBeadSeparationQuinaryWashSolutionVolume,magneticBeadSeparationQuinaryWashMix,magneticBeadSeparationQuinaryWashMixType,magneticBeadSeparationQuinaryWashMixTime,magneticBeadSeparationQuinaryWashMixRate,numberOfMagneticBeadSeparationQuinaryWashMixes,magneticBeadSeparationQuinaryWashMixVolume,magneticBeadSeparationQuinaryWashMixTemperature,magneticBeadSeparationQuinaryWashMixTipType,magneticBeadSeparationQuinaryWashMixTipMaterial,quinaryWashMagnetizationTime,magneticBeadSeparationQuinaryWashAspirationVolume,	magneticBeadSeparationQuinaryWashCollectionContainer,magneticBeadSeparationQuinaryWashCollectionStorageCondition,magneticBeadSeparationQuinaryWashAirDry,magneticBeadSeparationQuinaryWashAirDryTime,numberOfMagneticBeadSeparationQuinaryWashes,magneticBeadSeparationSenaryWash,magneticBeadSeparationSenaryWashSolution,magneticBeadSeparationSenaryWashSolutionVolume,magneticBeadSeparationSenaryWashMix,magneticBeadSeparationSenaryWashMixType,magneticBeadSeparationSenaryWashMixTime,magneticBeadSeparationSenaryWashMixRate,numberOfMagneticBeadSeparationSenaryWashMixes,magneticBeadSeparationSenaryWashMixVolume,magneticBeadSeparationSenaryWashMixTemperature,magneticBeadSeparationSenaryWashMixTipType,magneticBeadSeparationSenaryWashMixTipMaterial,senaryWashMagnetizationTime,magneticBeadSeparationSenaryWashAspirationVolume,	magneticBeadSeparationSenaryWashCollectionContainer,magneticBeadSeparationSenaryWashCollectionStorageCondition,magneticBeadSeparationSenaryWashAirDry,magneticBeadSeparationSenaryWashAirDryTime,numberOfMagneticBeadSeparationSenaryWashes,magneticBeadSeparationSeptenaryWash,magneticBeadSeparationSeptenaryWashSolution,magneticBeadSeparationSeptenaryWashSolutionVolume,magneticBeadSeparationSeptenaryWashMix,magneticBeadSeparationSeptenaryWashMixType,magneticBeadSeparationSeptenaryWashMixTime,magneticBeadSeparationSeptenaryWashMixRate,numberOfMagneticBeadSeparationSeptenaryWashMixes,magneticBeadSeparationSeptenaryWashMixVolume,magneticBeadSeparationSeptenaryWashMixTemperature,magneticBeadSeparationSeptenaryWashMixTipType,magneticBeadSeparationSeptenaryWashMixTipMaterial,septenaryWashMagnetizationTime,magneticBeadSeparationSeptenaryWashAspirationVolume,	magneticBeadSeparationSeptenaryWashCollectionContainer,magneticBeadSeparationSeptenaryWashCollectionStorageCondition,magneticBeadSeparationSeptenaryWashAirDry,magneticBeadSeparationSeptenaryWashAirDryTime,numberOfMagneticBeadSeparationSeptenaryWashes,magneticBeadSeparationElution,magneticBeadSeparationElutionSolution,magneticBeadSeparationElutionSolutionVolume,magneticBeadSeparationElutionMix,magneticBeadSeparationElutionMixType,magneticBeadSeparationElutionMixTime,magneticBeadSeparationElutionMixRate,numberOfMagneticBeadSeparationElutionMixes,magneticBeadSeparationElutionMixVolume,magneticBeadSeparationElutionMixTemperature,magneticBeadSeparationElutionMixTipType,magneticBeadSeparationElutionMixTipMaterial,elutionMagnetizationTime,magneticBeadSeparationElutionAspirationVolume,	magneticBeadSeparationElutionCollectionContainer,magneticBeadSeparationElutionCollectionStorageCondition,numberOfMagneticBeadSeparationElutions,

					magneticBeadSeparationPreWashCollectionContainerLabel,magneticBeadSeparationEquilibrationCollectionContainerLabel,magneticBeadSeparationLoadingCollectionContainerLabel,magneticBeadSeparationWashCollectionContainerLabel,magneticBeadSeparationSecondaryWashCollectionContainerLabel,magneticBeadSeparationTertiaryWashCollectionContainerLabel,magneticBeadSeparationQuaternaryWashCollectionContainerLabel,magneticBeadSeparationQuinaryWashCollectionContainerLabel,magneticBeadSeparationSenaryWashCollectionContainerLabel,magneticBeadSeparationSeptenaryWashCollectionContainerLabel,magneticBeadSeparationElutionCollectionContainerLabel
				},

				(* Determine if MBS is used for this sample. *)
				mbsUsedQ = MemberQ[ToList[Lookup[options, Purification]], MagneticBeadSeparation];

				(* Setup a boolean to determine if there is a method set or not. *)
				methodSpecifiedQ = MatchQ[Lookup[options,Method], ObjectP[Object[Method]]];

				(* --- PRERESOLVE GENERAL OPTIONS --- *)

				(*Set the magneticBeadSeparationSelectionStrategy*)
				magneticBeadSeparationSelectionStrategy = resolvedMagneticBeadSeparationSelectionStrategy;

				(*Set the magneticBeadSeparationMode*)
				magneticBeadSeparationMode = resolvedMagneticBeadSeparationMode;

				(*Pre-resolve magneticBeadSeparationSampleVolume. We need it fully resolved here because we need to use the info to pre-resolve elution collection container*)
				magneticBeadSeparationSampleVolume = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, MagneticBeadSeparationSampleVolume], Except[Automatic]],
						Lookup[options, MagneticBeadSeparationSampleVolume],
					(*If MBS is not used and the option is not specified, it is set to Null.*)
					!mbsUsedQ,
						Null,
					(*If MagneticBeadSeparation is not specified set to Automatic*)
					True,
						Min[Lookup[fetchPacketFromCache[sample,samplePackets],Volume],1. Milliliter]
				];


				(*Pre-resolve magneticBead*)
				magneticBead = Which[
					(*If specified by the user, set magneticBead to user-specified value*)
					MatchQ[Lookup[options, MagneticBeads], Except[Automatic]],
						Lookup[options, MagneticBeads],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, MagneticBeads, Null], Except[Null]],
						Lookup[methodPacket, MagneticBeads],
					(*If MBS is not used and the option is not specified, it is set to Null.*)
					!mbsUsedQ,
						Null,
					(*If MagneticBeadSeparation is performed, pre resolve based on myTarget and magneticBeadSeparationMode*)
					True,
						Which[
							(*If myTarget is RNA or plasmid DNA, and the separation mode is specified or resolved to normal phase*)
							MatchQ[myTarget,Alternatives[RNA, PlasmidDNA]]&&MatchQ[magneticBeadSeparationMode,NormalPhase],
								Model[Sample, "id:eGakldaOxXje"], (* Model[Sample, \"MagBinding Beads\"] *)
							(*If myTarget is DNA or RNA, and magneticBeadSeparationMode is not Affinity, set to Dynabeads MyOne SILANE*)
							MatchQ[myTarget,GenomicDNA]&&MatchQ[magneticBeadSeparationMode,NormalPhase],
								Model[Sample, "id:mnk9jOR1aaJb"],(*"Dynabeads MyOne SILANE Sample"*)
							MatchQ[myTarget,mRNA]&&MatchQ[magneticBeadSeparationMode,Affinity],
								Model[Sample, "id:mnk9jOR1aaJb"],(*"Dynabeads MyOne SILANE Sample"*)
							(*If myTarget is Protein, and magneticBeadSeparationMode is ReversePhase, set to MagSi-proteomics C4*)
							MatchQ[myTarget,Alternatives[CytosolicProtein,PlasmaMembraneProtein,NuclearProtein,TotalProtein]]&&MatchQ[magneticBeadSeparationMode,ReversePhase],
								Model[Sample, "id:Z1lqpMl8Z8KW"],(*"MagSi-proteomics C4 sample"*)
							(*If myTarget is Protein, and magneticBeadSeparationMode is IonExchange, set to MagSi-WCX*)
							MatchQ[myTarget,Alternatives[CytosolicProtein,PlasmaMembraneProtein,NuclearProtein,TotalProtein]]&&MatchQ[magneticBeadSeparationMode,IonExchange],
								Model[Sample, "id:eGaklda6A6Vq"],(*"MagSi-WCX sample"*)
							(*In other cases, it's either that we don't have a recommendation based on the target and separation mode, or myTarget is a Model[Molecule], MagneticBeads is set to Automatic for ExperimentMBS to resolve or throw an error*)
							True,
								Automatic
						]
				];

				(*Pre-resolve magneticBeadCollectionStorageCondition*)
				magneticBeadCollectionStorageCondition = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, MagneticBeadCollectionStorageCondition], Except[Automatic]],
						Lookup[options, MagneticBeadCollectionStorageCondition],
					(*If MBS is not used and the option is not specified, it is set to Null.*)
					!mbsUsedQ,
						Null,
					(*If MagneticBeadSeparation is not performed set to Automatic*)
					True,
						Disposal
				];

				(* --- PRERESOLVE PREWASH AND EQUILIBRATION OPTIONS --- *)

				(* Pre-resolve magneticBeadSeparationPreWashSolutionVolume *)
				(* also tons of other options, all of which do not rely on methods *)
				{
					(*1*)magneticBeadVolume,
					(*2*)magnetizationRack,
					(*3*)magneticBeadSeparationPreWashSolutionVolume,
					(*4*)magneticBeadSeparationPreWashMixVolume,
					(*5*)magneticBeadSeparationPreWashMixTipType,
					(*6*)magneticBeadSeparationPreWashMixTipMaterial,
					(*7*)magneticBeadSeparationEquilibrationSolutionVolume,
					(*8*)magneticBeadSeparationEquilibrationMixVolume,
					(*9*)magneticBeadSeparationEquilibrationMixTipType,
					(*10*)magneticBeadSeparationEquilibrationMixTipMaterial,
					(*11*)magneticBeadSeparationLoadingMixVolume,
					(*12*)magneticBeadSeparationLoadingMixTipType,
					(*13*)magneticBeadSeparationLoadingMixTipMaterial,
					(*14*)magneticBeadSeparationWashSolutionVolume,
					(*15*)magneticBeadSeparationWashMixVolume,
					(*16*)magneticBeadSeparationWashMixTipType,
					(*17*)magneticBeadSeparationWashMixTipMaterial,
					(*18*)magneticBeadSeparationSecondaryWashSolutionVolume,
					(*19*)magneticBeadSeparationSecondaryWashMixVolume,
					(*20*)magneticBeadSeparationSecondaryWashMixTipType,
					(*21*)magneticBeadSeparationSecondaryWashMixTipMaterial,
					(*22*)magneticBeadSeparationTertiaryWashSolutionVolume,
					(*23*)magneticBeadSeparationTertiaryWashMixVolume,
					(*24*)magneticBeadSeparationTertiaryWashMixTipType,
					(*25*)magneticBeadSeparationTertiaryWashMixTipMaterial,
					(*26*)magneticBeadSeparationQuaternaryWashSolutionVolume,
					(*27*)magneticBeadSeparationQuaternaryWashMixVolume,
					(*28*)magneticBeadSeparationQuaternaryWashMixTipType,
					(*29*)magneticBeadSeparationQuaternaryWashMixTipMaterial,
					(*30*)magneticBeadSeparationQuinaryWashSolutionVolume,
					(*31*)magneticBeadSeparationQuinaryWashMixVolume,
					(*32*)magneticBeadSeparationQuinaryWashMixTipType,
					(*33*)magneticBeadSeparationQuinaryWashMixTipMaterial,
					(*34*)magneticBeadSeparationSenaryWashSolutionVolume,
					(*35*)magneticBeadSeparationSenaryWashMixVolume,
					(*36*)magneticBeadSeparationSenaryWashMixTipType,
					(*37*)magneticBeadSeparationSenaryWashMixTipMaterial,
					(*38*)magneticBeadSeparationSeptenaryWashSolutionVolume,
					(*39*)magneticBeadSeparationSeptenaryWashMixVolume,
					(*40*)magneticBeadSeparationSeptenaryWashMixTipType,
					(*41*)magneticBeadSeparationSeptenaryWashMixTipMaterial,
					(*42*)magneticBeadSeparationElutionMixVolume,
					(*43*)magneticBeadSeparationElutionMixTipType,
					(*44*)magneticBeadSeparationElutionMixTipMaterial,
					(*45*)magneticBeadSeparationPreWashCollectionContainerLabel,
					(*46*)magneticBeadSeparationEquilibrationCollectionContainerLabel,
					(*47*)magneticBeadSeparationLoadingCollectionContainerLabel,
					(*48*)magneticBeadSeparationWashCollectionContainerLabel,
					(*49*)magneticBeadSeparationSecondaryWashCollectionContainerLabel,
					(*50*)magneticBeadSeparationTertiaryWashCollectionContainerLabel,
					(*51*)magneticBeadSeparationQuaternaryWashCollectionContainerLabel,
					(*52*)magneticBeadSeparationQuinaryWashCollectionContainerLabel,
					(*53*)magneticBeadSeparationSenaryWashCollectionContainerLabel,
					(*54*)magneticBeadSeparationSeptenaryWashCollectionContainerLabel,
					(*55*)magneticBeadSeparationElutionCollectionContainerLabel
				} = Map[
					simplePreResolveOptionNoMethod[#, options, mbsUsedQ]&,
					{
						(*1*)MagneticBeadVolume,
						(*2*)MagnetizationRack,
						(*3*)MagneticBeadSeparationPreWashSolutionVolume,
						(*4*)MagneticBeadSeparationPreWashMixVolume,
						(*5*)MagneticBeadSeparationPreWashMixTipType,
						(*6*)MagneticBeadSeparationPreWashMixTipMaterial,
						(*7*)MagneticBeadSeparationEquilibrationSolutionVolume,
						(*8*)MagneticBeadSeparationEquilibrationMixVolume,
						(*9*)MagneticBeadSeparationEquilibrationMixTipType,
						(*10*)MagneticBeadSeparationEquilibrationMixTipMaterial,
						(*11*)MagneticBeadSeparationLoadingMixVolume,
						(*12*)MagneticBeadSeparationLoadingMixTipType,
						(*13*)MagneticBeadSeparationLoadingMixTipMaterial,
						(*14*)MagneticBeadSeparationWashSolutionVolume,
						(*15*)MagneticBeadSeparationWashMixVolume,
						(*16*)MagneticBeadSeparationWashMixTipType,
						(*17*)MagneticBeadSeparationWashMixTipMaterial,
						(*18*)MagneticBeadSeparationSecondaryWashSolutionVolume,
						(*19*)MagneticBeadSeparationSecondaryWashMixVolume,
						(*20*)MagneticBeadSeparationSecondaryWashMixTipType,
						(*21*)MagneticBeadSeparationSecondaryWashMixTipMaterial,
						(*22*)MagneticBeadSeparationTertiaryWashSolutionVolume,
						(*23*)MagneticBeadSeparationTertiaryWashMixVolume,
						(*24*)MagneticBeadSeparationTertiaryWashMixTipType,
						(*25*)MagneticBeadSeparationTertiaryWashMixTipMaterial,
						(*26*)MagneticBeadSeparationQuaternaryWashSolutionVolume,
						(*27*)MagneticBeadSeparationQuaternaryWashMixVolume,
						(*28*)MagneticBeadSeparationQuaternaryWashMixTipType,
						(*29*)MagneticBeadSeparationQuaternaryWashMixTipMaterial,
						(*30*)MagneticBeadSeparationQuinaryWashSolutionVolume,
						(*31*)MagneticBeadSeparationQuinaryWashMixVolume,
						(*32*)MagneticBeadSeparationQuinaryWashMixTipType,
						(*33*)MagneticBeadSeparationQuinaryWashMixTipMaterial,
						(*34*)MagneticBeadSeparationSenaryWashSolutionVolume,
						(*35*)MagneticBeadSeparationSenaryWashMixVolume,
						(*36*)MagneticBeadSeparationSenaryWashMixTipType,
						(*37*)MagneticBeadSeparationSenaryWashMixTipMaterial,
						(*38*)MagneticBeadSeparationSeptenaryWashSolutionVolume,
						(*39*)MagneticBeadSeparationSeptenaryWashMixVolume,
						(*40*)MagneticBeadSeparationSeptenaryWashMixTipType,
						(*41*)MagneticBeadSeparationSeptenaryWashMixTipMaterial,
						(*42*)MagneticBeadSeparationElutionMixVolume,
						(*43*)MagneticBeadSeparationElutionMixTipType,
						(*44*)MagneticBeadSeparationElutionMixTipMaterial,
						(*45*)MagneticBeadSeparationPreWashCollectionContainerLabel,
						(*46*)MagneticBeadSeparationEquilibrationCollectionContainerLabel,
						(*47*)MagneticBeadSeparationLoadingCollectionContainerLabel,
						(*48*)MagneticBeadSeparationWashCollectionContainerLabel,
						(*49*)MagneticBeadSeparationSecondaryWashCollectionContainerLabel,
						(*50*)MagneticBeadSeparationTertiaryWashCollectionContainerLabel,
						(*51*)MagneticBeadSeparationQuaternaryWashCollectionContainerLabel,
						(*52*)MagneticBeadSeparationQuinaryWashCollectionContainerLabel,
						(*53*)MagneticBeadSeparationSenaryWashCollectionContainerLabel,
						(*54*)MagneticBeadSeparationSeptenaryWashCollectionContainerLabel,
						(*55*)MagneticBeadSeparationElutionCollectionContainerLabel
					}
				];

				(*Pre-resolve magneticBeadSeparationAnalyteAffinityLabel*)
				(* also tons of other options, all of which rely on the methods *)
				{
					(*1*)magneticBeadSeparationAnalyteAffinityLabel,
					(*2*)magneticBeadAffinityLabel,
					(*3*)magneticBeadSeparationPreWash,
					(*4*)magneticBeadSeparationPreWashSolution,
					(*5*)magneticBeadSeparationPreWashMix,
					(*6*)magneticBeadSeparationPreWashMixType,
					(*7*)magneticBeadSeparationPreWashMixTime,
					(*8*)magneticBeadSeparationPreWashMixRate,
					(*9*)numberOfMagneticBeadSeparationPreWashMixes,
					(*10*)magneticBeadSeparationPreWashMixTemperature,
					(*11*)preWashMagnetizationTime,
					(*12*)magneticBeadSeparationPreWashAspirationVolume,
					(*13*)magneticBeadSeparationPreWashCollectionContainer,
					(*14*)magneticBeadSeparationPreWashCollectionStorageCondition,
					(*15*)magneticBeadSeparationPreWashAirDry,
					(*16*)magneticBeadSeparationPreWashAirDryTime,
					(*17*)numberOfMagneticBeadSeparationPreWashes,
					(*18*)magneticBeadSeparationEquilibration,
					(*19*)magneticBeadSeparationEquilibrationSolution,
					(*20*)magneticBeadSeparationEquilibrationMix,
					(*21*)magneticBeadSeparationEquilibrationMixType,
					(*22*)magneticBeadSeparationEquilibrationMixTime,
					(*23*)magneticBeadSeparationEquilibrationMixRate,
					(*24*)numberOfMagneticBeadSeparationEquilibrationMixes,
					(*25*)magneticBeadSeparationEquilibrationMixTemperature,
					(*26*)equilibrationMagnetizationTime,
					(*27*)magneticBeadSeparationEquilibrationAspirationVolume,
					(*28*)magneticBeadSeparationEquilibrationCollectionContainer,
					(*29*)magneticBeadSeparationEquilibrationCollectionStorageCondition,
					(*30*)magneticBeadSeparationEquilibrationAirDry,
					(*31*)magneticBeadSeparationEquilibrationAirDryTime,
					(*32*)magneticBeadSeparationLoadingMix,
					(*33*)magneticBeadSeparationLoadingMixType,
					(*34*)magneticBeadSeparationLoadingMixTime,
					(*35*)magneticBeadSeparationLoadingMixRate,
					(*36*)numberOfMagneticBeadSeparationLoadingMixes,
					(*37*)magneticBeadSeparationLoadingMixTemperature,
					(*38*)loadingMagnetizationTime,
					(*39*)magneticBeadSeparationLoadingAspirationVolume,
					(*40*)magneticBeadSeparationLoadingCollectionStorageCondition,
					(*41*)magneticBeadSeparationLoadingAirDry,
					(*42*)magneticBeadSeparationLoadingAirDryTime,
					(*43*)magneticBeadSeparationWashMix,
					(*44*)magneticBeadSeparationWashMixType,
					(*45*)magneticBeadSeparationWashMixTime,
					(*46*)magneticBeadSeparationWashMixRate,
					(*47*)numberOfMagneticBeadSeparationWashMixes,
					(*48*)magneticBeadSeparationWashMixTemperature,
					(*49*)washMagnetizationTime,
					(*50*)magneticBeadSeparationWashAspirationVolume,
					(*51*)magneticBeadSeparationWashCollectionContainer,
					(*52*)magneticBeadSeparationWashCollectionStorageCondition,
					(*53*)magneticBeadSeparationWashAirDry,
					(*54*)magneticBeadSeparationWashAirDryTime,
					(*55*)numberOfMagneticBeadSeparationWashes,
					(*56*)magneticBeadSeparationSecondaryWashMix,
					(*57*)magneticBeadSeparationSecondaryWashMixType,
					(*58*)magneticBeadSeparationSecondaryWashMixTime,
					(*59*)magneticBeadSeparationSecondaryWashMixRate,
					(*60*)numberOfMagneticBeadSeparationSecondaryWashMixes,
					(*61*)magneticBeadSeparationSecondaryWashMixTemperature,
					(*62*)secondaryWashMagnetizationTime,
					(*63*)magneticBeadSeparationSecondaryWashAspirationVolume,
					(*64*)magneticBeadSeparationSecondaryWashCollectionContainer,
					(*65*)magneticBeadSeparationSecondaryWashCollectionStorageCondition,
					(*66*)magneticBeadSeparationSecondaryWashAirDry,
					(*67*)magneticBeadSeparationSecondaryWashAirDryTime,
					(*68*)numberOfMagneticBeadSeparationSecondaryWashes,
					(*69*)magneticBeadSeparationTertiaryWashMix,
					(*70*)magneticBeadSeparationTertiaryWashMixType,
					(*71*)magneticBeadSeparationTertiaryWashMixTime,
					(*72*)magneticBeadSeparationTertiaryWashMixRate,
					(*73*)numberOfMagneticBeadSeparationTertiaryWashMixes,
					(*74*)magneticBeadSeparationTertiaryWashMixTemperature,
					(*75*)tertiaryWashMagnetizationTime,
					(*76*)magneticBeadSeparationTertiaryWashAspirationVolume,
					(*77*)magneticBeadSeparationTertiaryWashCollectionContainer,
					(*78*)magneticBeadSeparationTertiaryWashCollectionStorageCondition,
					(*79*)magneticBeadSeparationTertiaryWashAirDry,
					(*80*)magneticBeadSeparationTertiaryWashAirDryTime,
					(*81*)numberOfMagneticBeadSeparationTertiaryWashes,
					(*82*)magneticBeadSeparationQuaternaryWashMix,
					(*83*)magneticBeadSeparationQuaternaryWashMixType,
					(*84*)magneticBeadSeparationQuaternaryWashMixTime,
					(*85*)magneticBeadSeparationQuaternaryWashMixRate,
					(*86*)numberOfMagneticBeadSeparationQuaternaryWashMixes,
					(*87*)magneticBeadSeparationQuaternaryWashMixTemperature,
					(*88*)quaternaryWashMagnetizationTime,
					(*89*)magneticBeadSeparationQuaternaryWashAspirationVolume,
					(*90*)magneticBeadSeparationQuaternaryWashCollectionContainer,
					(*91*)magneticBeadSeparationQuaternaryWashCollectionStorageCondition,
					(*92*)magneticBeadSeparationQuaternaryWashAirDry,
					(*93*)magneticBeadSeparationQuaternaryWashAirDryTime,
					(*94*)numberOfMagneticBeadSeparationQuaternaryWashes,
					(*95*)magneticBeadSeparationQuinaryWashMix,
					(*96*)magneticBeadSeparationQuinaryWashMixType,
					(*97*)magneticBeadSeparationQuinaryWashMixTime,
					(*98*)magneticBeadSeparationQuinaryWashMixRate,
					(*99*)numberOfMagneticBeadSeparationQuinaryWashMixes,
					(*100*)magneticBeadSeparationQuinaryWashMixTemperature,
					(*101*)quinaryWashMagnetizationTime,
					(*102*)magneticBeadSeparationQuinaryWashAspirationVolume,
					(*103*)magneticBeadSeparationQuinaryWashCollectionContainer,
					(*104*)magneticBeadSeparationQuinaryWashCollectionStorageCondition,
					(*105*)magneticBeadSeparationQuinaryWashAirDry,
					(*106*)magneticBeadSeparationQuinaryWashAirDryTime,
					(*107*)numberOfMagneticBeadSeparationQuinaryWashes,
					(*108*)magneticBeadSeparationSenaryWashMix,
					(*109*)magneticBeadSeparationSenaryWashMixType,
					(*110*)magneticBeadSeparationSenaryWashMixTime,
					(*111*)magneticBeadSeparationSenaryWashMixRate,
					(*112*)numberOfMagneticBeadSeparationSenaryWashMixes,
					(*113*)magneticBeadSeparationSenaryWashMixTemperature,
					(*114*)senaryWashMagnetizationTime,
					(*115*)magneticBeadSeparationSenaryWashAspirationVolume,
					(*116*)magneticBeadSeparationSenaryWashCollectionContainer,
					(*117*)magneticBeadSeparationSenaryWashCollectionStorageCondition,
					(*118*)magneticBeadSeparationSenaryWashAirDry,
					(*119*)magneticBeadSeparationSenaryWashAirDryTime,
					(*120*)numberOfMagneticBeadSeparationSenaryWashes,
					(*121*)magneticBeadSeparationSeptenaryWashMix,
					(*122*)magneticBeadSeparationSeptenaryWashMixType,
					(*123*)magneticBeadSeparationSeptenaryWashMixTime,
					(*124*)magneticBeadSeparationSeptenaryWashMixRate,
					(*125*)numberOfMagneticBeadSeparationSeptenaryWashMixes,
					(*126*)magneticBeadSeparationSeptenaryWashMixTemperature,
					(*127*)septenaryWashMagnetizationTime,
					(*128*)magneticBeadSeparationSeptenaryWashAspirationVolume,
					(*129*)magneticBeadSeparationSeptenaryWashCollectionContainer,
					(*130*)magneticBeadSeparationSeptenaryWashCollectionStorageCondition,
					(*131*)magneticBeadSeparationSeptenaryWashAirDry,
					(*132*)magneticBeadSeparationSeptenaryWashAirDryTime,
					(*133*)numberOfMagneticBeadSeparationSeptenaryWashes,
					(*134*)magneticBeadSeparationElutionMix,
					(*135*)magneticBeadSeparationElutionMixType,
					(*136*)magneticBeadSeparationElutionMixTime,
					(*137*)magneticBeadSeparationElutionMixRate,
					(*138*)numberOfMagneticBeadSeparationElutionMixes,
					(*139*)magneticBeadSeparationElutionMixTemperature,
					(*140*)elutionMagnetizationTime,
					(*141*)magneticBeadSeparationElutionCollectionStorageCondition
				} = Map[
					simplePreResolveOption[#, options, methodPacket, methodSpecifiedQ, mbsUsedQ]&,
					{
						(*1*)MagneticBeadSeparationAnalyteAffinityLabel,
						(*2*)MagneticBeadAffinityLabel,
						(*3*)MagneticBeadSeparationPreWash,
						(*4*)MagneticBeadSeparationPreWashSolution,
						(*5*)MagneticBeadSeparationPreWashMix,
						(*6*)MagneticBeadSeparationPreWashMixType,
						(*7*)MagneticBeadSeparationPreWashMixTime,
						(*8*)MagneticBeadSeparationPreWashMixRate,
						(*9*)NumberOfMagneticBeadSeparationPreWashMixes,
						(*10*)MagneticBeadSeparationPreWashMixTemperature,
						(*11*)PreWashMagnetizationTime,
						(*12*)MagneticBeadSeparationPreWashAspirationVolume,
						(*13*)MagneticBeadSeparationPreWashCollectionContainer,
						(*14*)MagneticBeadSeparationPreWashCollectionStorageCondition,
						(*15*)MagneticBeadSeparationPreWashAirDry,
						(*16*)MagneticBeadSeparationPreWashAirDryTime,
						(*17*)NumberOfMagneticBeadSeparationPreWashes,
						(*18*)MagneticBeadSeparationEquilibration,
						(*19*)MagneticBeadSeparationEquilibrationSolution,
						(*20*)MagneticBeadSeparationEquilibrationMix,
						(*21*)MagneticBeadSeparationEquilibrationMixType,
						(*22*)MagneticBeadSeparationEquilibrationMixTime,
						(*23*)MagneticBeadSeparationEquilibrationMixRate,
						(*24*)NumberOfMagneticBeadSeparationEquilibrationMixes,
						(*25*)MagneticBeadSeparationEquilibrationMixTemperature,
						(*26*)EquilibrationMagnetizationTime,
						(*27*)MagneticBeadSeparationEquilibrationAspirationVolume,
						(*28*)MagneticBeadSeparationEquilibrationCollectionContainer,
						(*29*)MagneticBeadSeparationEquilibrationCollectionStorageCondition,
						(*30*)MagneticBeadSeparationEquilibrationAirDry,
						(*31*)MagneticBeadSeparationEquilibrationAirDryTime,
						(*32*)MagneticBeadSeparationLoadingMix,
						(*33*)MagneticBeadSeparationLoadingMixType,
						(*34*)MagneticBeadSeparationLoadingMixTime,
						(*35*)MagneticBeadSeparationLoadingMixRate,
						(*36*)NumberOfMagneticBeadSeparationLoadingMixes,
						(*37*)MagneticBeadSeparationLoadingMixTemperature,
						(*38*)LoadingMagnetizationTime,
						(*39*)MagneticBeadSeparationLoadingAspirationVolume,
						(*40*)MagneticBeadSeparationLoadingCollectionStorageCondition,
						(*41*)MagneticBeadSeparationLoadingAirDry,
						(*42*)MagneticBeadSeparationLoadingAirDryTime,
						(*43*)MagneticBeadSeparationWashMix,
						(*44*)MagneticBeadSeparationWashMixType,
						(*45*)MagneticBeadSeparationWashMixTime,
						(*46*)MagneticBeadSeparationWashMixRate,
						(*47*)NumberOfMagneticBeadSeparationWashMixes,
						(*48*)MagneticBeadSeparationWashMixTemperature,
						(*49*)WashMagnetizationTime,
						(*50*)MagneticBeadSeparationWashAspirationVolume,
						(*51*)MagneticBeadSeparationWashCollectionContainer,
						(*52*)MagneticBeadSeparationWashCollectionStorageCondition,
						(*53*)MagneticBeadSeparationWashAirDry,
						(*54*)MagneticBeadSeparationWashAirDryTime,
						(*55*)NumberOfMagneticBeadSeparationWashes,
						(*56*)MagneticBeadSeparationSecondaryWashMix,
						(*57*)MagneticBeadSeparationSecondaryWashMixType,
						(*58*)MagneticBeadSeparationSecondaryWashMixTime,
						(*59*)MagneticBeadSeparationSecondaryWashMixRate,
						(*60*)NumberOfMagneticBeadSeparationSecondaryWashMixes,
						(*61*)MagneticBeadSeparationSecondaryWashMixTemperature,
						(*62*)SecondaryWashMagnetizationTime,
						(*63*)MagneticBeadSeparationSecondaryWashAspirationVolume,
						(*64*)MagneticBeadSeparationSecondaryWashCollectionContainer,
						(*65*)MagneticBeadSeparationSecondaryWashCollectionStorageCondition,
						(*66*)MagneticBeadSeparationSecondaryWashAirDry,
						(*67*)MagneticBeadSeparationSecondaryWashAirDryTime,
						(*68*)NumberOfMagneticBeadSeparationSecondaryWashes,
						(*69*)MagneticBeadSeparationTertiaryWashMix,
						(*70*)MagneticBeadSeparationTertiaryWashMixType,
						(*71*)MagneticBeadSeparationTertiaryWashMixTime,
						(*72*)MagneticBeadSeparationTertiaryWashMixRate,
						(*73*)NumberOfMagneticBeadSeparationTertiaryWashMixes,
						(*74*)MagneticBeadSeparationTertiaryWashMixTemperature,
						(*75*)TertiaryWashMagnetizationTime,
						(*76*)MagneticBeadSeparationTertiaryWashAspirationVolume,
						(*77*)MagneticBeadSeparationTertiaryWashCollectionContainer,
						(*78*)MagneticBeadSeparationTertiaryWashCollectionStorageCondition,
						(*79*)MagneticBeadSeparationTertiaryWashAirDry,
						(*80*)MagneticBeadSeparationTertiaryWashAirDryTime,
						(*81*)NumberOfMagneticBeadSeparationTertiaryWashes,
						(*82*)MagneticBeadSeparationQuaternaryWashMix,
						(*83*)MagneticBeadSeparationQuaternaryWashMixType,
						(*84*)MagneticBeadSeparationQuaternaryWashMixTime,
						(*85*)MagneticBeadSeparationQuaternaryWashMixRate,
						(*86*)NumberOfMagneticBeadSeparationQuaternaryWashMixes,
						(*87*)MagneticBeadSeparationQuaternaryWashMixTemperature,
						(*88*)QuaternaryWashMagnetizationTime,
						(*89*)MagneticBeadSeparationQuaternaryWashAspirationVolume,
						(*90*)MagneticBeadSeparationQuaternaryWashCollectionContainer,
						(*91*)MagneticBeadSeparationQuaternaryWashCollectionStorageCondition,
						(*92*)MagneticBeadSeparationQuaternaryWashAirDry,
						(*93*)MagneticBeadSeparationQuaternaryWashAirDryTime,
						(*94*)NumberOfMagneticBeadSeparationQuaternaryWashes,
						(*95*)MagneticBeadSeparationQuinaryWashMix,
						(*96*)MagneticBeadSeparationQuinaryWashMixType,
						(*97*)MagneticBeadSeparationQuinaryWashMixTime,
						(*98*)MagneticBeadSeparationQuinaryWashMixRate,
						(*99*)NumberOfMagneticBeadSeparationQuinaryWashMixes,
						(*100*)MagneticBeadSeparationQuinaryWashMixTemperature,
						(*101*)QuinaryWashMagnetizationTime,
						(*102*)MagneticBeadSeparationQuinaryWashAspirationVolume,
						(*103*)MagneticBeadSeparationQuinaryWashCollectionContainer,
						(*104*)MagneticBeadSeparationQuinaryWashCollectionStorageCondition,
						(*105*)MagneticBeadSeparationQuinaryWashAirDry,
						(*106*)MagneticBeadSeparationQuinaryWashAirDryTime,
						(*107*)NumberOfMagneticBeadSeparationQuinaryWashes,
						(*108*)MagneticBeadSeparationSenaryWashMix,
						(*109*)MagneticBeadSeparationSenaryWashMixType,
						(*110*)MagneticBeadSeparationSenaryWashMixTime,
						(*111*)MagneticBeadSeparationSenaryWashMixRate,
						(*112*)NumberOfMagneticBeadSeparationSenaryWashMixes,
						(*113*)MagneticBeadSeparationSenaryWashMixTemperature,
						(*114*)SenaryWashMagnetizationTime,
						(*115*)MagneticBeadSeparationSenaryWashAspirationVolume,
						(*116*)MagneticBeadSeparationSenaryWashCollectionContainer,
						(*117*)MagneticBeadSeparationSenaryWashCollectionStorageCondition,
						(*118*)MagneticBeadSeparationSenaryWashAirDry,
						(*119*)MagneticBeadSeparationSenaryWashAirDryTime,
						(*120*)NumberOfMagneticBeadSeparationSenaryWashes,
						(*121*)MagneticBeadSeparationSeptenaryWashMix,
						(*122*)MagneticBeadSeparationSeptenaryWashMixType,
						(*123*)MagneticBeadSeparationSeptenaryWashMixTime,
						(*124*)MagneticBeadSeparationSeptenaryWashMixRate,
						(*125*)NumberOfMagneticBeadSeparationSeptenaryWashMixes,
						(*126*)MagneticBeadSeparationSeptenaryWashMixTemperature,
						(*127*)SeptenaryWashMagnetizationTime,
						(*128*)MagneticBeadSeparationSeptenaryWashAspirationVolume,
						(*129*)MagneticBeadSeparationSeptenaryWashCollectionContainer,
						(*130*)MagneticBeadSeparationSeptenaryWashCollectionStorageCondition,
						(*131*)MagneticBeadSeparationSeptenaryWashAirDry,
						(*132*)MagneticBeadSeparationSeptenaryWashAirDryTime,
						(*133*)NumberOfMagneticBeadSeparationSeptenaryWashes,
						(*134*)MagneticBeadSeparationElutionMix,
						(*135*)MagneticBeadSeparationElutionMixType,
						(*136*)MagneticBeadSeparationElutionMixTime,
						(*137*)MagneticBeadSeparationElutionMixRate,
						(*138*)NumberOfMagneticBeadSeparationElutionMixes,
						(*139*)MagneticBeadSeparationElutionMixTemperature,
						(*140*)ElutionMagnetizationTime,
						(*141*)MagneticBeadSeparationElutionCollectionStorageCondition
					}
				];



				(*Pre resolve magneticBeadSeparationLoadingCollectionContainer*)
				magneticBeadSeparationLoadingCollectionContainer = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, MagneticBeadSeparationLoadingCollectionContainer], Except[Automatic]],
						Lookup[options, MagneticBeadSeparationLoadingCollectionContainer],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, MagneticBeadSeparationLoadingCollectionContainer, Null], Except[Null]],
						Lookup[methodPacket, MagneticBeadSeparationLoadingCollectionContainer],
					(*If MBS is not used and the option is not specified, it is set to Null.*)
					!mbsUsedQ,
						Null,
					(*If selection strategy is Negative, set to a model deep well sterile plate*)
					MatchQ[magneticBeadSeparationSelectionStrategy, Negative],
						Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
					True,
						Automatic
				];



				(* --- PRERESOLVE WASH OPTIONS --- *)
				(*resolve a default wash buffer for the given target*)
				defaultWashSolution = Switch[myTarget,
					PlasmidDNA, Model[Sample,"id:KBL5DvLdq1Zd"], (* Model[Sample,\"Zyppy Wash Buffer\"] *)
					GenomicDNA|RNA|CellularRNAP, Model[Sample, StockSolution, "id:BYDOjv1VA7Zr"], (* 70% Ethanol *)
					CytosolicProtein|PlasmaMembraneProtein|NuclearProtein|TotalProtein, Model[Sample, StockSolution, "id:4pO6dMWvnA0X"],(*Filtered PBS, Sterile*)
					_,Automatic
				];
				defaultElutionSolution = Switch[myTarget,
					PlasmidDNA, Model[Sample, "id:aXRlGnRDj930"], (* Model[Sample, \"Zyppy Elution Buffer\"] *)
					GenomicDNA|RNA|CellularRNAP, Model[Sample, "id:O81aEBZnWMRO"], (* Nuclease-free Water *)
					CytosolicProtein|PlasmaMembraneProtein|NuclearProtein|TotalProtein,Model[Sample, StockSolution, "50 mM Glycine pH 2.8, sterile filtered"],(*"50 mM Glycine pH 2.8, sterile filtered""id:eGakldadjlEe"*)
					_,Automatic
				];

				magneticBeadSeparationWash = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, MagneticBeadSeparationWash], Except[Automatic]],
						Lookup[options, MagneticBeadSeparationWash],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, MagneticBeadSeparationWash, Null], Except[Null]],
						Lookup[methodPacket, MagneticBeadSeparationWash],
					(*If MBS is not used and the option is not specified, it is set to Null.*)
					!mbsUsedQ,
						Null,
					(*If any of the wash options is specified by the user, set to True*)
					Or[
						MemberQ[Lookup[options, $MagneticBeadSeparationWashOptions], Except[Automatic | Null]],
						(*or if any of the wash options is specified by the method*)
						methodSpecifiedQ && MemberQ[Lookup[methodPacket, Intersection[Keys[methodPacket], $MagneticBeadSeparationWashOptions]], Except[Automatic | Null]]
					],
						True,
					(*Otherwise set to False, mirroring main MBS resolution*)
					True,
						False
				];

				(*Pre resolve magneticBeadSeparationWashSolution*)
				magneticBeadSeparationWashSolution = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, MagneticBeadSeparationWashSolution], Except[Automatic]],
						Lookup[options, MagneticBeadSeparationWashSolution],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, MagneticBeadSeparationWashSolution, Null], Except[Null]],
						Lookup[methodPacket, MagneticBeadSeparationWashSolution],
					(*If MBS is not used and the option is not specified, it is set to Null.*)
					!mbsUsedQ,
						Null,
					(*If the stage is on, use the default solution for the target*)
					magneticBeadSeparationWash,
						defaultWashSolution,
					True,
						Automatic
				];


				(* --- PRERESOLVE SECONDARYWASH OPTIONS --- *)

				magneticBeadSeparationSecondaryWash = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, MagneticBeadSeparationSecondaryWash], Except[Automatic]],
						Lookup[options, MagneticBeadSeparationSecondaryWash],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, MagneticBeadSeparationSecondaryWash, Null], Except[Null]],
						Lookup[methodPacket, MagneticBeadSeparationSecondaryWash],
					(*If MBS is not used and the option is not specified, it is set to Null.*)
					!mbsUsedQ,
						Null,
					(*If any of the secondaryWash options is specified by the user, set to True*)
					Or[
						MemberQ[Lookup[options, $MagneticBeadSeparationSecondaryWashOptions], Except[Automatic | Null]],
						(*or if any of the secondaryWash options is specified by the method*)
						methodSpecifiedQ && MemberQ[Lookup[methodPacket, Intersection[Keys[methodPacket], $MagneticBeadSeparationSecondaryWashOptions]], Except[Automatic | Null]]
					],
						True,
					(*Otherwise set to False, mirroring main MBS resolution*)
					True,
						False
				];

				(*Pre resolve magneticBeadSeparationSecondaryWashSolution*)
				magneticBeadSeparationSecondaryWashSolution = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, MagneticBeadSeparationSecondaryWashSolution], Except[Automatic]],
						Lookup[options, MagneticBeadSeparationSecondaryWashSolution],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, MagneticBeadSeparationSecondaryWashSolution, Null], Except[Null]],
						Lookup[methodPacket, MagneticBeadSeparationSecondaryWashSolution],
					(*If MBS is not used and the option is not specified, it is set to Null.*)
					!mbsUsedQ,
						Null,
					(*If the stage is on, use the default solution for the target*)
					magneticBeadSeparationSecondaryWash,
						defaultWashSolution,
					True,
						Automatic
				];


				(* --- PRERESOLVE TERTIARY OPTIONS --- *)

				magneticBeadSeparationTertiaryWash = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, MagneticBeadSeparationTertiaryWash], Except[Automatic]],
						Lookup[options, MagneticBeadSeparationTertiaryWash],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, MagneticBeadSeparationTertiaryWash, Null], Except[Null]],
						Lookup[methodPacket, MagneticBeadSeparationTertiaryWash],
					(*If MBS is not used and the option is not specified, it is set to Null.*)
					!mbsUsedQ,
						Null,
					(*If any of the tertiaryWash options is specified by the user, set to True*)
					Or[
						MemberQ[Lookup[options, $MagneticBeadSeparationTertiaryWashOptions], Except[Automatic | Null]],
						(*or if any of the tertiaryWash options is specified by the method*)
						methodSpecifiedQ && MemberQ[Lookup[methodPacket, Intersection[Keys[methodPacket], $MagneticBeadSeparationTertiaryWashOptions]], Except[Automatic | Null]]
					],
						True,
					(*Otherwise set to False, mirroring main MBS resolution*)
					True,
						False
				];

				(*Pre resolve magneticBeadSeparationTertiaryWashSolution*)
				magneticBeadSeparationTertiaryWashSolution = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, MagneticBeadSeparationTertiaryWashSolution], Except[Automatic]],
						Lookup[options, MagneticBeadSeparationTertiaryWashSolution],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, MagneticBeadSeparationTertiaryWashSolution, Null], Except[Null]],
						Lookup[methodPacket, MagneticBeadSeparationTertiaryWashSolution],
					(*If MBS is not used and the option is not specified, it is set to Null.*)
					!mbsUsedQ,
						Null,
					(*If the stage is on, use the default solution for the target*)
					magneticBeadSeparationTertiaryWash,
						defaultWashSolution,
					True,
						Automatic
				];

				(* --- PRERESOLVE QUATERNARYWASH OPTIONS --- *)

				magneticBeadSeparationQuaternaryWash = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, MagneticBeadSeparationQuaternaryWash], Except[Automatic]],
						Lookup[options, MagneticBeadSeparationQuaternaryWash],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, MagneticBeadSeparationQuaternaryWash, Null], Except[Null]],
						Lookup[methodPacket, MagneticBeadSeparationQuaternaryWash],
					(*If MBS is not used and the option is not specified, it is set to Null.*)
					!mbsUsedQ,
						Null,
					(*If any of the quaternaryWash options is specified by the user, set to True*)
					Or[
						MemberQ[Lookup[options, $MagneticBeadSeparationQuaternaryWashOptions], Except[Automatic | Null]],
						(*or if any of the quaternaryWash options is specified by the method*)
						methodSpecifiedQ && MemberQ[Lookup[methodPacket, Intersection[Keys[methodPacket], $MagneticBeadSeparationQuaternaryWashOptions]], Except[Automatic | Null]]
					],
						True,
					(*Otherwise set to False, mirroring main MBS resolution*)
					True,
						False
				];

				(*Pre resolve magneticBeadSeparationQuaternaryWashSolution*)
				magneticBeadSeparationQuaternaryWashSolution = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, MagneticBeadSeparationQuaternaryWashSolution], Except[Automatic]],
						Lookup[options, MagneticBeadSeparationQuaternaryWashSolution],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, MagneticBeadSeparationQuaternaryWashSolution, Null], Except[Null]],
						Lookup[methodPacket, MagneticBeadSeparationQuaternaryWashSolution],
					(*If MBS is not used and the option is not specified, it is set to Null.*)
					!mbsUsedQ,
						Null,
					(*If the stage is on, use the default solution for the target*)
					magneticBeadSeparationQuaternaryWash,
						defaultWashSolution,
					True,
						Automatic
				];

				(* --- PRERESOLVE QUINARYWASH OPTIONS --- *)

				magneticBeadSeparationQuinaryWash = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, MagneticBeadSeparationQuinaryWash], Except[Automatic]],
						Lookup[options, MagneticBeadSeparationQuinaryWash],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, MagneticBeadSeparationQuinaryWash, Null], Except[Null]],
						Lookup[methodPacket, MagneticBeadSeparationQuinaryWash],
					(*If MBS is not used and the option is not specified, it is set to Null.*)
					!mbsUsedQ,
						Null,
					(*If any of the quinaryWash options is specified by the user, set to True*)
					Or[
						MemberQ[Lookup[options, $MagneticBeadSeparationQuinaryWashOptions], Except[Automatic | Null]],
						(*or if any of the quinaryWash options is specified by the method*)
						methodSpecifiedQ && MemberQ[Lookup[methodPacket, Intersection[Keys[methodPacket], $MagneticBeadSeparationQuinaryWashOptions]], Except[Automatic | Null]]
					],
						True,
					(*Otherwise set to False, mirroring main MBS resolution*)
					True,
						False
				];

				(*Pre resolve magneticBeadSeparationQuinaryWashSolution*)
				magneticBeadSeparationQuinaryWashSolution = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, MagneticBeadSeparationQuinaryWashSolution], Except[Automatic]],
						Lookup[options, MagneticBeadSeparationQuinaryWashSolution],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, MagneticBeadSeparationQuinaryWashSolution, Null], Except[Null]],
						Lookup[methodPacket, MagneticBeadSeparationQuinaryWashSolution],
					(*If MBS is not used and the option is not specified, it is set to Null.*)
					!mbsUsedQ,
						Null,
					(*If the stage is on, use the default solution for the target*)
					magneticBeadSeparationQuinaryWash,
						defaultWashSolution,
					True,
						Automatic
				];

				(* --- PRERESOLVE SENARYWASH OPTIONS --- *)

				magneticBeadSeparationSenaryWash = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, MagneticBeadSeparationSenaryWash], Except[Automatic]],
						Lookup[options, MagneticBeadSeparationSenaryWash],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, MagneticBeadSeparationSenaryWash, Null], Except[Null]],
						Lookup[methodPacket, MagneticBeadSeparationSenaryWash],
					(*If MBS is not used and the option is not specified, it is set to Null.*)
					!mbsUsedQ,
						Null,
					(*If any of the senaryWash options is specified by the user, set to True*)
					Or[
						MemberQ[Lookup[options, $MagneticBeadSeparationSenaryWashOptions], Except[Automatic | Null]],
						(*or if any of the senaryWash options is specified by the method*)
						methodSpecifiedQ && MemberQ[Lookup[methodPacket, Intersection[Keys[methodPacket], $MagneticBeadSeparationSenaryWashOptions]], Except[Automatic | Null]]
					],
						True,
					(*Otherwise set to False, mirroring main MBS resolution*)
					True,
						False
				];

				(*Pre resolve magneticBeadSeparationSeptenaryWashSolution*)
				magneticBeadSeparationSenaryWashSolution = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, MagneticBeadSeparationSenaryWashSolution], Except[Automatic]],
						Lookup[options, MagneticBeadSeparationSenaryWashSolution],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, MagneticBeadSeparationSenaryWashSolution, Null], Except[Null]],
						Lookup[methodPacket, MagneticBeadSeparationSenaryWashSolution],
					(*If MBS is not used and the option is not specified, it is set to Null.*)
					!mbsUsedQ,
						Null,
					(*If the stage is on, use the default solution for the target*)
					magneticBeadSeparationSenaryWash,
						defaultWashSolution,
					True,
						Automatic
				];

				(* --- PRERESOLVE SEPTENARYWASH OPTIONS --- *)

				magneticBeadSeparationSeptenaryWash = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, MagneticBeadSeparationSeptenaryWash], Except[Automatic]],
						Lookup[options, MagneticBeadSeparationSeptenaryWash],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, MagneticBeadSeparationSeptenaryWash, Null], Except[Null]],
						Lookup[methodPacket, MagneticBeadSeparationSeptenaryWash],
					(*If MBS is not used and the option is not specified, it is set to Null.*)
					!mbsUsedQ,
						Null,
					(*If any of the septenaryWash options is specified by the user, set to True*)
					Or[
						MemberQ[Lookup[options, $MagneticBeadSeparationSeptenaryWashOptions], Except[Automatic | Null]],
						(*or if any of the septenaryWash options is specified by the method*)
						methodSpecifiedQ && MemberQ[Lookup[methodPacket, Intersection[Keys[methodPacket], $MagneticBeadSeparationSeptenaryWashOptions]], Except[Automatic | Null]]
					],
						True,
					(*Otherwise set to False, mirroring main MBS resolution*)
					True,
						False
				];

				(*Pre resolve magneticBeadSeparationSeptenaryWashSolution*)
				magneticBeadSeparationSeptenaryWashSolution = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, MagneticBeadSeparationSeptenaryWashSolution], Except[Automatic]],
						Lookup[options, MagneticBeadSeparationSeptenaryWashSolution],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, MagneticBeadSeparationSeptenaryWashSolution, Null], Except[Null]],
						Lookup[methodPacket, MagneticBeadSeparationSeptenaryWashSolution],
					(*If MBS is not used and the option is not specified, it is set to Null.*)
					!mbsUsedQ,
						Null,
					(*If the stage is on, use the default solution for the target*)
					magneticBeadSeparationSeptenaryWash,
						defaultWashSolution,
					True,
						Automatic
				];

				(* --- PRERESOLVE ELUTION OPTIONS --- *)

				magneticBeadSeparationElution = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, MagneticBeadSeparationElution], Except[Automatic]],
						Lookup[options, MagneticBeadSeparationElution],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, MagneticBeadSeparationElution, Null], Except[Null]],
						Lookup[methodPacket, MagneticBeadSeparationElution],
					(*If MBS is not used and the option is not specified, it is set to Null.*)
					!mbsUsedQ,
						Null,
					True,
						Module[{unresolvedElutionOptions},
							unresolvedElutionOptions = Lookup[options,{
								MagneticBeadSeparationElutionSolution,MagneticBeadSeparationElutionSolutionVolume,ElutionMagnetizationTime,MagneticBeadSeparationElutionAspirationVolume,NumberOfMagneticBeadSeparationElutions,
								MagneticBeadSeparationElutionMix,MagneticBeadSeparationElutionMixType,MagneticBeadSeparationElutionMixTime,MagneticBeadSeparationElutionMixRate,NumberOfMagneticBeadSeparationElutionMixes,
								MagneticBeadSeparationElutionMixVolume,MagneticBeadSeparationElutionMixTemperature,MagneticBeadSeparationElutionCollectionContainer,MagneticBeadSeparationElutionCollectionStorageCondition,
								MagneticBeadSeparationElutionMixTipType,MagneticBeadSeparationElutionMixTipMaterial
							}];
							(*If selection strategy is positive or any of the elution options specied, set to True*)
							If[MatchQ[magneticBeadSeparationSelectionStrategy,Positive]||MemberQ[unresolvedElutionOptions,Except[ListableP[Automatic]|ListableP[Null]]],
								True,
								False
							]
						]
				];

				(*Pre resolve magneticBeadSeparationElutionSolution*)
				magneticBeadSeparationElutionSolution = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, MagneticBeadSeparationElutionSolution], Except[Automatic]],
						Lookup[options, MagneticBeadSeparationElutionSolution],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, MagneticBeadSeparationElutionSolution, Null], Except[Null]],
						Lookup[methodPacket, MagneticBeadSeparationElutionSolution],
					(*If MBS is not used and the option is not specified, it is set to Null.*)
					!mbsUsedQ,
						Null,
					magneticBeadSeparationElution,
						defaultElutionSolution,
					True,
						Automatic
				];

				(*Pre resolve magneticBeadSeparationElutionSolutionVolume*)
				magneticBeadSeparationElutionSolutionVolume = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, MagneticBeadSeparationElutionSolutionVolume], Except[Automatic]],
						Lookup[options, MagneticBeadSeparationElutionSolutionVolume],
					(*If MBS is not used and the option is not specified, it is set to Null.*)
					!mbsUsedQ,
						Null,
					MatchQ[magneticBeadSeparationElution,True],
					(*If Elution is True, resolve it to volume/10 rounded *)
						Round[magneticBeadSeparationSampleVolume/10., 0.1 Microliter],
					True,
					(*If Elution is False, resolve it to Null*)
						Null
				];


				(*Pre resolve magneticBeadSeparationElutionAspirationVolume*)
				magneticBeadSeparationElutionAspirationVolume = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, MagneticBeadSeparationElutionAspirationVolume], Except[Automatic]],
						Lookup[options, MagneticBeadSeparationElutionAspirationVolume],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, MagneticBeadSeparationElutionAspirationVolume, Null], Except[Null]],
						Lookup[methodPacket, MagneticBeadSeparationElutionAspirationVolume],
					(*If MBS is not used and the option is not specified, it is set to Null.*)
					!mbsUsedQ,
						Null,
					MatchQ[magneticBeadSeparationElution, True],
						magneticBeadSeparationElutionSolutionVolume,
					True,
						Null
				];

				(*Pre resolve numberOfMagneticBeadSeparationElutions*)
				numberOfMagneticBeadSeparationElutions = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, NumberOfMagneticBeadSeparationElutions], Except[Automatic]],
						Lookup[options, NumberOfMagneticBeadSeparationElutions],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket, NumberOfMagneticBeadSeparationElutions, Null], Except[Null]],
						Lookup[methodPacket,NumberOfMagneticBeadSeparationElutions],
					(*If MBS is not used and the option is not specified, it is set to Null.*)
					!mbsUsedQ,
						Null,
					(*If left Automatic, the mainresolver will look at length of the collection container and resolve the number of elutions, which does not make sense in this case. So we fully resolve in this case.*)
					MatchQ[magneticBeadSeparationElution, True],
						1,
					True,
						Null
				];

				magneticBeadSeparationElutionCollectionContainer = Which[
					(*If specified by the user, set to user-specified value*)
					MatchQ[Lookup[options, MagneticBeadSeparationElutionCollectionContainer], Except[Automatic]],
						Lookup[options, MagneticBeadSeparationElutionCollectionContainer],
					(*If specified by the method, set to method-specified value*)
					methodSpecifiedQ && MatchQ[Lookup[methodPacket,MagneticBeadSeparationElutionCollectionContainer, Null], Except[Null]],
						Lookup[methodPacket, MagneticBeadSeparationElutionCollectionContainer],
					(*If MBS is not used and the option is not specified, it is set to Null.*)
					!mbsUsedQ,
						Null,
					(*If fully resolved elution is True, set to a model deep well sterile plate*)
					MatchQ[magneticBeadSeparationElution, True],
						Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
					True,
						Null
				];

				{
					(*3*)magneticBeadSeparationSampleVolume,
					(*4*)magneticBeadSeparationAnalyteAffinityLabel,
					(*5*)magneticBeadAffinityLabel,
					(*6*)magneticBead,
					(*6.1*)magneticBeadVolume,
					(*7*)magneticBeadCollectionStorageCondition,
					(*8*)magnetizationRack,

					(*9*)magneticBeadSeparationPreWash,
					(*10*)magneticBeadSeparationPreWashSolution,
					(*11*)magneticBeadSeparationPreWashSolutionVolume,
					(*12*)magneticBeadSeparationPreWashMix,
					(*13*)magneticBeadSeparationPreWashMixType,
					(*14*)magneticBeadSeparationPreWashMixTime,
					(*15*)magneticBeadSeparationPreWashMixRate,
					(*16*)numberOfMagneticBeadSeparationPreWashMixes,
					(*17*)magneticBeadSeparationPreWashMixVolume,
					(*18*)magneticBeadSeparationPreWashMixTemperature,
					(*19*)magneticBeadSeparationPreWashMixTipType,
					(*20*)magneticBeadSeparationPreWashMixTipMaterial,
					(*21*)preWashMagnetizationTime,
					(*22*)magneticBeadSeparationPreWashAspirationVolume,
					(*23*)magneticBeadSeparationPreWashCollectionContainer,
					(*24*)magneticBeadSeparationPreWashCollectionStorageCondition,
					(*25*)magneticBeadSeparationPreWashAirDry,
					(*26*)magneticBeadSeparationPreWashAirDryTime,
					(*27*)numberOfMagneticBeadSeparationPreWashes,

					(*28*)magneticBeadSeparationEquilibration,
					(*29*)magneticBeadSeparationEquilibrationSolution,
					(*30*)magneticBeadSeparationEquilibrationSolutionVolume,
					(*31*)magneticBeadSeparationEquilibrationMix,
					(*32*)magneticBeadSeparationEquilibrationMixType,
					(*33*)magneticBeadSeparationEquilibrationMixTime,
					(*34*)magneticBeadSeparationEquilibrationMixRate,
					(*35*)numberOfMagneticBeadSeparationEquilibrationMixes,
					(*36*)magneticBeadSeparationEquilibrationMixVolume,
					(*37*)magneticBeadSeparationEquilibrationMixTemperature,
					(*38*)magneticBeadSeparationEquilibrationMixTipType,
					(*39*)magneticBeadSeparationEquilibrationMixTipMaterial,
					(*40*)equilibrationMagnetizationTime,
					(*41*)magneticBeadSeparationEquilibrationAspirationVolume,
					(*42*)magneticBeadSeparationEquilibrationCollectionContainer,
					(*43*)magneticBeadSeparationEquilibrationCollectionStorageCondition,
					(*44*)magneticBeadSeparationEquilibrationAirDry,
					(*45*)magneticBeadSeparationEquilibrationAirDryTime,

					(*46*)magneticBeadSeparationLoadingMix,
					(*47*)magneticBeadSeparationLoadingMixType,
					(*48*)magneticBeadSeparationLoadingMixTime,
					(*49*)magneticBeadSeparationLoadingMixRate,
					(*50*)numberOfMagneticBeadSeparationLoadingMixes,
					(*51*)magneticBeadSeparationLoadingMixVolume,
					(*52*)magneticBeadSeparationLoadingMixTemperature,
					(*53*)magneticBeadSeparationLoadingMixTipType,
					(*54*)magneticBeadSeparationLoadingMixTipMaterial,
					(*55*)loadingMagnetizationTime,
					(*56*)magneticBeadSeparationLoadingAspirationVolume,
					(*57*)magneticBeadSeparationLoadingCollectionContainer,
					(*58*)magneticBeadSeparationLoadingCollectionStorageCondition,
					(*59*)magneticBeadSeparationLoadingAirDry,
					(*60*)magneticBeadSeparationLoadingAirDryTime,

					(*61*)magneticBeadSeparationWash,
					(*62*)magneticBeadSeparationWashSolution,
					(*63*)magneticBeadSeparationWashSolutionVolume,
					(*64*)magneticBeadSeparationWashMix,
					(*65*)magneticBeadSeparationWashMixType,
					(*66*)magneticBeadSeparationWashMixTime,
					(*67*)magneticBeadSeparationWashMixRate,
					(*68*)numberOfMagneticBeadSeparationWashMixes,
					(*69*)magneticBeadSeparationWashMixVolume,
					(*70*)magneticBeadSeparationWashMixTemperature,
					(*71*)magneticBeadSeparationWashMixTipType,
					(*72*)magneticBeadSeparationWashMixTipMaterial,
					(*73*)washMagnetizationTime,
					(*74*)magneticBeadSeparationWashAspirationVolume,
					(*75*)magneticBeadSeparationWashCollectionContainer,
					(*76*)magneticBeadSeparationWashCollectionStorageCondition,
					(*77*)magneticBeadSeparationWashAirDry,
					(*78*)magneticBeadSeparationWashAirDryTime,
					(*79*)numberOfMagneticBeadSeparationWashes,

					(*80*)magneticBeadSeparationSecondaryWash,
					(*81*)magneticBeadSeparationSecondaryWashSolution,
					(*82*)magneticBeadSeparationSecondaryWashSolutionVolume,
					(*83*)magneticBeadSeparationSecondaryWashMix,
					(*84*)magneticBeadSeparationSecondaryWashMixType,
					(*85*)magneticBeadSeparationSecondaryWashMixTime,
					(*86*)magneticBeadSeparationSecondaryWashMixRate,
					(*87*)numberOfMagneticBeadSeparationSecondaryWashMixes,
					(*88*)magneticBeadSeparationSecondaryWashMixVolume,
					(*89*)magneticBeadSeparationSecondaryWashMixTemperature,
					(*90*)magneticBeadSeparationSecondaryWashMixTipType,
					(*91*)magneticBeadSeparationSecondaryWashMixTipMaterial,
					(*92*)secondaryWashMagnetizationTime,
					(*93*)magneticBeadSeparationSecondaryWashAspirationVolume,
					(*94*)magneticBeadSeparationSecondaryWashCollectionContainer,
					(*95*)magneticBeadSeparationSecondaryWashCollectionStorageCondition,
					(*96*)magneticBeadSeparationSecondaryWashAirDry,
					(*97*)magneticBeadSeparationSecondaryWashAirDryTime,
					(*98*)numberOfMagneticBeadSeparationSecondaryWashes,

					(*99*)magneticBeadSeparationTertiaryWash,
					(*100*)magneticBeadSeparationTertiaryWashSolution,
					(*101*)magneticBeadSeparationTertiaryWashSolutionVolume,
					(*102*)magneticBeadSeparationTertiaryWashMix,
					(*103*)magneticBeadSeparationTertiaryWashMixType,
					(*104*)magneticBeadSeparationTertiaryWashMixTime,
					(*105*)magneticBeadSeparationTertiaryWashMixRate,
					(*106*)numberOfMagneticBeadSeparationTertiaryWashMixes,
					(*107*)magneticBeadSeparationTertiaryWashMixVolume,
					(*108*)magneticBeadSeparationTertiaryWashMixTemperature,
					(*109*)magneticBeadSeparationTertiaryWashMixTipType,
					(*110*)magneticBeadSeparationTertiaryWashMixTipMaterial,
					(*111*)tertiaryWashMagnetizationTime,
					(*112*)magneticBeadSeparationTertiaryWashAspirationVolume,
					(*113*)magneticBeadSeparationTertiaryWashCollectionContainer,
					(*114*)magneticBeadSeparationTertiaryWashCollectionStorageCondition,
					(*115*)magneticBeadSeparationTertiaryWashAirDry,
					(*116*)magneticBeadSeparationTertiaryWashAirDryTime,
					(*117*)numberOfMagneticBeadSeparationTertiaryWashes,

					(*118*)magneticBeadSeparationQuaternaryWash,
					(*119*)magneticBeadSeparationQuaternaryWashSolution,
					(*120*)magneticBeadSeparationQuaternaryWashSolutionVolume,
					(*121*)magneticBeadSeparationQuaternaryWashMix,
					(*122*)magneticBeadSeparationQuaternaryWashMixType,
					(*123*)magneticBeadSeparationQuaternaryWashMixTime,
					(*124*)magneticBeadSeparationQuaternaryWashMixRate,
					(*125*)numberOfMagneticBeadSeparationQuaternaryWashMixes,
					(*126*)magneticBeadSeparationQuaternaryWashMixVolume,
					(*127*)magneticBeadSeparationQuaternaryWashMixTemperature,
					(*128*)magneticBeadSeparationQuaternaryWashMixTipType,
					(*129*)magneticBeadSeparationQuaternaryWashMixTipMaterial,
					(*130*)quaternaryWashMagnetizationTime,
					(*131*)magneticBeadSeparationQuaternaryWashAspirationVolume,
					(*132*)magneticBeadSeparationQuaternaryWashCollectionContainer,
					(*133*)magneticBeadSeparationQuaternaryWashCollectionStorageCondition,
					(*134*)magneticBeadSeparationQuaternaryWashAirDry,
					(*135*)magneticBeadSeparationQuaternaryWashAirDryTime,
					(*136*)numberOfMagneticBeadSeparationQuaternaryWashes,

					(*137*)magneticBeadSeparationQuinaryWash,
					(*138*)magneticBeadSeparationQuinaryWashSolution,
					(*139*)magneticBeadSeparationQuinaryWashSolutionVolume,
					(*140*)magneticBeadSeparationQuinaryWashMix,
					(*141*)magneticBeadSeparationQuinaryWashMixType,
					(*142*)magneticBeadSeparationQuinaryWashMixTime,
					(*143*)magneticBeadSeparationQuinaryWashMixRate,
					(*144*)numberOfMagneticBeadSeparationQuinaryWashMixes,
					(*145*)magneticBeadSeparationQuinaryWashMixVolume,
					(*146*)magneticBeadSeparationQuinaryWashMixTemperature,
					(*147*)magneticBeadSeparationQuinaryWashMixTipType,
					(*148*)magneticBeadSeparationQuinaryWashMixTipMaterial,
					(*149*)quinaryWashMagnetizationTime,
					(*150*)magneticBeadSeparationQuinaryWashAspirationVolume,
					(*151*)magneticBeadSeparationQuinaryWashCollectionContainer,
					(*152*)magneticBeadSeparationQuinaryWashCollectionStorageCondition,
					(*153*)magneticBeadSeparationQuinaryWashAirDry,
					(*154*)magneticBeadSeparationQuinaryWashAirDryTime,
					(*155*)numberOfMagneticBeadSeparationQuinaryWashes,

					(*156*)magneticBeadSeparationSenaryWash,
					(*157*)magneticBeadSeparationSenaryWashSolution,
					(*158*)magneticBeadSeparationSenaryWashSolutionVolume,
					(*159*)magneticBeadSeparationSenaryWashMix,
					(*160*)magneticBeadSeparationSenaryWashMixType,
					(*161*)magneticBeadSeparationSenaryWashMixTime,
					(*162*)magneticBeadSeparationSenaryWashMixRate,
					(*163*)numberOfMagneticBeadSeparationSenaryWashMixes,
					(*164*)magneticBeadSeparationSenaryWashMixVolume,
					(*165*)magneticBeadSeparationSenaryWashMixTemperature,
					(*166*)magneticBeadSeparationSenaryWashMixTipType,
					(*167*)magneticBeadSeparationSenaryWashMixTipMaterial,
					(*168*)senaryWashMagnetizationTime,
					(*169*)magneticBeadSeparationSenaryWashAspirationVolume,
					(*170*)magneticBeadSeparationSenaryWashCollectionContainer,
					(*171*)magneticBeadSeparationSenaryWashCollectionStorageCondition,
					(*172*)magneticBeadSeparationSenaryWashAirDry,
					(*173*)magneticBeadSeparationSenaryWashAirDryTime,
					(*174*)numberOfMagneticBeadSeparationSenaryWashes,

					(*175*)magneticBeadSeparationSeptenaryWash,
					(*176*)magneticBeadSeparationSeptenaryWashSolution,
					(*177*)magneticBeadSeparationSeptenaryWashSolutionVolume,
					(*178*)magneticBeadSeparationSeptenaryWashMix,
					(*179*)magneticBeadSeparationSeptenaryWashMixType,
					(*180*)magneticBeadSeparationSeptenaryWashMixTime,
					(*181*)magneticBeadSeparationSeptenaryWashMixRate,
					(*182*)numberOfMagneticBeadSeparationSeptenaryWashMixes,
					(*183*)magneticBeadSeparationSeptenaryWashMixVolume,
					(*184*)magneticBeadSeparationSeptenaryWashMixTemperature,
					(*185*)magneticBeadSeparationSeptenaryWashMixTipType,
					(*186*)magneticBeadSeparationSeptenaryWashMixTipMaterial,
					(*187*)septenaryWashMagnetizationTime,
					(*188*)magneticBeadSeparationSeptenaryWashAspirationVolume,
					(*189*)magneticBeadSeparationSeptenaryWashCollectionContainer,
					(*190*)magneticBeadSeparationSeptenaryWashCollectionStorageCondition,
					(*191*)magneticBeadSeparationSeptenaryWashAirDry,
					(*192*)magneticBeadSeparationSeptenaryWashAirDryTime,
					(*193*)numberOfMagneticBeadSeparationSeptenaryWashes,

					(*194*)magneticBeadSeparationElution,
					(*195*)magneticBeadSeparationElutionSolution,
					(*196*)magneticBeadSeparationElutionSolutionVolume,
					(*197*)magneticBeadSeparationElutionMix,
					(*198*)magneticBeadSeparationElutionMixType,
					(*199*)magneticBeadSeparationElutionMixTime,
					(*200*)magneticBeadSeparationElutionMixRate,
					(*201*)numberOfMagneticBeadSeparationElutionMixes,
					(*202*)magneticBeadSeparationElutionMixVolume,
					(*203*)magneticBeadSeparationElutionMixTemperature,
					(*204*)magneticBeadSeparationElutionMixTipType,
					(*205*)magneticBeadSeparationElutionMixTipMaterial,
					(*206*)elutionMagnetizationTime,
					(*207*)magneticBeadSeparationElutionAspirationVolume,
					(*208*)magneticBeadSeparationElutionCollectionContainer,
					(*209*)magneticBeadSeparationElutionCollectionStorageCondition,
					(*210*)numberOfMagneticBeadSeparationElutions,

					(*211*)magneticBeadSeparationPreWashCollectionContainerLabel,
					(*212*)magneticBeadSeparationEquilibrationCollectionContainerLabel,
					(*213*)magneticBeadSeparationLoadingCollectionContainerLabel,
					(*214*)magneticBeadSeparationWashCollectionContainerLabel,
					(*215*)magneticBeadSeparationSecondaryWashCollectionContainerLabel,
					(*216*)magneticBeadSeparationTertiaryWashCollectionContainerLabel,
					(*217*)magneticBeadSeparationQuaternaryWashCollectionContainerLabel,
					(*218*)magneticBeadSeparationQuinaryWashCollectionContainerLabel,
					(*219*)magneticBeadSeparationSenaryWashCollectionContainerLabel,
					(*220*)magneticBeadSeparationSeptenaryWashCollectionContainerLabel,
					(*221*)magneticBeadSeparationElutionCollectionContainerLabel
				}
			]
		],
		{mySamples,myMapThreadOptions, methodPackets,targets}
	];

	(*Pre resolve magneticBeadSeparationElutionCollectionContainer*)
	(*It is pre-resolved using PackContainer, making sure it is index matched to input samples ONLY and it is pooling samples from multiple elutions (to avoid being expanded by the mainMBS resolver), So that the number of samples remains through out the Extract/Harvest experiment pipeline. *)
	{preResolvedPackedMagneticBeadSeparationElutionCollectionContainers,expandedPackedMagneticBeadSeparationElutionCollectionContainers}= Module[
		{elutionPackPlateQ,requiredVolumes,resolvedContainers,resolvedWells},
		(*Determine if it needs*)
		elutionPackPlateQ = If[
			MemberQ[Flatten@ToList[#], ObjectP[{Model[Container, Plate], Object[Container, Plate]}]],
			True,
			False
		] & /@ preResolvedMagneticBeadSeparationElutionCollectionContainers;

		(*Calculate required volumes*)
		requiredVolumes = MapThread[
			Function[{volume,numberOfElutions},
				If[MatchQ[{volume,numberOfElutions},{VolumeP,_Integer}],
					volume*numberOfElutions,
					Null
				]
			],
			{preResolvedMagneticBeadSeparationElutionAspirationVolumes,preResolvedNumbersOfMagneticBeadSeparationElutions}
		];

		(*Call PackPlate to resolve the elution collection containers*)
		{resolvedContainers,resolvedWells} = Quiet[PackContainers[
			preResolvedMagneticBeadSeparationElutionCollectionContainers,
			elutionPackPlateQ,
			requiredVolumes,
			preResolvedMagneticBeadSeparationElutionCollectionStorageConditions,
			Messages->False,
			LiquidHandlerCompatible -> True,
			Simulation->simulation
		]];
		(*Reassemble the format of the resolved packed containers to feed to mainMBS. If the user specified an index, include the index. If the user did not specify any index, no index is fed in order to avoid conflict with other potentially user-specified indices in Extract/Harvest experiments.*)
		Transpose@MapThread[
			Function[{resolvedContainer, resolvedWell,numberOfElutions},
				Module[{packedContainer,expandedResolvedContainer},
					(* Get the final format of the packed container for this sample*)
					packedContainer=Switch[resolvedContainer,
						(*If the pre-resolved container is a model or object container alone, pass the resolved wells into MBS*)
						ObjectP[{Object[Container], Model[Container]}], {resolvedWell, resolvedContainer},
						(*If the pre-resolved container is {index,model}, pass the resolved wells into MBS*)
						{_Integer,ObjectP[]},{resolvedWell, resolvedContainer},
						(*Otherwise, the resolved container is either Null or already has well information, pass as it is*)
						_, resolvedContainer
					];
					(*Expand into the format of correct index matching by duplicate for multiple number of elutions*)
					expandedResolvedContainer = If[MatchQ[numberOfElutions,GreaterEqualP[1,1]],
						ConstantArray[packedContainer,numberOfElutions],
						resolvedContainer
					];

					(*Return non-repeated packed containers and expanded repeated packed containers*)
					{packedContainer, expandedResolvedContainer}
				]
			],
			{preResolvedMagneticBeadSeparationElutionCollectionContainers,resolvedWells,preResolvedNumbersOfMagneticBeadSeparationElutions}
		]
	];

	(*Pre resolve magneticBeadSeparationLoadingCollectionContainer*)
	(*It is pre-resolved using PackContainer, making sure it is index matched to input samples ONLY (to avoid being expanded by the mainMBS resolver), So that the number of samples remains through out the Extract/Harvest experiment pipeline. *)
	preResolvedPackedMagneticBeadSeparationLoadingCollectionContainers = If[MatchQ[resolvedMagneticBeadSeparationSelectionStrategy, Negative],
		Module[
			{safePreResolvedMagneticBeadSeparationLoadingAspirationVolumes, loadingPackPlateQ, resolvedContainers, resolvedWells},
			(*Determine if it needs*)
			loadingPackPlateQ = If[
				MemberQ[Flatten@ToList[#], ObjectP[{Model[Container, Plate], Object[Container, Plate]}]],
				True,
				False
			] & /@ preResolvedMagneticBeadSeparationLoadingCollectionContainers;

			(*Get a safe loading aspiration volume just for PackContainers in case we dont know the sample loading volume yet*)
			safePreResolvedMagneticBeadSeparationLoadingAspirationVolumes = MapThread[
				Function[{preResolvedAspirationVolume, preResolvedCollectionContainer},
					(*If the volume was preresolved, use it*)
					If[MatchQ[preResolvedAspirationVolume,VolumeP],
						preResolvedAspirationVolume,
						(*Oherwise we need to decide based on the preresolved collection container*)
						Switch[preResolvedCollectionContainer,
							(*If the container is a model or object, use 60% of its max volume. If Max volume does not exist,use 0.2 mL to be safe*)
							ObjectP[{Model[Container],Object[Container]}],
							0.6*(Lookup[fetchPacketFromCache[preResolvedCollectionContainer,containerPackets],MaxVolume,Null]/.Null->0.2*Milliliter),
							(*If it is Automatic, use 1 mL for PackContainer to safely pick a deep well plate*)
							Automatic, 1*Milliliter,
							(*It should not reach here, but have a resolution anyway*)
							_, Automatic
						]
					]
				],
				{preResolvedMagneticBeadSeparationLoadingAspirationVolumes,preResolvedMagneticBeadSeparationLoadingCollectionContainers}
			];

			(*Call PackPlate to resolve the loading collection containers*)
			{resolvedContainers, resolvedWells} = Quiet[PackContainers[
				preResolvedMagneticBeadSeparationLoadingCollectionContainers,
				loadingPackPlateQ,
				safePreResolvedMagneticBeadSeparationLoadingAspirationVolumes,
				preResolvedMagneticBeadSeparationLoadingCollectionStorageConditions/.Automatic->Refrigerator,(*Safe replacement for PackContainers only*)
				Messages->False,
				LiquidHandlerCompatible -> True,
				Simulation->simulation
			]];

			(*Reassemble the format of the resolved packed containers to feed to mainMBS. If the user specified an index, include the index. If the user did not specify any index, no index is fed in order to avoid conflict with other potentially user-specified indices in Extract/Harvest experiments.*)
			MapThread[
				Function[{resolvedContainer, resolvedWell},
					Module[{packedContainer},
						(* Get the final format of the packed container for this sample*)
						packedContainer=Switch[resolvedContainer,
							(*If the pre-resolved container is a model or object container alone, pass the resolved wells into MBS*)
							ObjectP[{Object[Container], Model[Container]}], {resolvedWell, resolvedContainer},
							(*If the pre-resolved container is {index,model}, pass the resolved wells into MBS*)
							{_Integer,ObjectP[]},{resolvedWell, resolvedContainer},
							(*Otherwise, the resolved container is either Null or already has well information, pass as it is*)
							_, resolvedContainer
						]
					]
				],
				{preResolvedMagneticBeadSeparationLoadingCollectionContainers, resolvedWells}
			]
		],
		preResolvedMagneticBeadSeparationLoadingCollectionContainers
	];

	{
		(*1*)MagneticBeadSeparationSelectionStrategy -> resolvedMagneticBeadSeparationSelectionStrategy,
		(*2*)MagneticBeadSeparationMode -> resolvedMagneticBeadSeparationMode,
		(*3*)MagneticBeadSeparationSampleVolume -> preResolvedMagneticBeadSeparationSampleVolumes,
		(*4*)MagneticBeadSeparationAnalyteAffinityLabel -> preResolvedMagneticBeadSeparationAnalyteAffinityLabels,
		(*5*)MagneticBeadAffinityLabel -> preResolvedMagneticBeadAffinityLabels,
		(*6*)MagneticBeads -> preResolvedMagneticBeads,
		(*6.1*)MagneticBeadVolume -> preResolvedMagneticBeadVolumes,
		(*7*)MagneticBeadCollectionStorageCondition -> preResolvedMagneticBeadCollectionStorageConditions,
		(*8*)MagnetizationRack -> preResolvedMagnetizationRacks,

		(*9*)MagneticBeadSeparationPreWash -> preResolvedMagneticBeadSeparationPreWashes,
		(*10*)MagneticBeadSeparationPreWashSolution -> preResolvedMagneticBeadSeparationPreWashSolutions,
		(*11*)MagneticBeadSeparationPreWashSolutionVolume -> preResolvedMagneticBeadSeparationPreWashSolutionVolumes,
		(*12*)MagneticBeadSeparationPreWashMix -> preResolvedMagneticBeadSeparationPreWashMixes,
		(*13*)MagneticBeadSeparationPreWashMixType -> preResolvedMagneticBeadSeparationPreWashMixTypes,
		(*14*)MagneticBeadSeparationPreWashMixTime -> preResolvedMagneticBeadSeparationPreWashMixTimes,
		(*15*)MagneticBeadSeparationPreWashMixRate -> preResolvedMagneticBeadSeparationPreWashMixRates,
		(*16*)NumberOfMagneticBeadSeparationPreWashMixes -> preResolvedNumbersOfMagneticBeadSeparationPreWashMixes,
		(*17*)MagneticBeadSeparationPreWashMixVolume -> preResolvedMagneticBeadSeparationPreWashMixVolumes,
		(*18*)MagneticBeadSeparationPreWashMixTemperature -> preResolvedMagneticBeadSeparationPreWashMixTemperatures,
		(*19*)MagneticBeadSeparationPreWashMixTipType -> preResolvedMagneticBeadSeparationPreWashMixTipTypes,
		(*20*)MagneticBeadSeparationPreWashMixTipMaterial -> preResolvedMagneticBeadSeparationPreWashMixTipMaterials,
		(*21*)PreWashMagnetizationTime -> preResolvedPreWashMagnetizationTimes,
		(*22*)MagneticBeadSeparationPreWashAspirationVolume -> preResolvedMagneticBeadSeparationPreWashAspirationVolumes,
		(*23*)MagneticBeadSeparationPreWashCollectionContainer -> preResolvedMagneticBeadSeparationPreWashCollectionContainers,
		(*24*)MagneticBeadSeparationPreWashCollectionStorageCondition -> preResolvedMagneticBeadSeparationPreWashCollectionStorageConditions,
		(*25*)MagneticBeadSeparationPreWashAirDry -> preResolvedMagneticBeadSeparationPreWashAirDries,
		(*26*)MagneticBeadSeparationPreWashAirDryTime -> preResolvedMagneticBeadSeparationPreWashAirDryTimes,
		(*27*)NumberOfMagneticBeadSeparationPreWashes -> preResolvedNumbersOfMagneticBeadSeparationPreWashes,

		(*28*)MagneticBeadSeparationEquilibration -> preResolvedMagneticBeadSeparationEquilibrations,
		(*29*)MagneticBeadSeparationEquilibrationSolution -> preResolvedMagneticBeadSeparationEquilibrationSolutions,
		(*30*)MagneticBeadSeparationEquilibrationSolutionVolume -> preResolvedMagneticBeadSeparationEquilibrationSolutionVolumes,
		(*31*)MagneticBeadSeparationEquilibrationMix -> preResolvedMagneticBeadSeparationEquilibrationMixes,
		(*32*)MagneticBeadSeparationEquilibrationMixType -> preResolvedMagneticBeadSeparationEquilibrationMixTypes,
		(*33*)MagneticBeadSeparationEquilibrationMixTime -> preResolvedMagneticBeadSeparationEquilibrationMixTimes,
		(*34*)MagneticBeadSeparationEquilibrationMixRate -> preResolvedMagneticBeadSeparationEquilibrationMixRates,
		(*35*)NumberOfMagneticBeadSeparationEquilibrationMixes -> preResolvedNumbersOfMagneticBeadSeparationEquilibrationMixes,
		(*36*)MagneticBeadSeparationEquilibrationMixVolume -> preResolvedMagneticBeadSeparationEquilibrationMixVolumes,
		(*37*)MagneticBeadSeparationEquilibrationMixTemperature -> preResolvedMagneticBeadSeparationEquilibrationMixTemperatures,
		(*38*)MagneticBeadSeparationEquilibrationMixTipType -> preResolvedMagneticBeadSeparationEquilibrationMixTipTypes,
		(*39*)MagneticBeadSeparationEquilibrationMixTipMaterial -> preResolvedMagneticBeadSeparationEquilibrationMixTipMaterials,
		(*40*)EquilibrationMagnetizationTime -> preResolvedEquilibrationMagnetizationTimes,
		(*41*)MagneticBeadSeparationEquilibrationAspirationVolume -> preResolvedMagneticBeadSeparationEquilibrationAspirationVolumes,
		(*42*)MagneticBeadSeparationEquilibrationCollectionContainer -> preResolvedMagneticBeadSeparationEquilibrationCollectionContainers,
		(*43*)MagneticBeadSeparationEquilibrationCollectionStorageCondition -> preResolvedMagneticBeadSeparationEquilibrationCollectionStorageConditions,
		(*44*)MagneticBeadSeparationEquilibrationAirDry -> preResolvedMagneticBeadSeparationEquilibrationAirDries,
		(*45*)MagneticBeadSeparationEquilibrationAirDryTime -> preResolvedMagneticBeadSeparationEquilibrationAirDryTimes,

		(*46*)MagneticBeadSeparationLoadingMix -> preResolvedMagneticBeadSeparationLoadingMixes,
		(*47*)MagneticBeadSeparationLoadingMixType -> preResolvedMagneticBeadSeparationLoadingMixTypes,
		(*48*)MagneticBeadSeparationLoadingMixTime -> preResolvedMagneticBeadSeparationLoadingMixTimes,
		(*49*)MagneticBeadSeparationLoadingMixRate -> preResolvedMagneticBeadSeparationLoadingMixRates,
		(*50*)NumberOfMagneticBeadSeparationLoadingMixes -> preResolvedNumbersOfMagneticBeadSeparationLoadingMixes,
		(*51*)MagneticBeadSeparationLoadingMixVolume -> preResolvedMagneticBeadSeparationLoadingMixVolumes,
		(*52*)MagneticBeadSeparationLoadingMixTemperature -> preResolvedMagneticBeadSeparationLoadingMixTemperatures,
		(*53*)MagneticBeadSeparationLoadingMixTipType -> preResolvedMagneticBeadSeparationLoadingMixTipTypes,
		(*54*)MagneticBeadSeparationLoadingMixTipMaterial -> preResolvedMagneticBeadSeparationLoadingMixTipMaterials,
		(*55*)LoadingMagnetizationTime -> preResolvedLoadingMagnetizationTimes,
		(*56*)MagneticBeadSeparationLoadingAspirationVolume -> preResolvedMagneticBeadSeparationLoadingAspirationVolumes,
		(*57*)MagneticBeadSeparationLoadingCollectionContainer -> preResolvedPackedMagneticBeadSeparationLoadingCollectionContainers,
		(*58*)MagneticBeadSeparationLoadingCollectionStorageCondition -> preResolvedMagneticBeadSeparationLoadingCollectionStorageConditions,
		(*59*)MagneticBeadSeparationLoadingAirDry -> preResolvedMagneticBeadSeparationLoadingAirDries,
		(*60*)MagneticBeadSeparationLoadingAirDryTime -> preResolvedMagneticBeadSeparationLoadingAirDryTimes,

		(*61*)MagneticBeadSeparationWash -> preResolvedMagneticBeadSeparationWashes,
		(*62*)MagneticBeadSeparationWashSolution -> preResolvedMagneticBeadSeparationWashSolutions,
		(*63*)MagneticBeadSeparationWashSolutionVolume -> preResolvedMagneticBeadSeparationWashSolutionVolumes,
		(*64*)MagneticBeadSeparationWashMix -> preResolvedMagneticBeadSeparationWashMixes,
		(*65*)MagneticBeadSeparationWashMixType -> preResolvedMagneticBeadSeparationWashMixTypes,
		(*66*)MagneticBeadSeparationWashMixTime -> preResolvedMagneticBeadSeparationWashMixTimes,
		(*67*)MagneticBeadSeparationWashMixRate -> preResolvedMagneticBeadSeparationWashMixRates,
		(*68*)NumberOfMagneticBeadSeparationWashMixes -> preResolvedNumbersOfMagneticBeadSeparationWashMixes,
		(*69*)MagneticBeadSeparationWashMixVolume -> preResolvedMagneticBeadSeparationWashMixVolumes,
		(*70*)MagneticBeadSeparationWashMixTemperature -> preResolvedMagneticBeadSeparationWashMixTemperatures,
		(*71*)MagneticBeadSeparationWashMixTipType -> preResolvedMagneticBeadSeparationWashMixTipTypes,
		(*72*)MagneticBeadSeparationWashMixTipMaterial -> preResolvedMagneticBeadSeparationWashMixTipMaterials,
		(*73*)WashMagnetizationTime -> preResolvedWashMagnetizationTimes,
		(*74*)MagneticBeadSeparationWashAspirationVolume -> preResolvedMagneticBeadSeparationWashAspirationVolumes,
		(*75*)MagneticBeadSeparationWashCollectionContainer -> preResolvedMagneticBeadSeparationWashCollectionContainers,
		(*76*)MagneticBeadSeparationWashCollectionStorageCondition -> preResolvedMagneticBeadSeparationWashCollectionStorageConditions,
		(*77*)MagneticBeadSeparationWashAirDry -> preResolvedMagneticBeadSeparationWashAirDries,
		(*78*)MagneticBeadSeparationWashAirDryTime -> preResolvedMagneticBeadSeparationWashAirDryTimes,
		(*79*)NumberOfMagneticBeadSeparationWashes -> preResolvedNumbersOfMagneticBeadSeparationWashes,

		(*80*)MagneticBeadSeparationSecondaryWash -> preResolvedMagneticBeadSeparationSecondaryWashes,
		(*81*)MagneticBeadSeparationSecondaryWashSolution -> preResolvedMagneticBeadSeparationSecondaryWashSolutions,
		(*82*)MagneticBeadSeparationSecondaryWashSolutionVolume -> preResolvedMagneticBeadSeparationSecondaryWashSolutionVolumes,
		(*83*)MagneticBeadSeparationSecondaryWashMix -> preResolvedMagneticBeadSeparationSecondaryWashMixes,
		(*84*)MagneticBeadSeparationSecondaryWashMixType -> preResolvedMagneticBeadSeparationSecondaryWashMixTypes,
		(*85*)MagneticBeadSeparationSecondaryWashMixTime -> preResolvedMagneticBeadSeparationSecondaryWashMixTimes,
		(*86*)MagneticBeadSeparationSecondaryWashMixRate -> preResolvedMagneticBeadSeparationSecondaryWashMixRates,
		(*87*)NumberOfMagneticBeadSeparationSecondaryWashMixes -> preResolvedNumbersOfMagneticBeadSeparationSecondaryWashMixes,
		(*88*)MagneticBeadSeparationSecondaryWashMixVolume -> preResolvedMagneticBeadSeparationSecondaryWashMixVolumes,
		(*89*)MagneticBeadSeparationSecondaryWashMixTemperature -> preResolvedMagneticBeadSeparationSecondaryWashMixTemperatures,
		(*90*)MagneticBeadSeparationSecondaryWashMixTipType -> preResolvedMagneticBeadSeparationSecondaryWashMixTipTypes,
		(*91*)MagneticBeadSeparationSecondaryWashMixTipMaterial -> preResolvedMagneticBeadSeparationSecondaryWashMixTipMaterials,
		(*92*)SecondaryWashMagnetizationTime -> preResolvedSecondaryWashMagnetizationTimes,
		(*93*)MagneticBeadSeparationSecondaryWashAspirationVolume -> preResolvedMagneticBeadSeparationSecondaryWashAspirationVolumes,
		(*94*)MagneticBeadSeparationSecondaryWashCollectionContainer -> preResolvedMagneticBeadSeparationSecondaryWashCollectionContainers,
		(*95*)MagneticBeadSeparationSecondaryWashCollectionStorageCondition -> preResolvedMagneticBeadSeparationSecondaryWashCollectionStorageConditions,
		(*96*)MagneticBeadSeparationSecondaryWashAirDry -> preResolvedMagneticBeadSeparationSecondaryWashAirDries,
		(*97*)MagneticBeadSeparationSecondaryWashAirDryTime -> preResolvedMagneticBeadSeparationSecondaryWashAirDryTimes,
		(*98*)NumberOfMagneticBeadSeparationSecondaryWashes -> preResolvedNumbersOfMagneticBeadSeparationSecondaryWashes,

		(*99*)MagneticBeadSeparationTertiaryWash -> preResolvedMagneticBeadSeparationTertiaryWashes,
		(*100*)MagneticBeadSeparationTertiaryWashSolution -> preResolvedMagneticBeadSeparationTertiaryWashSolutions,
		(*101*)MagneticBeadSeparationTertiaryWashSolutionVolume -> preResolvedMagneticBeadSeparationTertiaryWashSolutionVolumes,
		(*102*)MagneticBeadSeparationTertiaryWashMix -> preResolvedMagneticBeadSeparationTertiaryWashMixes,
		(*103*)MagneticBeadSeparationTertiaryWashMixType -> preResolvedMagneticBeadSeparationTertiaryWashMixTypes,
		(*104*)MagneticBeadSeparationTertiaryWashMixTime -> preResolvedMagneticBeadSeparationTertiaryWashMixTimes,
		(*105*)MagneticBeadSeparationTertiaryWashMixRate -> preResolvedMagneticBeadSeparationTertiaryWashMixRates,
		(*106*)NumberOfMagneticBeadSeparationTertiaryWashMixes -> preResolvedNumbersOfMagneticBeadSeparationTertiaryWashMixes,
		(*107*)MagneticBeadSeparationTertiaryWashMixVolume -> preResolvedMagneticBeadSeparationTertiaryWashMixVolumes,
		(*108*)MagneticBeadSeparationTertiaryWashMixTemperature -> preResolvedMagneticBeadSeparationTertiaryWashMixTemperatures,
		(*109*)MagneticBeadSeparationTertiaryWashMixTipType -> preResolvedMagneticBeadSeparationTertiaryWashMixTipTypes,
		(*110*)MagneticBeadSeparationTertiaryWashMixTipMaterial -> preResolvedMagneticBeadSeparationTertiaryWashMixTipMaterials,
		(*111*)TertiaryWashMagnetizationTime -> preResolvedTertiaryWashMagnetizationTimes,
		(*112*)MagneticBeadSeparationTertiaryWashAspirationVolume -> preResolvedMagneticBeadSeparationTertiaryWashAspirationVolumes,
		(*113*)MagneticBeadSeparationTertiaryWashCollectionContainer -> preResolvedMagneticBeadSeparationTertiaryWashCollectionContainers,
		(*114*)MagneticBeadSeparationTertiaryWashCollectionStorageCondition -> preResolvedMagneticBeadSeparationTertiaryWashCollectionStorageConditions,
		(*115*)MagneticBeadSeparationTertiaryWashAirDry -> preResolvedMagneticBeadSeparationTertiaryWashAirDries,
		(*116*)MagneticBeadSeparationTertiaryWashAirDryTime -> preResolvedMagneticBeadSeparationTertiaryWashAirDryTimes,
		(*117*)NumberOfMagneticBeadSeparationTertiaryWashes -> preResolvedNumbersOfMagneticBeadSeparationTertiaryWashes,

		(*118*)MagneticBeadSeparationQuaternaryWash -> preResolvedMagneticBeadSeparationQuaternaryWashes,
		(*119*)MagneticBeadSeparationQuaternaryWashSolution -> preResolvedMagneticBeadSeparationQuaternaryWashSolutions,
		(*120*)MagneticBeadSeparationQuaternaryWashSolutionVolume -> preResolvedMagneticBeadSeparationQuaternaryWashSolutionVolumes,
		(*121*)MagneticBeadSeparationQuaternaryWashMix -> preResolvedMagneticBeadSeparationQuaternaryWashMixes,
		(*122*)MagneticBeadSeparationQuaternaryWashMixType -> preResolvedMagneticBeadSeparationQuaternaryWashMixTypes,
		(*123*)MagneticBeadSeparationQuaternaryWashMixTime -> preResolvedMagneticBeadSeparationQuaternaryWashMixTimes,
		(*124*)MagneticBeadSeparationQuaternaryWashMixRate -> preResolvedMagneticBeadSeparationQuaternaryWashMixRates,
		(*125*)NumberOfMagneticBeadSeparationQuaternaryWashMixes -> preResolvedNumbersOfMagneticBeadSeparationQuaternaryWashMixes,
		(*126*)MagneticBeadSeparationQuaternaryWashMixVolume -> preResolvedMagneticBeadSeparationQuaternaryWashMixVolumes,
		(*127*)MagneticBeadSeparationQuaternaryWashMixTemperature -> preResolvedMagneticBeadSeparationQuaternaryWashMixTemperatures,
		(*128*)MagneticBeadSeparationQuaternaryWashMixTipType -> preResolvedMagneticBeadSeparationQuaternaryWashMixTipTypes,
		(*129*)MagneticBeadSeparationQuaternaryWashMixTipMaterial -> preResolvedMagneticBeadSeparationQuaternaryWashMixTipMaterials,
		(*130*)QuaternaryWashMagnetizationTime -> preResolvedQuaternaryWashMagnetizationTimes,
		(*131*)MagneticBeadSeparationQuaternaryWashAspirationVolume -> preResolvedMagneticBeadSeparationQuaternaryWashAspirationVolumes,
		(*132*)MagneticBeadSeparationQuaternaryWashCollectionContainer -> preResolvedMagneticBeadSeparationQuaternaryWashCollectionContainers,
		(*133*)MagneticBeadSeparationQuaternaryWashCollectionStorageCondition -> preResolvedMagneticBeadSeparationQuaternaryWashCollectionStorageConditions,
		(*134*)MagneticBeadSeparationQuaternaryWashAirDry -> preResolvedMagneticBeadSeparationQuaternaryWashAirDries,
		(*135*)MagneticBeadSeparationQuaternaryWashAirDryTime -> preResolvedMagneticBeadSeparationQuaternaryWashAirDryTimes,
		(*136*)NumberOfMagneticBeadSeparationQuaternaryWashes -> preResolvedNumbersOfMagneticBeadSeparationQuaternaryWashes,

		(*137*)MagneticBeadSeparationQuinaryWash -> preResolvedMagneticBeadSeparationQuinaryWashes,
		(*138*)MagneticBeadSeparationQuinaryWashSolution -> preResolvedMagneticBeadSeparationQuinaryWashSolutions,
		(*139*)MagneticBeadSeparationQuinaryWashSolutionVolume -> preResolvedMagneticBeadSeparationQuinaryWashSolutionVolumes,
		(*140*)MagneticBeadSeparationQuinaryWashMix -> preResolvedMagneticBeadSeparationQuinaryWashMixes,
		(*141*)MagneticBeadSeparationQuinaryWashMixType -> preResolvedMagneticBeadSeparationQuinaryWashMixTypes,
		(*142*)MagneticBeadSeparationQuinaryWashMixTime -> preResolvedMagneticBeadSeparationQuinaryWashMixTimes,
		(*143*)MagneticBeadSeparationQuinaryWashMixRate -> preResolvedMagneticBeadSeparationQuinaryWashMixRates,
		(*144*)NumberOfMagneticBeadSeparationQuinaryWashMixes -> preResolvedNumbersOfMagneticBeadSeparationQuinaryWashMixes,
		(*145*)MagneticBeadSeparationQuinaryWashMixVolume -> preResolvedMagneticBeadSeparationQuinaryWashMixVolumes,
		(*146*)MagneticBeadSeparationQuinaryWashMixTemperature -> preResolvedMagneticBeadSeparationQuinaryWashMixTemperatures,
		(*147*)MagneticBeadSeparationQuinaryWashMixTipType -> preResolvedMagneticBeadSeparationQuinaryWashMixTipTypes,
		(*148*)MagneticBeadSeparationQuinaryWashMixTipMaterial -> preResolvedMagneticBeadSeparationQuinaryWashMixTipMaterials,
		(*149*)QuinaryWashMagnetizationTime -> preResolvedQuinaryWashMagnetizationTimes,
		(*150*)MagneticBeadSeparationQuinaryWashAspirationVolume -> preResolvedMagneticBeadSeparationQuinaryWashAspirationVolumes,
		(*151*)MagneticBeadSeparationQuinaryWashCollectionContainer -> preResolvedMagneticBeadSeparationQuinaryWashCollectionContainers,
		(*152*)MagneticBeadSeparationQuinaryWashCollectionStorageCondition -> preResolvedMagneticBeadSeparationQuinaryWashCollectionStorageConditions,
		(*153*)MagneticBeadSeparationQuinaryWashAirDry -> preResolvedMagneticBeadSeparationQuinaryWashAirDries,
		(*154*)MagneticBeadSeparationQuinaryWashAirDryTime -> preResolvedMagneticBeadSeparationQuinaryWashAirDryTimes,
		(*155*)NumberOfMagneticBeadSeparationQuinaryWashes -> preResolvedNumbersOfMagneticBeadSeparationQuinaryWashes,

		(*156*)MagneticBeadSeparationSenaryWash -> preResolvedMagneticBeadSeparationSenaryWashes,
		(*157*)MagneticBeadSeparationSenaryWashSolution -> preResolvedMagneticBeadSeparationSenaryWashSolutions,
		(*158*)MagneticBeadSeparationSenaryWashSolutionVolume -> preResolvedMagneticBeadSeparationSenaryWashSolutionVolumes,
		(*159*)MagneticBeadSeparationSenaryWashMix -> preResolvedMagneticBeadSeparationSenaryWashMixes,
		(*160*)MagneticBeadSeparationSenaryWashMixType -> preResolvedMagneticBeadSeparationSenaryWashMixTypes,
		(*161*)MagneticBeadSeparationSenaryWashMixTime -> preResolvedMagneticBeadSeparationSenaryWashMixTimes,
		(*162*)MagneticBeadSeparationSenaryWashMixRate -> preResolvedMagneticBeadSeparationSenaryWashMixRates,
		(*163*)NumberOfMagneticBeadSeparationSenaryWashMixes -> preResolvedNumbersOfMagneticBeadSeparationSenaryWashMixes,
		(*164*)MagneticBeadSeparationSenaryWashMixVolume -> preResolvedMagneticBeadSeparationSenaryWashMixVolumes,
		(*165*)MagneticBeadSeparationSenaryWashMixTemperature -> preResolvedMagneticBeadSeparationSenaryWashMixTemperatures,
		(*166*)MagneticBeadSeparationSenaryWashMixTipType -> preResolvedMagneticBeadSeparationSenaryWashMixTipTypes,
		(*167*)MagneticBeadSeparationSenaryWashMixTipMaterial -> preResolvedMagneticBeadSeparationSenaryWashMixTipMaterials,
		(*168*)SenaryWashMagnetizationTime -> preResolvedSenaryWashMagnetizationTimes,
		(*169*)MagneticBeadSeparationSenaryWashAspirationVolume -> preResolvedMagneticBeadSeparationSenaryWashAspirationVolumes,
		(*170*)MagneticBeadSeparationSenaryWashCollectionContainer -> preResolvedMagneticBeadSeparationSenaryWashCollectionContainers,
		(*171*)MagneticBeadSeparationSenaryWashCollectionStorageCondition -> preResolvedMagneticBeadSeparationSenaryWashCollectionStorageConditions,
		(*172*)MagneticBeadSeparationSenaryWashAirDry -> preResolvedMagneticBeadSeparationSenaryWashAirDries,
		(*173*)MagneticBeadSeparationSenaryWashAirDryTime -> preResolvedMagneticBeadSeparationSenaryWashAirDryTimes,
		(*174*)NumberOfMagneticBeadSeparationSenaryWashes -> preResolvedNumbersOfMagneticBeadSeparationSenaryWashes,

		(*175*)MagneticBeadSeparationSeptenaryWash -> preResolvedMagneticBeadSeparationSeptenaryWashes,
		(*176*)MagneticBeadSeparationSeptenaryWashSolution -> preResolvedMagneticBeadSeparationSeptenaryWashSolutions,
		(*177*)MagneticBeadSeparationSeptenaryWashSolutionVolume -> preResolvedMagneticBeadSeparationSeptenaryWashSolutionVolumes,
		(*178*)MagneticBeadSeparationSeptenaryWashMix -> preResolvedMagneticBeadSeparationSeptenaryWashMixes,
		(*179*)MagneticBeadSeparationSeptenaryWashMixType -> preResolvedMagneticBeadSeparationSeptenaryWashMixTypes,
		(*180*)MagneticBeadSeparationSeptenaryWashMixTime -> preResolvedMagneticBeadSeparationSeptenaryWashMixTimes,
		(*181*)MagneticBeadSeparationSeptenaryWashMixRate -> preResolvedMagneticBeadSeparationSeptenaryWashMixRates,
		(*182*)NumberOfMagneticBeadSeparationSeptenaryWashMixes -> preResolvedNumbersOfMagneticBeadSeparationSeptenaryWashMixes,
		(*183*)MagneticBeadSeparationSeptenaryWashMixVolume -> preResolvedMagneticBeadSeparationSeptenaryWashMixVolumes,
		(*184*)MagneticBeadSeparationSeptenaryWashMixTemperature -> preResolvedMagneticBeadSeparationSeptenaryWashMixTemperatures,
		(*185*)MagneticBeadSeparationSeptenaryWashMixTipType -> preResolvedMagneticBeadSeparationSeptenaryWashMixTipTypes,
		(*186*)MagneticBeadSeparationSeptenaryWashMixTipMaterial -> preResolvedMagneticBeadSeparationSeptenaryWashMixTipMaterials,
		(*187*)SeptenaryWashMagnetizationTime -> preResolvedSeptenaryWashMagnetizationTimes,
		(*188*)MagneticBeadSeparationSeptenaryWashAspirationVolume -> preResolvedMagneticBeadSeparationSeptenaryWashAspirationVolumes,
		(*189*)MagneticBeadSeparationSeptenaryWashCollectionContainer -> preResolvedMagneticBeadSeparationSeptenaryWashCollectionContainers,
		(*190*)MagneticBeadSeparationSeptenaryWashCollectionStorageCondition -> preResolvedMagneticBeadSeparationSeptenaryWashCollectionStorageConditions,
		(*191*)MagneticBeadSeparationSeptenaryWashAirDry -> preResolvedMagneticBeadSeparationSeptenaryWashAirDries,
		(*192*)MagneticBeadSeparationSeptenaryWashAirDryTime -> preResolvedMagneticBeadSeparationSeptenaryWashAirDryTimes,
		(*193*)NumberOfMagneticBeadSeparationSeptenaryWashes -> preResolvedNumbersOfMagneticBeadSeparationSeptenaryWashes,

		(*194*)MagneticBeadSeparationElution -> preResolvedMagneticBeadSeparationElutions,
		(*195*)MagneticBeadSeparationElutionSolution -> preResolvedMagneticBeadSeparationElutionSolutions,
		(*196*)MagneticBeadSeparationElutionSolutionVolume -> preResolvedMagneticBeadSeparationElutionSolutionVolumes,
		(*197*)MagneticBeadSeparationElutionMix -> preResolvedMagneticBeadSeparationElutionMixes,
		(*198*)MagneticBeadSeparationElutionMixType -> preResolvedMagneticBeadSeparationElutionMixTypes,
		(*199*)MagneticBeadSeparationElutionMixTime -> preResolvedMagneticBeadSeparationElutionMixTimes,
		(*200*)MagneticBeadSeparationElutionMixRate -> preResolvedMagneticBeadSeparationElutionMixRates,
		(*201*)NumberOfMagneticBeadSeparationElutionMixes -> preResolvedNumbersOfMagneticBeadSeparationElutionMixes,
		(*202*)MagneticBeadSeparationElutionMixVolume -> preResolvedMagneticBeadSeparationElutionMixVolumes,
		(*203*)MagneticBeadSeparationElutionMixTemperature -> preResolvedMagneticBeadSeparationElutionMixTemperatures,
		(*204*)MagneticBeadSeparationElutionMixTipType -> preResolvedMagneticBeadSeparationElutionMixTipTypes,
		(*205*)MagneticBeadSeparationElutionMixTipMaterial -> preResolvedMagneticBeadSeparationElutionMixTipMaterials,
		(*206*)ElutionMagnetizationTime -> preResolvedElutionMagnetizationTimes,
		(*207*)MagneticBeadSeparationElutionAspirationVolume -> preResolvedMagneticBeadSeparationElutionAspirationVolumes,
		(*208*)MagneticBeadSeparationElutionCollectionContainer -> preResolvedPackedMagneticBeadSeparationElutionCollectionContainers,
		(*209*)MagneticBeadSeparationElutionCollectionStorageCondition -> preResolvedMagneticBeadSeparationElutionCollectionStorageConditions,
		(*210*)NumberOfMagneticBeadSeparationElutions -> preResolvedNumbersOfMagneticBeadSeparationElutions,
		(*211*)MagneticBeadSeparationPreWashCollectionContainerLabel -> preResolvedMagneticBeadSeparationPreWashCollectionContainerLabels,
		(*212*)MagneticBeadSeparationEquilibrationCollectionContainerLabel ->preResolvedMagneticBeadSeparationEquilibrationCollectionContainerLabels,
		(*213*)MagneticBeadSeparationLoadingCollectionContainerLabel -> preResolvedMagneticBeadSeparationLoadingCollectionContainerLabels,
		(*214*)MagneticBeadSeparationWashCollectionContainerLabel -> preResolvedMagneticBeadSeparationWashCollectionContainerLabels,
		(*215*)MagneticBeadSeparationSecondaryWashCollectionContainerLabel -> preResolvedMagneticBeadSeparationSecondaryWashCollectionContainerLabels,
		(*216*)MagneticBeadSeparationTertiaryWashCollectionContainerLabel -> preResolvedMagneticBeadSeparationTertiaryWashCollectionContainerLabels,
		(*217*)MagneticBeadSeparationQuaternaryWashCollectionContainerLabel -> preResolvedMagneticBeadSeparationQuaternaryWashCollectionContainerLabels,
		(*218*)MagneticBeadSeparationQuinaryWashCollectionContainerLabel -> preResolvedMagneticBeadSeparationQuinaryWashCollectionContainerLabels,
		(*219*)MagneticBeadSeparationSenaryWashCollectionContainerLabel ->preResolvedMagneticBeadSeparationSenaryWashCollectionContainerLabels,
		(*220*)MagneticBeadSeparationSeptenaryWashCollectionContainerLabel -> preResolvedMagneticBeadSeparationSeptenaryWashCollectionContainerLabels,
		(*221*)MagneticBeadSeparationElutionCollectionContainerLabel -> preResolvedMagneticBeadSeparationElutionCollectionContainerLabels
	}

];


(* ::Subsection::Closed:: *)
(*magneticBeadSeparationSharedOptionsUnitTests*)

(* NOTE: Tests written with the assumption of 0.2 mL samples. *)
magneticBeadSeparationSharedOptionsUnitTests[myFunction_Symbol, previouslyExtractedSampleInPlate: ObjectP[Object[Sample]], lysateSample:ObjectP[Object[Sample]]] :=
		{

			(* Basic Example *)
			Example[{Basic, "Crude samples can be purified with magnetic bead separation:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> MagneticBeadSeparation,
					Output->Result
				],
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSelectionStrategy Tests -- *)
			Example[{Options,MagneticBeadSeparationSelectionStrategy, "MagneticBeadSeparationSelectionStrategy is set to Positive by default:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> MagneticBeadSeparation,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSelectionStrategy -> Positive
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationMode Tests -- *)
			(* NOTE:This test should be customized to your specific experiment if copied in. *)
			Example[{Options,MagneticBeadSeparationMode, "MagneticBeadSeparationMode is set based on the target of the purification (non-protein cellular component is NormalPhase, protein is IonExchange, otherwise set to Affinity):"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> MagneticBeadSeparation,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationMode -> Except[Null]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSampleVolume Tests -- *)
			Example[{Options, MagneticBeadSeparationSampleVolume, "If the volume of the sample is less than 50% of the max volume of the container, then all of the sample will be used as the MagneticBeadSeparationSampleVolume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> MagneticBeadSeparation,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSampleVolume -> EqualP[0.2 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationAnalyteAffinityLabel Tests -- *)
			(* NOTE:This test should be customized to your specific experiment if copied in. *)
			(* You may get Warning::GeneralResolvedMagneticBeads for your experiment, indicating we don't have a bead reccomendation for the combination of target and separation mode.*)
			Example[{Options, MagneticBeadSeparationAnalyteAffinityLabel, "MagneticBeadSeparationAnalyteAffinityLabel is automatically set to the first item in Analytes of the sample if SeparationMode is set to Affinity:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationMode -> Affinity,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationAnalyteAffinityLabel -> Except[Null]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadAffinityLabel Tests -- *)
			(* NOTE:This test should be customized to your specific experiment if copied in (will be Null for non-molecules like DNA/RNA). *)
			Example[{Options, MagneticBeadAffinityLabel, "If MagneticBeadSeparationMode is set to Affinity, MagneticBeadAffinityLabel is automatically set to the first item in the Targets field of the target molecule object:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationMode -> Affinity,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadAffinityLabel -> Null
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeads Tests -- *)
			(* NOTE:This test should be customized to your specific experiment if copied in. *)
			Example[{Options, MagneticBeads, "If MagneticBeadSeparationMode is set to Affinity, MagneticBeads is automatically set to the first found magnetic beads model with the affinity label of MagneticBeadAffinityLabel:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationMode -> Affinity,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeads -> Except[Null]
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeads, "If MagneticBeadSeparationMode is not set to Affinity, MagneticBeads is automatically set based on the MagneticBeadSeparationMode and the target of the :"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationMode -> NormalPhase,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeads -> Except[Null]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadVolume Tests -- *)
			Example[{Options, MagneticBeadVolume, "MagneticBeadVolume is automatically set to 1/10 of the MagneticBeadSeparationSampleVolume if not otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> MagneticBeadSeparation,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadVolume -> EqualP[0.02 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadCollectionStorageCondition Tests -- *)
			Example[{Options, MagneticBeadCollectionStorageCondition, "MagneticBeadCollectionStorageCondition is automatically set to Disposal if not otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> MagneticBeadSeparation,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadCollectionStorageCondition -> Disposal
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagnetizationRack Tests -- *)
			Example[{Options, MagnetizationRack, "MagnetizationRack is automatically set to Model[Item, MagnetizationRack, \"Alpaqua 96S Super Magnet 96-well Plate Rack\"] if not otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> MagneticBeadSeparation,
					Output->Options
				],
				KeyValuePattern[
					{
						MagnetizationRack -> ObjectP[Model[Item, MagnetizationRack, "Alpaqua 96S Super Magnet 96-well Plate Rack"]]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationPreWashCollectionContainerLabel Tests -- *)
			Example[{Options, MagneticBeadSeparationPreWashCollectionContainerLabel, "If MagneticBeadSeparationPreWash is set to True, MagneticBeadSeparationPreWashCollectionContainerLabel is automatically generated unless otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationPreWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationPreWashCollectionContainerLabel -> {(_String)}
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationEquilibrationCollectionContainerLabel Tests -- *)
			Example[{Options, MagneticBeadSeparationEquilibrationCollectionContainerLabel, "If MagneticBeadSeparationEquilibration is set to True, MagneticBeadSeparationEquilibrationCollectionContainerLabel is automatically generated unless otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationEquilibration -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationEquilibrationCollectionContainerLabel -> {(_String)}
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationLoadingCollectionContainerLabel Tests -- *)
			Example[{Options, MagneticBeadSeparationLoadingCollectionContainerLabel, "MagneticBeadSeparationLoadingCollectionContainerLabel is automatically generated unless otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> MagneticBeadSeparation,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationLoadingCollectionContainerLabel -> {(_String)}
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationWashCollectionContainerLabel Tests -- *)
			Example[{Options, MagneticBeadSeparationWashCollectionContainerLabel, "If MagneticBeadSeparationWash is set to True, MagneticBeadSeparationWashCollectionContainerLabel is automatically generated unless otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationWashCollectionContainerLabel -> {(_String)}
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSecondaryWashCollectionContainerLabel Tests -- *)
			Example[{Options, MagneticBeadSeparationSecondaryWashCollectionContainerLabel, "If MagneticBeadSeparationSecondaryWash is set to True, MagneticBeadSeparationSecondaryWashCollectionContainerLabel is automatically generated unless otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSecondaryWash -> True,
					(* Prior washes need to be True to avoid error. *)
					MagneticBeadSeparationWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSecondaryWashCollectionContainerLabel -> {(_String)}
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationTertiaryWashCollectionContainerLabel Tests -- *)
			Example[{Options, MagneticBeadSeparationTertiaryWashCollectionContainerLabel, "If MagneticBeadSeparationTertiaryWash is set to True, MagneticBeadSeparationTertiaryWashCollectionContainerLabel is automatically generated unless otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationTertiaryWash -> True,
					(* Prior washes need to be True to avoid error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationTertiaryWashCollectionContainerLabel -> {(_String)}
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationQuaternaryWashCollectionContainerLabel Tests -- *)
			Example[{Options, MagneticBeadSeparationQuaternaryWashCollectionContainerLabel, "If MagneticBeadSeparationQuaternaryWash is set to True, MagneticBeadSeparationQuaternaryWashCollectionContainerLabel is automatically generated unless otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuaternaryWash -> True,
					(* Prior washes need to be True to avoid error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuaternaryWashCollectionContainerLabel -> {(_String)}
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationQuinaryWashCollectionContainerLabel Tests -- *)
			Example[{Options, MagneticBeadSeparationQuinaryWashCollectionContainerLabel, "If MagneticBeadSeparationQuinaryWash is set to True, MagneticBeadSeparationQuinaryWashCollectionContainerLabel is automatically generated unless otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuinaryWash -> True,
					(* Prior washes need to be True to avoid error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuinaryWashCollectionContainerLabel -> {(_String)}
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSenaryWashCollectionContainerLabel Tests -- *)
			Example[{Options, MagneticBeadSeparationSenaryWashCollectionContainerLabel, "If MagneticBeadSeparationSenaryWash is set to True, MagneticBeadSeparationSenaryWashCollectionContainerLabel is automatically generated unless otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSenaryWash -> True,
					(* Prior washes need to be True to avoid error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSenaryWashCollectionContainerLabel -> {(_String)}
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSeptenaryWashCollectionContainerLabel Tests -- *)
			Example[{Options, MagneticBeadSeparationSeptenaryWashCollectionContainerLabel, "If MagneticBeadSeparationSeptenaryWash is set to True, MagneticBeadSeparationSeptenaryWashCollectionContainerLabel is automatically generated unless otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSeptenaryWash -> True,
					(* Prior washes need to be True to avoid error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					MagneticBeadSeparationSenaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSeptenaryWashCollectionContainerLabel -> {(_String)}
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationElutionCollectionContainerLabel Tests -- *)
			Example[{Options, MagneticBeadSeparationElutionCollectionContainerLabel, "If MagneticBeadSeparationElution is set to True, MagneticBeadSeparationElutionCollectionContainerLabel is automatically generated unless otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationElution -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationElutionCollectionContainerLabel -> {(_String)}
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationPreWash Tests -- *)
			Example[{Options, MagneticBeadSeparationPreWash, "If other magnetic bead separation prewash options are set, then MagneticBeadSeparationPreWash is automatically set to True:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationPreWashMix -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationPreWash -> True
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationPreWash, "If no magnetic bead separation prewash options are set, then MagneticBeadSeparationPreWash is automatically set to False:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> MagneticBeadSeparation,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationPreWash -> False
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationPreWashSolution Tests -- *)
			Example[{Options, MagneticBeadSeparationPreWashSolution, "If MagneticBeadSeparationPreWash is set to True, MagneticBeadSeparationPreWashSolution is automatically set to match the MagneticBeadSeparationElutionSolution:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationPreWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationPreWashSolution -> ObjectP[]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationPreWashSolutionVolume Tests -- *)
			Example[{Options, MagneticBeadSeparationPreWashSolutionVolume, "If MagneticBeadSeparationPreWash is set to True, MagneticBeadSeparationPreWashSolutionVolume is automatically set to the sample volume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationPreWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationPreWashSolutionVolume -> EqualP[0.2 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationPreWashMix Tests -- *)
			Example[{Options, MagneticBeadSeparationPreWashMix, "If MagneticBeadSeparationPreWash is set to True, MagneticBeadSeparationPreWashMix is automatically set to True:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationPreWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationPreWashMix -> True
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationPreWashMixType Tests -- *)
			Example[{Options, MagneticBeadSeparationPreWashMixType, "If MagneticBeadSeparationPreWashMix is set to True and shaking options are set, MagneticBeadSeparationPreWashMixType is automatically set to Shake:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationPreWashMixRate -> 200 RPM,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationPreWashMixType -> Shake
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationPreWashMixType, "If MagneticBeadSeparationPreWashMix is set to True and pipetting options are set, MagneticBeadSeparationPreWashMixType is automatically set to Pipette:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationPreWashMixVolume -> 0.1 Milliliter,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationPreWashMixType -> Pipette
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationPreWashMixType, "If MagneticBeadSeparationPreWashMix is set to True and no other mix options are set, MagneticBeadSeparationPreWashMixType is automatically set to Pipette:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationPreWashMix -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationPreWashMixType -> Pipette
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationPreWashMixTime Tests -- *)
			Example[{Options, MagneticBeadSeparationPreWashMixTime, "If MagneticBeadSeparationPreWashMixType is set to Shake, MagneticBeadSeparationPreWashMixTime is automatically set to 5 Minute:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationPreWashMixType -> Shake,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationPreWashMixTime -> EqualP[5 Minute]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- NumberOfMagneticBeadSeparationPreWashMixes Tests -- *)
			Example[{Options, NumberOfMagneticBeadSeparationPreWashMixes, "If MagneticBeadSeparationPreWashMixType is set to Pipette, NumberOfMagneticBeadSeparationPreWashMixes is automatically set to 10:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationPreWashMixType -> Pipette,
							Output->Options
				],
				KeyValuePattern[
					{
						NumberOfMagneticBeadSeparationPreWashMixes -> 10
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationPreWashMixVolume Tests -- *)
			Example[{Options, MagneticBeadSeparationPreWashMixVolume, "If MagneticBeadSeparationPreWashMixType is set to Pipette and 50% of the combined MagneticBeadSeparationPreWashSolutionVolume and magnetic beads volume is less than the MaxRoboticSingleTransferVolume (0.970 mL), MagneticBeadSeparationPreWashMixVolume is automatically set to 50% of the combined MagneticBeadSeparationPreWashSolutionVolume and magnetic beads volume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationPreWashMixType -> Pipette,
					MagneticBeadVolume -> 0.2 Milliliter,
					MagneticBeadSeparationPreWashSolutionVolume -> 0.2 Milliliter,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationPreWashMixVolume -> EqualP[0.2 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationPreWashMixVolume, "If MagneticBeadSeparationPreWashMixType is set to Pipette and 50% of the combined MagneticBeadSeparationPreWashSolutionVolume and magnetic beads volume is greater than the MaxRoboticSingleTransferVolume (0.970 mL), MagneticBeadSeparationPreWashMixVolume is automatically set to the MaxRoboticSingleTransferVolume (0.970 mL):"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationPreWashMixType -> Pipette,
					MagneticBeadVolume -> 1.0 Milliliter,
					MagneticBeadSeparationPreWashSolutionVolume -> 1.0 Milliliter,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationPreWashMixVolume -> EqualP[0.970 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationPreWashMixTemperature Tests -- *)
			Example[{Options, MagneticBeadSeparationPreWashMixTemperature, "If MagneticBeadSeparationPreWashMix is True, MagneticBeadSeparationPreWashMixTemperature is automatically set to Ambient unless otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationPreWashMix -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationPreWashMixTemperature -> Ambient
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationPreWashMixTipType Tests -- *)
			Example[{Options, MagneticBeadSeparationPreWashMixTipType, "If MagneticBeadSeparationPreWashMixType is set to Pipette, MagneticBeadSeparationPreWashMixTipType is automatically set to WideBore unless otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationPreWashMixType -> Pipette,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationPreWashMixTipType -> WideBore
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationPreWashMixTipMaterial Tests -- *)
			Example[{Options, MagneticBeadSeparationPreWashMixTipMaterial, "If MagneticBeadSeparationPreWashMixType is set to Pipette, MagneticBeadSeparationPreWashMixTipMaterial is automatically set to Polypropylene unless otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationPreWashMixType -> Pipette,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationPreWashMixTipMaterial -> Polypropylene
					}
				],
				TimeConstraint -> 1800
			],

			(* -- PreWashMagnetizationTime Tests -- *)
			Example[{Options, PreWashMagnetizationTime, "If MagneticBeadSeparationPreWash is True, PreWashMagnetizationTime is automatically set to 5 minutes unless otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationPreWashMix -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						PreWashMagnetizationTime -> EqualP[5 Minute]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationPreWashAspirationVolume Tests -- *)
			Example[{Options, MagneticBeadSeparationPreWashAspirationVolume, "If MagneticBeadSeparationPreWash is True, MagneticBeadSeparationPreWashAspirationVolume is automatically set to the MagneticBeadSeparationPreWashSolutionVolume unless otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationPreWashSolutionVolume -> 0.2 Milliliter,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationPreWashAspirationVolume -> EqualP[0.2 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationPreWashCollectionContainer Tests -- *)
			Example[{Options, MagneticBeadSeparationPreWashCollectionContainer, "If MagneticBeadSeparationPreWash is True, MagneticBeadSeparationPreWashCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationPreWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationPreWashCollectionContainer -> {{"A1",ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}}
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationPreWashCollectionStorageCondition Tests -- *)
			Example[{Options, MagneticBeadSeparationPreWashCollectionStorageCondition, "If MagneticBeadSeparationPreWash is True, MagneticBeadSeparationPreWashCollectionStorageCondition is automatically set to Refrigerator unless otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationPreWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationPreWashCollectionStorageCondition -> Refrigerator
					}
				],
				TimeConstraint -> 1800
			],

			(* -- NumberOfMagneticBeadSeparationPreWashes Tests -- *)
			Example[{Options, NumberOfMagneticBeadSeparationPreWashes, "If MagneticBeadSeparationPreWash is True, NumberOfMagneticBeadSeparationPreWashes is automatically set to 1 unless otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationPreWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						NumberOfMagneticBeadSeparationPreWashes -> 1
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationPreWashAirDry Tests -- *)
			Example[{Options, MagneticBeadSeparationPreWashAirDry, "If MagneticBeadSeparationPreWash is True, MagneticBeadSeparationPreWashAirDry is automatically set to False unless otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationPreWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationPreWashAirDry -> False
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationPreWashAirDryTime Tests -- *)
			Example[{Options, MagneticBeadSeparationPreWashAirDryTime, "If MagneticBeadSeparationPreWashAirDry is True, MagneticBeadSeparationPreWashAirDryTime is automatically set to 1 Minute:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationPreWashAirDry -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationPreWashAirDryTime -> EqualP[1 Minute]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationEquilibration Tests -- *)
			Example[{Options, MagneticBeadSeparationEquilibration, "If any magnetic bead separation equilibration options are set (MagneticBeadSeparationEquilibrationSolution, MagneticBeadSeparationEquilibrationSolutionVolume, MagneticBeadSeparationEquilibrationMix, etc.), MagneticBeadSeparationEquilibration is automatically set to True:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationEquilibrationMixType -> Shake,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationEquilibration -> True
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationEquilibration, "If no magnetic bead separation equilibration options are set (MagneticBeadSeparationEquilibrationSolution, MagneticBeadSeparationEquilibrationSolutionVolume, MagneticBeadSeparationEquilibrationMix, etc.), MagneticBeadSeparationEquilibration is automatically set to False:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationEquilibrationMixType -> Shake,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationEquilibration -> True
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationEquilibrationSolution Tests -- *)
			Example[{Options, MagneticBeadSeparationEquilibrationSolution, "If MagneticBeadSeparationEquilibration is set to True, MagneticBeadSeparationEquilibrationSolution is automatically set to Model[Sample,\"Milli-Q water\"]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationEquilibration -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationEquilibrationSolution -> ObjectP[Model[Sample,"Milli-Q water"]]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationEquilibrationSolutionVolume Tests -- *)
			Example[{Options, MagneticBeadSeparationEquilibrationSolutionVolume, "If MagneticBeadSeparationEquilibration is set to True, MagneticBeadSeparationEquilibrationSolutionVolume is automatically set to the same value as the MagneticBeadSeparationPreWashSolutionVolume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationEquilibration -> True,
					MagneticBeadSeparationPreWashSolutionVolume -> 0.1 Milliliter,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationEquilibrationSolutionVolume -> EqualP[0.1 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationEquilibrationMix Tests -- *)
			Example[{Options, MagneticBeadSeparationEquilibrationMix, "If MagneticBeadSeparationEquilibration is set to True, MagneticBeadSeparationEquilibrationMix is automatically set to True:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationEquilibration -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationEquilibrationMix -> True
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationEquilibrationMixType Tests -- *)
			Example[{Options, MagneticBeadSeparationEquilibrationMixType, "If MagneticBeadSeparationEquilibrationMixRate or MagneticBeadSeparationEquilibrationMixTime are set, MagneticBeadSeparationEquilibrationMixType is automatically set to Shake:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationEquilibrationMixTime -> 1 Minute,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationEquilibrationMixType -> Shake
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationEquilibrationMixType, "If NumberOfMagneticBeadSeparationEquilibrationMixes or MagneticBeadSeparationEquilibrationMixVolume are set, MagneticBeadSeparationEquilibrationMixType is automatically set to Pipette:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					NumberOfMagneticBeadSeparationEquilibrationMixes -> 10,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationEquilibrationMixType -> Pipette
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationEquilibrationMixType, "If no magnetic bead separation equilibration mix options are set, MagneticBeadSeparationEquilibrationMixType is automatically set to Pipette:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationEquilibrationMix -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationEquilibrationMixType -> Pipette
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationEquilibrationMixTime Tests -- *)
			Example[{Options, MagneticBeadSeparationEquilibrationMixTime, "If MagneticBeadSeparationEquilibrationMixType is set to Shake, MagneticBeadSeparationEquilibrationMixTime is automatically set to 5 minutes:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationEquilibrationMixType -> Shake,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationEquilibrationMixTime -> EqualP[5 Minute]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationEquilibrationMixRate Tests -- *)
			Example[{Options, MagneticBeadSeparationEquilibrationMixRate, "If MagneticBeadSeparationEquilibrationMixType is set to Shake, MagneticBeadSeparationEquilibrationMixRate is automatically set to 300 RPM:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationEquilibrationMixType -> Shake,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationEquilibrationMixRate -> EqualP[300 RPM]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- NumberOfMagneticBeadSeparationEquilibrationMixes Tests -- *)
			Example[{Options, NumberOfMagneticBeadSeparationEquilibrationMixes, "If MagneticBeadSeparationEquilibrationMixType is set to Pipette, NumberOfMagneticBeadSeparationEquilibrationMixes is automatically set to 10:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationEquilibrationMixType -> Pipette,
					Output->Options
				],
				KeyValuePattern[
					{
						NumberOfMagneticBeadSeparationEquilibrationMixes -> 10
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationEquilibrationMixVolume Tests -- *)
			Example[{Options, MagneticBeadSeparationEquilibrationMixVolume, "If MagneticBeadSeparationEquilibrationMixType is set to Pipette and 1/2 of the combined MagneticBeadSeparationEquilibrationSolution and magnetic beads volume is less than 970 microliters, MagneticBeadSeparationEquilibrationMixVolume is automatically set to 1/2 of the combined MagneticBeadSeparationEquilibrationSolution and magnetic beads volume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationEquilibrationMixType -> Pipette,
					MagneticBeadVolume -> 0.2 Milliliter,
					MagneticBeadSeparationEquilibrationSolutionVolume -> 0.2 Milliliter,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationEquilibrationMixVolume -> EqualP[0.2 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationEquilibrationMixVolume, "If MagneticBeadSeparationEquilibrationMixType is set to Pipette and 1/2 of the combined MagneticBeadSeparationEquilibrationSolution and magnetic beads volume is greater than 970 microliters, MagneticBeadSeparationEquilibrationMixVolume is automatically set to 970 microliters:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationEquilibrationMixType -> Pipette,
					MagneticBeadSeparationEquilibrationSolutionVolume -> 1.8 Milliliter,
					MagneticBeadVolume -> 0.2 Milliliter,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationEquilibrationMixVolume -> EqualP[0.970 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationEquilibrationMixTemperature Tests -- *)
			Example[{Options, MagneticBeadSeparationEquilibrationMixTemperature, "If MagneticBeadSeparationEquilibrationMix is set to True, MagneticBeadSeparationEquilibrationMixTemperature is automatically set to Ambient:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationEquilibrationMix -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationEquilibrationMixTemperature -> Ambient
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationEquilibrationMixTipType Tests -- *)
			Example[{Options, MagneticBeadSeparationEquilibrationMixTipType, "If MagneticBeadSeparationEquilibrationMixType is set to Pipette, MagneticBeadSeparationEquilibrationMixTipType is automatically set to WideBore:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationEquilibrationMixType -> Pipette,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationEquilibrationMixTipType -> WideBore
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationEquilibrationMixTipMaterial Tests -- *)
			Example[{Options, MagneticBeadSeparationEquilibrationMixTipMaterial, "If MagneticBeadSeparationEquilibrationMixType is set to Pipette, MagneticBeadSeparationEquilibrationMixTipMaterial is automatically set to Polypropylene:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationEquilibrationMixType -> Pipette,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationEquilibrationMixTipMaterial -> Polypropylene
					}
				],
				TimeConstraint -> 1800
			],

			(* -- EquilibrationMagnetizationTime Tests -- *)
			Example[{Options, EquilibrationMagnetizationTime, "If MagneticBeadSeparationEquilibration is set to True, EquilibrationMagnetizationTime is automatically set to 5 minutes:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationEquilibration -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						EquilibrationMagnetizationTime -> EqualP[5 Minute]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationEquilibrationAspirationVolume Tests -- *)
			Example[{Options, MagneticBeadSeparationEquilibrationAspirationVolume, "If MagneticBeadSeparationEquilibration is set to True, MagneticBeadSeparationEquilibrationAspirationVolume is automatically set the same as the MagneticBeadSeparationEquilibrationSolutionVolume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationEquilibration -> True,
					MagneticBeadSeparationEquilibrationSolutionVolume -> 0.2 Milliliter,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationEquilibrationAspirationVolume -> EqualP[0.2 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationEquilibrationCollectionContainer Tests -- *)
			Example[{Options, MagneticBeadSeparationEquilibrationCollectionContainer, "If MagneticBeadSeparationEquilibration is set to True, MagneticBeadSeparationEquilibrationCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationEquilibration -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationEquilibrationCollectionContainer -> {(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationEquilibrationCollectionStorageCondition Tests -- *)
			Example[{Options, MagneticBeadSeparationEquilibrationCollectionStorageCondition, "If MagneticBeadSeparationEquilibration is set to True, MagneticBeadSeparationEquilibrationCollectionStorageCondition is automatically set to Refrigerator unless otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationEquilibration -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationEquilibrationCollectionStorageCondition -> Refrigerator
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationEquilibrationAirDry Tests -- *)
			Example[{Options, MagneticBeadSeparationEquilibrationAirDry, "If MagneticBeadSeparationEquilibration is set to True, MagneticBeadSeparationEquilibrationAirDry is automatically set to False:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationEquilibration -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationEquilibrationAirDry -> False
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationEquilibrationAirDryTime Tests -- *)
			Example[{Options, MagneticBeadSeparationEquilibrationAirDryTime, "If MagneticBeadSeparationEquilibrationAirDry is set to True, MagneticBeadSeparationEquilibrationAirDryTime is automatically set to 1 Minute:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationEquilibrationAirDry -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationEquilibrationAirDryTime -> EqualP[1 Minute]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationLoadingMix Tests -- *)
			Example[{Options, MagneticBeadSeparationLoadingMix, "MagneticBeadSeparationLoadingMix is automatically set to True unless otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> MagneticBeadSeparation,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationLoadingMix -> True
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationLoadingMixType Tests -- *)
			Example[{Options, MagneticBeadSeparationLoadingMixType, "If MagneticBeadSeparationLoadingMixRate or MagneticBeadSeparationLoadingMixTime are set, MagneticBeadSeparationLoadingMixType is automatically set to Shake:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationLoadingMixTime -> 1 Minute,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationLoadingMixType -> Shake
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationLoadingMixType, "If NumberOfMagneticBeadSeparationLoadingMixes or MagneticBeadSeparationLoadingMixVolume are set, MagneticBeadSeparationLoadingMixType is automatically set to Pipette:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					NumberOfMagneticBeadSeparationLoadingMixes -> 10,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationLoadingMixType -> Pipette
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationLoadingMixType, "If no magnetic bead separation equilibration mix options are set, MagneticBeadSeparationLoadingMixType is automatically set to Pipette:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationLoadingMix -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationLoadingMixType -> Pipette
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationLoadingMixTime Tests -- *)
			Example[{Options, MagneticBeadSeparationLoadingMixTime, "If MagneticBeadSeparationLoadingMixType is set to Shake, MagneticBeadSeparationLoadingMixTime is automatically set to 5 minutes:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationLoadingMixType -> Shake,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationLoadingMixTime -> EqualP[5 Minute]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationLoadingMixRate Tests -- *)
			Example[{Options, MagneticBeadSeparationLoadingMixRate, "If MagneticBeadSeparationLoadingMixType is set to Shake, MagneticBeadSeparationLoadingMixRate is automatically set to 300 RPM:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationLoadingMixType -> Shake,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationLoadingMixRate -> EqualP[300 RPM]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- NumberOfMagneticBeadSeparationLoadingMixes Tests -- *)
			Example[{Options, NumberOfMagneticBeadSeparationLoadingMixes, "If MagneticBeadSeparationLoadingMixType is set to Pipette, NumberOfMagneticBeadSeparationLoadingMixes is automatically set to 10:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationLoadingMixType -> Pipette,
					Output->Options
				],
				KeyValuePattern[
					{
						NumberOfMagneticBeadSeparationLoadingMixes -> 10
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationLoadingMixVolume Tests -- *)
			Example[{Options, MagneticBeadSeparationLoadingMixVolume, "If MagneticBeadSeparationLoadingMixType is set to Pipette and 50% of the MagneticBeadSeparationSampleVolume is less than 970 microliters, MagneticBeadSeparationLoadingMixVolume is automatically set to 50% of the MagneticBeadSeparationSampleVolume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationLoadingMixType -> Pipette,
					MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
					MagneticBeadVolume -> 0.02 Milliliter,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationLoadingMixVolume -> EqualP[0.11 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationLoadingMixVolume, "If MagneticBeadSeparationLoadingMixType is set to Pipette and set to 50% of the MagneticBeadSeparationSampleVolume is greater than 970 microliters, MagneticBeadSeparationLoadingMixVolume is automatically set to 970 microliters:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationLoadingMixType -> Pipette,
					MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
					MagneticBeadVolume -> 1.8 Milliliter,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationLoadingMixVolume -> EqualP[0.970 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationLoadingMixTemperature Tests -- *)
			Example[{Options, MagneticBeadSeparationLoadingMixTemperature, "If MagneticBeadSeparationLoadingMix is set to True, MagneticBeadSeparationLoadingMixTemperature is automatically set to Ambient:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationLoadingMix -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationLoadingMixTemperature -> Ambient
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationLoadingMixTipType Tests -- *)
			Example[{Options, MagneticBeadSeparationLoadingMixTipType, "If MagneticBeadSeparationLoadingMixType is set to Pipette, MagneticBeadSeparationLoadingMixTipType is automatically set to WideBore:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationLoadingMixType -> Pipette,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationLoadingMixTipType -> WideBore
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationLoadingMixTipMaterial Tests -- *)
			Example[{Options, MagneticBeadSeparationLoadingMixTipMaterial, "If MagneticBeadSeparationLoadingMixType is set to Pipette, MagneticBeadSeparationLoadingMixTipMaterial is automatically set to Polypropylene:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationLoadingMixType -> Pipette,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationLoadingMixTipMaterial -> Polypropylene
					}
				],
				TimeConstraint -> 1800
			],

			(* -- LoadingMagnetizationTime Tests -- *)
			Example[{Options, LoadingMagnetizationTime, "LoadingMagnetizationTime is automatically set to 5 minutes unless otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> MagneticBeadSeparation,
					Output->Options
				],
				KeyValuePattern[
					{
						LoadingMagnetizationTime -> EqualP[5 Minute]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationLoadingAspirationVolume Tests -- *)
			Example[{Options, MagneticBeadSeparationLoadingAspirationVolume, "MagneticBeadSeparationLoadingAspirationVolume is automatically set the same as the MagneticBeadSeparationSampleVolume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationLoadingAspirationVolume -> EqualP[0.2 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationLoadingCollectionContainer Tests -- *)
			Example[{Options, MagneticBeadSeparationLoadingCollectionContainer, "MagneticBeadSeparationLoadingCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"] unless otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> MagneticBeadSeparation,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationLoadingCollectionContainer -> {(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationLoadingCollectionStorageCondition Tests -- *)
			Example[{Options, MagneticBeadSeparationLoadingCollectionStorageCondition, "MagneticBeadSeparationLoadingCollectionStorageCondition is automatically set to Refrigerator unless otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> MagneticBeadSeparation,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationLoadingCollectionStorageCondition -> Refrigerator
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationLoadingAirDry Tests -- *)
			Example[{Options, MagneticBeadSeparationLoadingAirDry, "MagneticBeadSeparationLoadingAirDry is automatically set to False unless otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> MagneticBeadSeparation,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationLoadingAirDry -> False
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationLoadingAirDryTime Tests -- *)
			Example[{Options, MagneticBeadSeparationLoadingAirDryTime, "If MagneticBeadSeparationLoadingAirDry is set to True, MagneticBeadSeparationLoadingAirDryTime is automatically set to 1 Minute:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationLoadingAirDry -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationLoadingAirDryTime -> EqualP[1 Minute]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationWash Tests -- *)
			Example[{Options, MagneticBeadSeparationWash, "If any magnetic bead separation wash options are set (MagneticBeadSeparationWashSolution, MagneticBeadSeparationWashSolutionVolume, MagneticBeadSeparationWashMix, etc.), MagneticBeadSeparationWash is automatically set to True:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationWashMixType -> Shake,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationWash -> True
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationWash, "If no magnetic bead separation wash options are set (MagneticBeadSeparationWashSolution, MagneticBeadSeparationWashSolutionVolume, MagneticBeadSeparationWashMix, etc.), MagneticBeadSeparationWash is automatically set to False:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> MagneticBeadSeparation,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationWash -> False
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationWashSolution Tests -- *)
			Example[{Options, MagneticBeadSeparationWashSolution, "If MagneticBeadSeparationWash is set to True, MagneticBeadSeparationWashSolution is automatically set to Model[Sample,\"Milli-Q water\"]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationWashSolution -> ObjectP[Model[Sample,"Milli-Q water"]]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationWashSolutionVolume Tests -- *)
			Example[{Options, MagneticBeadSeparationWashSolutionVolume, "If MagneticBeadSeparationWash is set to True, MagneticBeadSeparationWashSolution is automatically set to the same value as the MagneticBeadSeparationPreWashSolutionVolume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationPreWashSolutionVolume -> 0.1 Milliliter,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationWashSolutionVolume -> EqualP[0.1 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationWashMix Tests -- *)
			Example[{Options, MagneticBeadSeparationWashMix, "If MagneticBeadSeparationWash is set to True, MagneticBeadSeparationWashMix is automatically set to True:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationWashMix -> True
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationWashMixType Tests -- *)
			Example[{Options, MagneticBeadSeparationWashMixType, "If MagneticBeadSeparationWashMixRate or MagneticBeadSeparationWashMixTime are set, MagneticBeadSeparationWashMixType is automatically set to Shake:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationWashMixTime -> 1 Minute,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationWashMixType -> Shake
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationWashMixType, "If NumberOfMagneticBeadSeparationWashMixes or MagneticBeadSeparationWashMixVolume are set, MagneticBeadSeparationWashMixType is automatically set to Pipette:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					NumberOfMagneticBeadSeparationWashMixes -> 10,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationWashMixType -> Pipette
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationWashMixType, "If no magnetic bead separation equilibration mix options are set, MagneticBeadSeparationWashMixType is automatically set to Pipette:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationWashMix -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationWashMixType -> Pipette
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationWashMixTime Tests -- *)
			Example[{Options, MagneticBeadSeparationWashMixTime, "If MagneticBeadSeparationWashMixType is set to Shake, MagneticBeadSeparationWashMixTime is automatically set to 5 minutes:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationWashMixType -> Shake,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationWashMixTime -> EqualP[5 Minute]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationWashMixRate Tests -- *)
			Example[{Options, MagneticBeadSeparationWashMixRate, "If MagneticBeadSeparationWashMixType is set to Shake, MagneticBeadSeparationWashMixRate is automatically set to 300 RPM:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationWashMixType -> Shake,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationWashMixRate -> EqualP[300 RPM]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- NumberOfMagneticBeadSeparationWashMixes Tests -- *)
			Example[{Options, NumberOfMagneticBeadSeparationWashMixes, "If MagneticBeadSeparationWashMixType is set to Pipette, NumberOfMagneticBeadSeparationWashMixes is automatically set to 10:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationWashMixType -> Pipette,
					Output->Options
				],
				KeyValuePattern[
					{
						NumberOfMagneticBeadSeparationWashMixes -> 10
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationWashMixVolume Tests -- *)
			Example[{Options, MagneticBeadSeparationWashMixVolume, "If MagneticBeadSeparationWashMixType is set to Pipette and 1/2 of the combined MagneticBeadSeparationWashSolution and magnetic beads volume is less than 970 microliters, MagneticBeadSeparationWashMixVolume is automatically set to 1/2 of the combined MagneticBeadSeparationWashSolution and magnetic beads volume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationWashMixType -> Pipette,
					MagneticBeadVolume -> 0.2 Milliliter,
					MagneticBeadSeparationWashSolutionVolume -> 0.2 Milliliter,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationWashMixVolume -> EqualP[0.2 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationWashMixVolume, "If MagneticBeadSeparationWashMixType is set to Pipette and 1/2 of the combined MagneticBeadSeparationWashSolution and magnetic beads volume is greater than 970 microliters, MagneticBeadSeparationWashMixVolume is automatically set to 970 microliters:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationWashMixType -> Pipette,
					MagneticBeadSeparationWashSolutionVolume -> 1.8 Milliliter,
					MagneticBeadVolume -> 0.2 Milliliter,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationWashMixVolume -> EqualP[0.970 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationWashMixTemperature Tests -- *)
			Example[{Options, MagneticBeadSeparationWashMixTemperature, "If MagneticBeadSeparationWashMix is set to True, MagneticBeadSeparationWashMixTemperature is automatically set to Ambient:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationWashMix -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationWashMixTemperature -> Ambient
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationWashMixTipType Tests -- *)
			Example[{Options, MagneticBeadSeparationWashMixTipType, "If MagneticBeadSeparationWashMixType is set to Pipette, MagneticBeadSeparationWashMixTipType is automatically set to WideBore:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationWashMixType -> Pipette,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationWashMixTipType -> WideBore
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationWashMixTipMaterial Tests -- *)
			Example[{Options, MagneticBeadSeparationWashMixTipMaterial, "If MagneticBeadSeparationWashMixType is set to Pipette, MagneticBeadSeparationWashMixTipMaterial is automatically set to Polypropylene:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationWashMixType -> Pipette,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationWashMixTipMaterial -> Polypropylene
					}
				],
				TimeConstraint -> 1800
			],

			(* -- WashMagnetizationTime Tests -- *)
			Example[{Options, WashMagnetizationTime, "If MagneticBeadSeparationWash is set to True, WashMagnetizationTime is automatically set to 5 minutes:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						WashMagnetizationTime -> EqualP[5 Minute]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationWashAspirationVolume Tests -- *)
			Example[{Options, MagneticBeadSeparationWashAspirationVolume, "If MagneticBeadSeparationWash is set to True, MagneticBeadSeparationWashAspirationVolume is automatically set the same as the MagneticBeadSeparationWashSolutionVolume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationWashSolutionVolume -> 0.2 Milliliter,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationWashAspirationVolume -> EqualP[0.2 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationWashCollectionContainer Tests -- *)
			Example[{Options, MagneticBeadSeparationWashCollectionContainer, "If MagneticBeadSeparationWash is set to True, MagneticBeadSeparationWashCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationWashCollectionContainer -> {{(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}}
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationWashCollectionStorageCondition Tests -- *)
			Example[{Options, MagneticBeadSeparationWashCollectionStorageCondition, "If MagneticBeadSeparationWash is set to True, MagneticBeadSeparationWashCollectionStorageCondition is automatically set to Refrigerator unless otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationWashCollectionStorageCondition -> Refrigerator
					}
				],
				TimeConstraint -> 1800
			],

			(* -- NumberOfMagneticBeadSeparationWashes Tests -- *)
			Example[{Options, NumberOfMagneticBeadSeparationWashes, "If MagneticBeadSeparationWash is True, NumberOfMagneticBeadSeparationWashes is automatically set to 1:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						NumberOfMagneticBeadSeparationWashes -> 1
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationWashAirDry Tests -- *)
			Example[{Options, MagneticBeadSeparationWashAirDry, "If MagneticBeadSeparationWash is set to True, MagneticBeadSeparationWashAirDry is automatically set to False:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationWashAirDry -> False
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationWashAirDryTime Tests -- *)
			Example[{Options, MagneticBeadSeparationWashAirDryTime, "If MagneticBeadSeparationWashAirDry is set to True, MagneticBeadSeparationWashAirDryTime is automatically set to 1 Minute:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationWashAirDry -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationWashAirDryTime -> EqualP[1 Minute]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSecondaryWash Tests -- *)
			Example[{Options, MagneticBeadSeparationSecondaryWash, "If any magnetic bead separation secondary wash options are set (MagneticBeadSeparationSecondaryWashSolution, MagneticBeadSeparationSecondaryWashSolutionVolume, MagneticBeadSeparationSecondaryWashMix, etc.), MagneticBeadSeparationSecondaryWash is automatically set to True:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSecondaryWashMixType -> Shake,
					(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
					MagneticBeadSeparationWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSecondaryWash -> True
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationSecondaryWash, "If no magnetic bead separation secondary wash options are set (MagneticBeadSeparationSecondaryWashSolution, MagneticBeadSeparationSecondaryWashSolutionVolume, MagneticBeadSeparationSecondaryWashMix, etc.), MagneticBeadSeparationSecondaryWash is automatically set to False:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> MagneticBeadSeparation,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSecondaryWash -> False
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSecondaryWashSolution Tests -- *)
			Example[{Options, MagneticBeadSeparationSecondaryWashSolution, "If MagneticBeadSeparationSecondaryWash is set to True, MagneticBeadSeparationSecondaryWashSolution is automatically set to Model[Sample,\"Milli-Q water\"]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSecondaryWash -> True,
					(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
					MagneticBeadSeparationWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSecondaryWashSolution -> ObjectP[Model[Sample,"Milli-Q water"]]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSecondaryWashSolutionVolume Tests -- *)
			Example[{Options, MagneticBeadSeparationSecondaryWashSolutionVolume, "If MagneticBeadSeparationSecondaryWash and MagneticBeadSeparationPreWash are set to True, MagneticBeadSeparationSecondaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationPreWashSolutionVolume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationPreWash -> True,
					MagneticBeadSeparationPreWashSolutionVolume -> 0.2 Milliliter,
					MagneticBeadSeparationSecondaryWash -> True,
					(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
					MagneticBeadSeparationWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSecondaryWashSolutionVolume -> EqualP[0.2 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationSecondaryWashSolutionVolume, "If MagneticBeadSeparationSecondaryWash is set to True and MagneticBeadSeparationPreWash is set to False, MagneticBeadSeparationSecondaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationSampleVolume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
					MagneticBeadSeparationPreWash -> False,
					MagneticBeadSeparationSecondaryWash -> True,
					(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
					MagneticBeadSeparationWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSecondaryWashSolutionVolume -> EqualP[0.2 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSecondaryWashMix Tests -- *)
			Example[{Options, MagneticBeadSeparationSecondaryWashMix, "If MagneticBeadSeparationSecondaryWash is set to True, MagneticBeadSeparationSecondaryWashMix is automatically set to True:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSecondaryWash -> True,
					(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
					MagneticBeadSeparationWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSecondaryWashMix -> True
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSecondaryWashMixType Tests -- *)
			Example[{Options, MagneticBeadSeparationSecondaryWashMixType, "If MagneticBeadSeparationSecondaryWashMixRate or MagneticBeadSeparationSecondaryWashMixTime are set, MagneticBeadSeparationSecondaryWashMixType is automatically set to Shake:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSecondaryWashMixTime -> 1 Minute,
					(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
					MagneticBeadSeparationWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSecondaryWashMixType -> Shake
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationSecondaryWashMixType, "If NumberOfMagneticBeadSeparationSecondaryWashMixes or MagneticBeadSeparationSecondaryWashMixVolume are set, MagneticBeadSeparationSecondaryWashMixType is automatically set to Pipette:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					NumberOfMagneticBeadSeparationSecondaryWashMixes -> 10,
					(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
					MagneticBeadSeparationWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSecondaryWashMixType -> Pipette
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationSecondaryWashMixType, "If no magnetic bead separation secondary wash mix options are set, MagneticBeadSeparationSecondaryWashMixType is automatically set to Pipette:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSecondaryWashMix -> True,
					(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
					MagneticBeadSeparationWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSecondaryWashMixType -> Pipette
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSecondaryWashMixTime Tests -- *)
			Example[{Options, MagneticBeadSeparationSecondaryWashMixTime, "If MagneticBeadSeparationSecondaryWashMixType is set to Shake, MagneticBeadSeparationSecondaryWashMixTime is automatically set to 5 minutes:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSecondaryWashMixType -> Shake,
					(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
					MagneticBeadSeparationWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSecondaryWashMixTime -> EqualP[5 Minute]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSecondaryWashMixRate Tests -- *)
			Example[{Options, MagneticBeadSeparationSecondaryWashMixRate, "If MagneticBeadSeparationSecondaryWashMixType is set to Shake, MagneticBeadSeparationSecondaryWashMixRate is automatically set to 300 RPM:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSecondaryWashMixType -> Shake,
					(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
					MagneticBeadSeparationWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSecondaryWashMixRate -> EqualP[300 RPM]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- NumberOfMagneticBeadSeparationSecondaryWashMixes Tests -- *)
			Example[{Options, NumberOfMagneticBeadSeparationSecondaryWashMixes, "If MagneticBeadSeparationSecondaryWashMixType is set to Pipette, NumberOfMagneticBeadSeparationSecondaryWashMixes is automatically set to 10:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSecondaryWashMixType -> Pipette,
					(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
					MagneticBeadSeparationWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						NumberOfMagneticBeadSeparationSecondaryWashMixes -> 10
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSecondaryWashMixVolume Tests -- *)
			Example[{Options, MagneticBeadSeparationSecondaryWashMixVolume, "If MagneticBeadSeparationSecondaryWashMixType is set to Pipette and 1/2 of the combined MagneticBeadSeparationSecondaryWashSolution and magnetic beads volume is less than 970 microliters, MagneticBeadSeparationSecondaryWashMixVolume is automatically set to 1/2 of the combined MagneticBeadSeparationSecondaryWashSolution and magnetic beads volume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSecondaryWashMixType -> Pipette,
					MagneticBeadVolume -> 0.2 Milliliter,
					MagneticBeadSeparationSecondaryWashSolutionVolume -> 0.2 Milliliter,
					(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
					MagneticBeadSeparationWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSecondaryWashMixVolume -> EqualP[0.2 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationSecondaryWashMixVolume, "If MagneticBeadSeparationSecondaryWashMixType is set to Pipette and 1/2 of the combined MagneticBeadSeparationSecondaryWashSolution and magnetic beads volume is greater than 970 microliters, MagneticBeadSeparationSecondaryWashMixVolume is automatically set to 970 microliters:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSecondaryWashMixType -> Pipette,
					MagneticBeadSeparationSecondaryWashSolutionVolume -> 1.8 Milliliter,
					MagneticBeadVolume -> 0.2 Milliliter,
					(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
					MagneticBeadSeparationWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSecondaryWashMixVolume -> EqualP[0.970 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSecondaryWashMixTemperature Tests -- *)
			Example[{Options, MagneticBeadSeparationSecondaryWashMixTemperature, "If MagneticBeadSeparationSecondaryWashMix is set to True, MagneticBeadSeparationSecondaryWashMixTemperature is automatically set to Ambient:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSecondaryWashMix -> True,
					(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
					MagneticBeadSeparationWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSecondaryWashMixTemperature -> Ambient
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSecondaryWashMixTipType Tests -- *)
			Example[{Options, MagneticBeadSeparationSecondaryWashMixTipType, "If MagneticBeadSeparationSecondaryWashMixType is set to Pipette, MagneticBeadSeparationSecondaryWashMixTipType is automatically set to WideBore:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSecondaryWashMixType -> Pipette,
					(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
					MagneticBeadSeparationWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSecondaryWashMixTipType -> WideBore
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSecondaryWashMixTipMaterial Tests -- *)
			Example[{Options, MagneticBeadSeparationSecondaryWashMixTipMaterial, "If MagneticBeadSeparationSecondaryWashMixType is set to Pipette, MagneticBeadSeparationSecondaryWashMixTipMaterial is automatically set to Polypropylene:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSecondaryWashMixType -> Pipette,
					(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
					MagneticBeadSeparationWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSecondaryWashMixTipMaterial -> Polypropylene
					}
				],
				TimeConstraint -> 1800
			],

			(* -- SecondaryWashMagnetizationTime Tests -- *)
			Example[{Options, SecondaryWashMagnetizationTime, "If MagneticBeadSeparationSecondaryWash is set to True, SecondaryWashMagnetizationTime is automatically set to 5 minutes:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSecondaryWash -> True,
					(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
					MagneticBeadSeparationWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						SecondaryWashMagnetizationTime -> EqualP[5 Minute]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSecondaryWashAspirationVolume Tests -- *)
			Example[{Options, MagneticBeadSeparationSecondaryWashAspirationVolume, "If MagneticBeadSeparationSecondaryWash is set to True, MagneticBeadSeparationSecondaryWashAspirationVolume is automatically set the same as the MagneticBeadSeparationSecondaryWashSolutionVolume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationSecondaryWashSolutionVolume -> 0.2 Milliliter,
					(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
					MagneticBeadSeparationWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSecondaryWashAspirationVolume -> EqualP[0.2 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSecondaryWashCollectionContainer Tests -- *)
			Example[{Options, MagneticBeadSeparationSecondaryWashCollectionContainer, "If MagneticBeadSeparationSecondaryWash is set to True, MagneticBeadSeparationSecondaryWashCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSecondaryWash -> True,
					(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
					MagneticBeadSeparationWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSecondaryWashCollectionContainer -> {{(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}}
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSecondaryWashCollectionStorageCondition Tests -- *)
			Example[{Options, MagneticBeadSeparationSecondaryWashCollectionStorageCondition, "If MagneticBeadSeparationSecondaryWash is set to True, MagneticBeadSeparationSecondaryWashCollectionStorageCondition is automatically set to Refrigerator unless otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSecondaryWash -> True,
					(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
					MagneticBeadSeparationWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSecondaryWashCollectionStorageCondition -> Refrigerator
					}
				],
				TimeConstraint -> 1800
			],

			(* -- NumberOfMagneticBeadSeparationSecondaryWashes Tests -- *)
			Example[{Options, NumberOfMagneticBeadSeparationSecondaryWashes, "If MagneticBeadSeparationSecondaryWash is True, NumberOfMagneticBeadSeparationSecondaryWashes is automatically set to 1:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSecondaryWash -> True,
					(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
					MagneticBeadSeparationWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						NumberOfMagneticBeadSeparationSecondaryWashes -> 1
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSecondaryWashAirDry Tests -- *)
			Example[{Options, MagneticBeadSeparationSecondaryWashAirDry, "If MagneticBeadSeparationSecondaryWash is set to True, MagneticBeadSeparationSecondaryWashAirDry is automatically set to False:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSecondaryWash -> True,
					(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
					MagneticBeadSeparationWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSecondaryWashAirDry -> False
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSecondaryWashAirDryTime Tests -- *)
			Example[{Options, MagneticBeadSeparationSecondaryWashAirDryTime, "If MagneticBeadSeparationSecondaryWashAirDry is set to True, MagneticBeadSeparationSecondaryWashAirDryTime is automatically set to 1 Minute:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSecondaryWashAirDry -> True,
					(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
					MagneticBeadSeparationWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSecondaryWashAirDryTime -> EqualP[1 Minute]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationTertiaryWash Tests -- *)
			Example[{Options, MagneticBeadSeparationTertiaryWash, "If any magnetic bead separation tertiary wash options are set (MagneticBeadSeparationTertiaryWashSolution, MagneticBeadSeparationTertiaryWashSolutionVolume, MagneticBeadSeparationTertiaryWashMix, etc.), MagneticBeadSeparationTertiaryWash is automatically set to True:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationTertiaryWashMixType -> Shake,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationTertiaryWash -> True
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationTertiaryWash, "If no magnetic bead separation tertiary wash options are set (MagneticBeadSeparationTertiaryWashSolution, MagneticBeadSeparationTertiaryWashSolutionVolume, MagneticBeadSeparationTertiaryWashMix, etc.), MagneticBeadSeparationTertiaryWash is automatically set to False:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> MagneticBeadSeparation,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationTertiaryWash -> False
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationTertiaryWashSolution Tests -- *)
			Example[{Options, MagneticBeadSeparationTertiaryWashSolution, "If MagneticBeadSeparationTertiaryWash is set to True, MagneticBeadSeparationTertiaryWashSolution is automatically set to Model[Sample,\"Milli-Q water\"]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationTertiaryWash -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationTertiaryWashSolution -> ObjectP[Model[Sample,"Milli-Q water"]]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationTertiaryWashSolutionVolume Tests -- *)
			Example[{Options, MagneticBeadSeparationTertiaryWashSolutionVolume, "If MagneticBeadSeparationTertiaryWash and MagneticBeadSeparationPreWash are set to True, MagneticBeadSeparationTertiaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationPreWashSolutionVolume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationPreWash -> True,
					MagneticBeadSeparationPreWashSolutionVolume -> 0.2 Milliliter,
					MagneticBeadSeparationTertiaryWash -> True,
					(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationTertiaryWashSolutionVolume -> EqualP[0.2 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationTertiaryWashSolutionVolume, "If MagneticBeadSeparationTertiaryWash is set to True and MagneticBeadSeparationPreWash is set to False, MagneticBeadSeparationTertiaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationSampleVolume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
					MagneticBeadSeparationPreWash -> False,
					MagneticBeadSeparationTertiaryWash -> True,
					(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationTertiaryWashSolutionVolume -> EqualP[0.2 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationTertiaryWashMix Tests -- *)
			Example[{Options, MagneticBeadSeparationTertiaryWashMix, "If MagneticBeadSeparationTertiaryWash is set to True, MagneticBeadSeparationTertiaryWashMix is automatically set to True:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationTertiaryWash -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationTertiaryWashMix -> True
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationTertiaryWashMixType Tests -- *)
			Example[{Options, MagneticBeadSeparationTertiaryWashMixType, "If MagneticBeadSeparationTertiaryWashMixRate or MagneticBeadSeparationTertiaryWashMixTime are set, MagneticBeadSeparationTertiaryWashMixType is automatically set to Shake:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationTertiaryWashMixTime -> 1 Minute,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationTertiaryWashMixType -> Shake
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationTertiaryWashMixType, "If NumberOfMagneticBeadSeparationTertiaryWashMixes or MagneticBeadSeparationTertiaryWashMixVolume are set, MagneticBeadSeparationTertiaryWashMixType is automatically set to Pipette:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					NumberOfMagneticBeadSeparationTertiaryWashMixes -> 10,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationTertiaryWashMixType -> Pipette
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationTertiaryWashMixType, "If no magnetic bead separation tertiary wash mix options are set, MagneticBeadSeparationTertiaryWashMixType is automatically set to Pipette:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationTertiaryWashMix -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationTertiaryWashMixType -> Pipette
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationTertiaryWashMixTime Tests -- *)
			Example[{Options, MagneticBeadSeparationTertiaryWashMixTime, "If MagneticBeadSeparationTertiaryWashMixType is set to Shake, MagneticBeadSeparationTertiaryWashMixTime is automatically set to 5 minutes:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationTertiaryWashMixType -> Shake,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationTertiaryWashMixTime -> EqualP[5 Minute]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationTertiaryWashMixRate Tests -- *)
			Example[{Options, MagneticBeadSeparationTertiaryWashMixRate, "If MagneticBeadSeparationTertiaryWashMixType is set to Shake, MagneticBeadSeparationTertiaryWashMixRate is automatically set to 300 RPM:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationTertiaryWashMixType -> Shake,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationTertiaryWashMixRate -> EqualP[300 RPM]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- NumberOfMagneticBeadSeparationTertiaryWashMixes Tests -- *)
			Example[{Options, NumberOfMagneticBeadSeparationTertiaryWashMixes, "If MagneticBeadSeparationTertiaryWashMixType is set to Pipette, NumberOfMagneticBeadSeparationTertiaryWashMixes is automatically set to 10:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationTertiaryWashMixType -> Pipette,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						NumberOfMagneticBeadSeparationTertiaryWashMixes -> 10
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationTertiaryWashMixVolume Tests -- *)
			Example[{Options, MagneticBeadSeparationTertiaryWashMixVolume, "If MagneticBeadSeparationTertiaryWashMixType is set to Pipette and 1/2 of the combined MagneticBeadSeparationTertiaryWashSolution and magnetic beads volume is less than 970 microliters, MagneticBeadSeparationTertiaryWashMixVolume is automatically set to 1/2 of the combined MagneticBeadSeparationTertiaryWashSolution and magnetic beads volume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationTertiaryWashMixType -> Pipette,
					MagneticBeadVolume -> 0.2 Milliliter,
					MagneticBeadSeparationTertiaryWashSolutionVolume -> 0.2 Milliliter,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationTertiaryWashMixVolume -> EqualP[0.2 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationTertiaryWashMixVolume, "If MagneticBeadSeparationTertiaryWashMixType is set to Pipette and 1/2 of the combined MagneticBeadSeparationTertiaryWashSolution and magnetic beads volume is greater than 970 microliters, MagneticBeadSeparationTertiaryWashMixVolume is automatically set to 970 microliters:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationTertiaryWashMixType -> Pipette,
					MagneticBeadSeparationTertiaryWashSolutionVolume -> 1.8 Milliliter,
					MagneticBeadVolume -> 0.2 Milliliter,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationTertiaryWashMixVolume -> EqualP[0.970 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationTertiaryWashMixTemperature Tests -- *)
			Example[{Options, MagneticBeadSeparationTertiaryWashMixTemperature, "If MagneticBeadSeparationTertiaryWashMix is set to True, MagneticBeadSeparationTertiaryWashMixTemperature is automatically set to Ambient:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationTertiaryWashMix -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationTertiaryWashMixTemperature -> Ambient
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationTertiaryWashMixTipType Tests -- *)
			Example[{Options, MagneticBeadSeparationTertiaryWashMixTipType, "If MagneticBeadSeparationTertiaryWashMixType is set to Pipette, MagneticBeadSeparationTertiaryWashMixTipType is automatically set to WideBore:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationTertiaryWashMixType -> Pipette,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationTertiaryWashMixTipType -> WideBore
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationTertiaryWashMixTipMaterial Tests -- *)
			Example[{Options, MagneticBeadSeparationTertiaryWashMixTipMaterial, "If MagneticBeadSeparationTertiaryWashMixType is set to Pipette, MagneticBeadSeparationTertiaryWashMixTipMaterial is automatically set to Polypropylene:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationTertiaryWashMixType -> Pipette,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationTertiaryWashMixTipMaterial -> Polypropylene
					}
				],
				TimeConstraint -> 1800
			],

			(* -- TertiaryWashMagnetizationTime Tests -- *)
			Example[{Options, TertiaryWashMagnetizationTime, "If MagneticBeadSeparationTertiaryWash is set to True, TertiaryWashMagnetizationTime is automatically set to 5 minutes:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationTertiaryWash -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						TertiaryWashMagnetizationTime -> EqualP[5 Minute]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationTertiaryWashAspirationVolume Tests -- *)
			Example[{Options, MagneticBeadSeparationTertiaryWashAspirationVolume, "If MagneticBeadSeparationTertiaryWash is set to True, MagneticBeadSeparationTertiaryWashAspirationVolume is automatically set the same as the MagneticBeadSeparationTertiaryWashSolutionVolume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationTertiaryWashSolutionVolume -> 0.2 Milliliter,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationTertiaryWashAspirationVolume -> EqualP[0.2 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationTertiaryWashCollectionContainer Tests -- *)
			Example[{Options, MagneticBeadSeparationTertiaryWashCollectionContainer, "If MagneticBeadSeparationTertiaryWash is set to True, MagneticBeadSeparationTertiaryWashCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationTertiaryWash -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationTertiaryWashCollectionContainer -> {{(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}}
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationTertiaryWashCollectionStorageCondition Tests -- *)
			Example[{Options, MagneticBeadSeparationTertiaryWashCollectionStorageCondition, "If MagneticBeadSeparationTertiaryWash is set to True, MagneticBeadSeparationTertiaryWashCollectionStorageCondition is automatically set to Refrigerator unless otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationTertiaryWash -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationTertiaryWashCollectionStorageCondition -> Refrigerator
					}
				],
				TimeConstraint -> 1800
			],

			(* -- NumberOfMagneticBeadSeparationTertiaryWashes Tests -- *)
			Example[{Options, NumberOfMagneticBeadSeparationTertiaryWashes, "If MagneticBeadSeparationTertiaryWash is True, NumberOfMagneticBeadSeparationTertiaryWashes is automatically set to 1:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationTertiaryWash -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						NumberOfMagneticBeadSeparationTertiaryWashes -> 1
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationTertiaryWashAirDry Tests -- *)
			Example[{Options, MagneticBeadSeparationTertiaryWashAirDry, "If MagneticBeadSeparationTertiaryWash is set to True, MagneticBeadSeparationTertiaryWashAirDry is automatically set to False:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationTertiaryWash -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationTertiaryWashAirDry -> False
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationTertiaryWashAirDryTime Tests -- *)
			Example[{Options, MagneticBeadSeparationTertiaryWashAirDryTime, "If MagneticBeadSeparationTertiaryWashAirDry is set to True, MagneticBeadSeparationTertiaryWashAirDryTime is automatically set to 1 Minute:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationTertiaryWashAirDry -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationTertiaryWashAirDryTime -> EqualP[1 Minute]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationQuaternaryWash Tests -- *)
			Example[{Options, MagneticBeadSeparationQuaternaryWash, "If any magnetic bead separation quaternary wash options are set (MagneticBeadSeparationQuaternaryWashSolution, MagneticBeadSeparationQuaternaryWashSolutionVolume, MagneticBeadSeparationQuaternaryWashMix, etc.), MagneticBeadSeparationQuaternaryWash is automatically set to True:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuaternaryWashMixType -> Shake,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuaternaryWash -> True
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationQuaternaryWash, "If no magnetic bead separation quaternary wash options are set (MagneticBeadSeparationQuaternaryWashSolution, MagneticBeadSeparationQuaternaryWashSolutionVolume, MagneticBeadSeparationQuaternaryWashMix, etc.), MagneticBeadSeparationQuaternaryWash is automatically set to False:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> MagneticBeadSeparation,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuaternaryWash -> False
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationQuaternaryWashSolution Tests -- *)
			Example[{Options, MagneticBeadSeparationQuaternaryWashSolution, "If MagneticBeadSeparationQuaternaryWash is set to True, MagneticBeadSeparationQuaternaryWashSolution is automatically set to Model[Sample,\"Milli-Q water\"]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuaternaryWash -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuaternaryWashSolution -> ObjectP[Model[Sample,"Milli-Q water"]]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationQuaternaryWashSolutionVolume Tests -- *)
			Example[{Options, MagneticBeadSeparationQuaternaryWashSolutionVolume, "If MagneticBeadSeparationQuaternaryWash and MagneticBeadSeparationPreWash are set to True, MagneticBeadSeparationQuaternaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationPreWashSolutionVolume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationPreWash -> True,
					MagneticBeadSeparationPreWashSolutionVolume -> 0.2 Milliliter,
					MagneticBeadSeparationQuaternaryWash -> True,
					(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuaternaryWashSolutionVolume -> EqualP[0.2 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationQuaternaryWashSolutionVolume, "If MagneticBeadSeparationQuaternaryWash is set to True and MagneticBeadSeparationPreWash is set to False, MagneticBeadSeparationQuaternaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationSampleVolume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
					MagneticBeadSeparationPreWash -> False,
					MagneticBeadSeparationQuaternaryWash -> True,
					(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuaternaryWashSolutionVolume -> EqualP[0.2 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationQuaternaryWashMix Tests -- *)
			Example[{Options, MagneticBeadSeparationQuaternaryWashMix, "If MagneticBeadSeparationQuaternaryWash is set to True, MagneticBeadSeparationQuaternaryWashMix is automatically set to True:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuaternaryWash -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuaternaryWashMix -> True
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationQuaternaryWashMixType Tests -- *)
			Example[{Options, MagneticBeadSeparationQuaternaryWashMixType, "If MagneticBeadSeparationQuaternaryWashMixRate or MagneticBeadSeparationQuaternaryWashMixTime are set, MagneticBeadSeparationQuaternaryWashMixType is automatically set to Shake:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuaternaryWashMixTime -> 1 Minute,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuaternaryWashMixType -> Shake
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationQuaternaryWashMixType, "If NumberOfMagneticBeadSeparationQuaternaryWashMixes or MagneticBeadSeparationQuaternaryWashMixVolume are set, MagneticBeadSeparationQuaternaryWashMixType is automatically set to Pipette:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					NumberOfMagneticBeadSeparationQuaternaryWashMixes -> 10,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuaternaryWashMixType -> Pipette
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationQuaternaryWashMixType, "If no magnetic bead separation quaternary wash mix options are set, MagneticBeadSeparationQuaternaryWashMixType is automatically set to Pipette:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuaternaryWashMix -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuaternaryWashMixType -> Pipette
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationQuaternaryWashMixTime Tests -- *)
			Example[{Options, MagneticBeadSeparationQuaternaryWashMixTime, "If MagneticBeadSeparationQuaternaryWashMixType is set to Shake, MagneticBeadSeparationQuaternaryWashMixTime is automatically set to 5 minutes:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuaternaryWashMixType -> Shake,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuaternaryWashMixTime -> EqualP[5 Minute]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationQuaternaryWashMixRate Tests -- *)
			Example[{Options, MagneticBeadSeparationQuaternaryWashMixRate, "If MagneticBeadSeparationQuaternaryWashMixType is set to Shake, MagneticBeadSeparationQuaternaryWashMixRate is automatically set to 300 RPM:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuaternaryWashMixType -> Shake,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuaternaryWashMixRate -> EqualP[300 RPM]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- NumberOfMagneticBeadSeparationQuaternaryWashMixes Tests -- *)
			Example[{Options, NumberOfMagneticBeadSeparationQuaternaryWashMixes, "If MagneticBeadSeparationQuaternaryWashMixType is set to Pipette, NumberOfMagneticBeadSeparationQuaternaryWashMixes is automatically set to 10:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuaternaryWashMixType -> Pipette,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						NumberOfMagneticBeadSeparationQuaternaryWashMixes -> 10
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationQuaternaryWashMixVolume Tests -- *)
			Example[{Options, MagneticBeadSeparationQuaternaryWashMixVolume, "If MagneticBeadSeparationQuaternaryWashMixType is set to Pipette and 1/2 of the combined MagneticBeadSeparationQuaternaryWashSolution and magnetic beads volume is less than 970 microliters, MagneticBeadSeparationQuaternaryWashMixVolume is automatically set to 1/2 of the combined MagneticBeadSeparationQuaternaryWashSolution and magnetic beads volume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuaternaryWashMixType -> Pipette,
					MagneticBeadVolume -> 0.2 Milliliter,
					MagneticBeadSeparationQuaternaryWashSolutionVolume -> 0.2 Milliliter,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuaternaryWashMixVolume -> EqualP[0.2 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationQuaternaryWashMixVolume, "If MagneticBeadSeparationQuaternaryWashMixType is set to Pipette and 1/2 of the combined MagneticBeadSeparationQuaternaryWashSolution and magnetic beads volume is greater than 970 microliters, MagneticBeadSeparationQuaternaryWashMixVolume is automatically set to 970 microliters:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuaternaryWashMixType -> Pipette,
					MagneticBeadSeparationQuaternaryWashSolutionVolume -> 1.8 Milliliter,
					MagneticBeadVolume -> 0.2 Milliliter,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuaternaryWashMixVolume -> EqualP[0.970 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationQuaternaryWashMixTemperature Tests -- *)
			Example[{Options, MagneticBeadSeparationQuaternaryWashMixTemperature, "If MagneticBeadSeparationQuaternaryWashMix is set to True, MagneticBeadSeparationQuaternaryWashMixTemperature is automatically set to Ambient:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuaternaryWashMix -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuaternaryWashMixTemperature -> Ambient
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationQuaternaryWashMixTipType Tests -- *)
			Example[{Options, MagneticBeadSeparationQuaternaryWashMixTipType, "If MagneticBeadSeparationQuaternaryWashMixType is set to Pipette, MagneticBeadSeparationQuaternaryWashMixTipType is automatically set to WideBore:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuaternaryWashMixType -> Pipette,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuaternaryWashMixTipType -> WideBore
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationQuaternaryWashMixTipMaterial Tests -- *)
			Example[{Options, MagneticBeadSeparationQuaternaryWashMixTipMaterial, "If MagneticBeadSeparationQuaternaryWashMixType is set to Pipette, MagneticBeadSeparationQuaternaryWashMixTipMaterial is automatically set to Polypropylene:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuaternaryWashMixType -> Pipette,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuaternaryWashMixTipMaterial -> Polypropylene
					}
				],
				TimeConstraint -> 1800
			],

			(* -- QuaternaryWashMagnetizationTime Tests -- *)
			Example[{Options, QuaternaryWashMagnetizationTime, "If MagneticBeadSeparationQuaternaryWash is set to True, QuaternaryWashMagnetizationTime is automatically set to 5 minutes:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuaternaryWash -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						QuaternaryWashMagnetizationTime -> EqualP[5 Minute]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationQuaternaryWashAspirationVolume Tests -- *)
			Example[{Options, MagneticBeadSeparationQuaternaryWashAspirationVolume, "If MagneticBeadSeparationQuaternaryWash is set to True, MagneticBeadSeparationQuaternaryWashAspirationVolume is automatically set the same as the MagneticBeadSeparationQuaternaryWashSolutionVolume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuaternaryWashSolutionVolume -> 0.2 Milliliter,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuaternaryWashAspirationVolume -> EqualP[0.2 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationQuaternaryWashCollectionContainer Tests -- *)
			Example[{Options, MagneticBeadSeparationQuaternaryWashCollectionContainer, "If MagneticBeadSeparationQuaternaryWash is set to True, MagneticBeadSeparationQuaternaryWashCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuaternaryWash -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuaternaryWashCollectionContainer -> {{(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}}
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationQuaternaryWashCollectionStorageCondition Tests -- *)
			Example[{Options, MagneticBeadSeparationQuaternaryWashCollectionStorageCondition, "If MagneticBeadSeparationQuaternaryWash is set to True, MagneticBeadSeparationQuaternaryWashCollectionStorageCondition is automatically set to Refrigerator unless otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuaternaryWash -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuaternaryWashCollectionStorageCondition -> Refrigerator
					}
				],
				TimeConstraint -> 1800
			],

			(* -- NumberOfMagneticBeadSeparationQuaternaryWashes Tests -- *)
			Example[{Options, NumberOfMagneticBeadSeparationQuaternaryWashes, "If MagneticBeadSeparationQuaternaryWash is True, NumberOfMagneticBeadSeparationQuaternaryWashes is automatically set to 1:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuaternaryWash -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						NumberOfMagneticBeadSeparationQuaternaryWashes -> 1
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationQuaternaryWashAirDry Tests -- *)
			Example[{Options, MagneticBeadSeparationQuaternaryWashAirDry, "If MagneticBeadSeparationQuaternaryWash is set to True, MagneticBeadSeparationQuaternaryWashAirDry is automatically set to False:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuaternaryWash -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuaternaryWashAirDry -> False
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationQuaternaryWashAirDryTime Tests -- *)
			Example[{Options, MagneticBeadSeparationQuaternaryWashAirDryTime, "If MagneticBeadSeparationQuaternaryWashAirDry is set to True, MagneticBeadSeparationQuaternaryWashAirDryTime is automatically set to 1 Minute:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuaternaryWashAirDry -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuaternaryWashAirDryTime -> EqualP[1 Minute]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationQuinaryWash Tests -- *)
			Example[{Options, MagneticBeadSeparationQuinaryWash, "If any magnetic bead separation quinary wash options are set (MagneticBeadSeparationQuinaryWashSolution, MagneticBeadSeparationQuinaryWashSolutionVolume, MagneticBeadSeparationQuinaryWashMix, etc.), MagneticBeadSeparationQuinaryWash is automatically set to True:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuinaryWashMixType -> Shake,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuinaryWash -> True
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationQuinaryWash, "If no magnetic bead separation quinary wash options are set (MagneticBeadSeparationQuinaryWashSolution, MagneticBeadSeparationQuinaryWashSolutionVolume, MagneticBeadSeparationQuinaryWashMix, etc.), MagneticBeadSeparationQuinaryWash is automatically set to False:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> MagneticBeadSeparation,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuinaryWash -> False
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationQuinaryWashSolution Tests -- *)
			Example[{Options, MagneticBeadSeparationQuinaryWashSolution, "If MagneticBeadSeparationQuinaryWash is set to True, MagneticBeadSeparationQuinaryWashSolution is automatically set to Model[Sample,\"Milli-Q water\"]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuinaryWash -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuinaryWashSolution -> ObjectP[Model[Sample,"Milli-Q water"]]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationQuinaryWashSolutionVolume Tests -- *)
			Example[{Options, MagneticBeadSeparationQuinaryWashSolutionVolume, "If MagneticBeadSeparationQuinaryWash and MagneticBeadSeparationPreWash are set to True, MagneticBeadSeparationQuinaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationPreWashSolutionVolume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationPreWash -> True,
					MagneticBeadSeparationPreWashSolutionVolume -> 0.2 Milliliter,
					MagneticBeadSeparationQuinaryWash -> True,
					(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuinaryWashSolutionVolume -> EqualP[0.2 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationQuinaryWashSolutionVolume, "If MagneticBeadSeparationQuinaryWash is set to True and MagneticBeadSeparationPreWash is set to False, MagneticBeadSeparationQuinaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationSampleVolume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
					MagneticBeadSeparationPreWash -> False,
					MagneticBeadSeparationQuinaryWash -> True,
					(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuinaryWashSolutionVolume -> EqualP[0.2 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationQuinaryWashMix Tests -- *)
			Example[{Options, MagneticBeadSeparationQuinaryWashMix, "If MagneticBeadSeparationQuinaryWash is set to True, MagneticBeadSeparationQuinaryWashMix is automatically set to True:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuinaryWash -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuinaryWashMix -> True
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationQuinaryWashMixType Tests -- *)
			Example[{Options, MagneticBeadSeparationQuinaryWashMixType, "If MagneticBeadSeparationQuinaryWashMixRate or MagneticBeadSeparationQuinaryWashMixTime are set, MagneticBeadSeparationQuinaryWashMixType is automatically set to Shake:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuinaryWashMixTime -> 1 Minute,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuinaryWashMixType -> Shake
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationQuinaryWashMixType, "If NumberOfMagneticBeadSeparationQuinaryWashMixes or MagneticBeadSeparationQuinaryWashMixVolume are set, MagneticBeadSeparationQuinaryWashMixType is automatically set to Pipette:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					NumberOfMagneticBeadSeparationQuinaryWashMixes -> 10,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuinaryWashMixType -> Pipette
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationQuinaryWashMixType, "If no magnetic bead separation quinary wash mix options are set, MagneticBeadSeparationQuinaryWashMixType is automatically set to Pipette:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuinaryWashMix -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuinaryWashMixType -> Pipette
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationQuinaryWashMixTime Tests -- *)
			Example[{Options, MagneticBeadSeparationQuinaryWashMixTime, "If MagneticBeadSeparationQuinaryWashMixType is set to Shake, MagneticBeadSeparationQuinaryWashMixTime is automatically set to 5 minutes:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuinaryWashMixType -> Shake,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuinaryWashMixTime -> EqualP[5 Minute]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationQuinaryWashMixRate Tests -- *)
			Example[{Options, MagneticBeadSeparationQuinaryWashMixRate, "If MagneticBeadSeparationQuinaryWashMixType is set to Shake, MagneticBeadSeparationQuinaryWashMixRate is automatically set to 300 RPM:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuinaryWashMixType -> Shake,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuinaryWashMixRate -> EqualP[300 RPM]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- NumberOfMagneticBeadSeparationQuinaryWashMixes Tests -- *)
			Example[{Options, NumberOfMagneticBeadSeparationQuinaryWashMixes, "If MagneticBeadSeparationQuinaryWashMixType is set to Pipette, NumberOfMagneticBeadSeparationQuinaryWashMixes is automatically set to 10:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuinaryWashMixType -> Pipette,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						NumberOfMagneticBeadSeparationQuinaryWashMixes -> 10
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationQuinaryWashMixVolume Tests -- *)
			Example[{Options, MagneticBeadSeparationQuinaryWashMixVolume, "If MagneticBeadSeparationQuinaryWashMixType is set to Pipette and 1/2 of the combined MagneticBeadSeparationQuinaryWashSolution and magnetic beads volume is less than 970 microliters, MagneticBeadSeparationQuinaryWashMixVolume is automatically set to 1/2 of the combined MagneticBeadSeparationQuinaryWashSolution and magnetic beads volume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuinaryWashMixType -> Pipette,
					MagneticBeadVolume -> 0.2 Milliliter,
					MagneticBeadSeparationQuinaryWashSolutionVolume -> 0.2 Milliliter,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuinaryWashMixVolume -> EqualP[0.2 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationQuinaryWashMixVolume, "If MagneticBeadSeparationQuinaryWashMixType is set to Pipette and 1/2 of the combined MagneticBeadSeparationQuinaryWashSolution and magnetic beads volume is greater than 970 microliters, MagneticBeadSeparationQuinaryWashMixVolume is automatically set to 970 microliters:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuinaryWashMixType -> Pipette,
					MagneticBeadSeparationQuinaryWashSolutionVolume -> 1.8 Milliliter,
					MagneticBeadVolume -> 0.2 Milliliter,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuinaryWashMixVolume -> EqualP[0.970 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationQuinaryWashMixTemperature Tests -- *)
			Example[{Options, MagneticBeadSeparationQuinaryWashMixTemperature, "If MagneticBeadSeparationQuinaryWashMix is set to True, MagneticBeadSeparationQuinaryWashMixTemperature is automatically set to Ambient:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuinaryWashMix -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuinaryWashMixTemperature -> Ambient
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationQuinaryWashMixTipType Tests -- *)
			Example[{Options, MagneticBeadSeparationQuinaryWashMixTipType, "If MagneticBeadSeparationQuinaryWashMixType is set to Pipette, MagneticBeadSeparationQuinaryWashMixTipType is automatically set to WideBore:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuinaryWashMixType -> Pipette,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuinaryWashMixTipType -> WideBore
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationQuinaryWashMixTipMaterial Tests -- *)
			Example[{Options, MagneticBeadSeparationQuinaryWashMixTipMaterial, "If MagneticBeadSeparationQuinaryWashMixType is set to Pipette, MagneticBeadSeparationQuinaryWashMixTipMaterial is automatically set to Polypropylene:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuinaryWashMixType -> Pipette,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuinaryWashMixTipMaterial -> Polypropylene
					}
				],
				TimeConstraint -> 1800
			],

			(* -- QuinaryWashMagnetizationTime Tests -- *)
			Example[{Options, QuinaryWashMagnetizationTime, "If MagneticBeadSeparationQuinaryWash is set to True, QuinaryWashMagnetizationTime is automatically set to 5 minutes:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuinaryWash -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						QuinaryWashMagnetizationTime -> EqualP[5 Minute]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationQuinaryWashAspirationVolume Tests -- *)
			Example[{Options, MagneticBeadSeparationQuinaryWashAspirationVolume, "If MagneticBeadSeparationQuinaryWash is set to True, MagneticBeadSeparationQuinaryWashAspirationVolume is automatically set the same as the MagneticBeadSeparationQuinaryWashSolutionVolume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuinaryWash -> True,
					MagneticBeadSeparationQuinaryWashSolutionVolume -> 0.2 Milliliter,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuinaryWashAspirationVolume -> EqualP[0.2 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationQuinaryWashCollectionContainer Tests -- *)
			Example[{Options, MagneticBeadSeparationQuinaryWashCollectionContainer, "If MagneticBeadSeparationQuinaryWash is set to True, MagneticBeadSeparationQuinaryWashCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuinaryWash -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuinaryWashCollectionContainer -> {{(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}}
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationQuinaryWashCollectionStorageCondition Tests -- *)
			Example[{Options, MagneticBeadSeparationQuinaryWashCollectionStorageCondition, "If MagneticBeadSeparationQuinaryWash is set to True, MagneticBeadSeparationQuinaryWashCollectionStorageCondition is automatically set to Refrigerator unless otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuinaryWash -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuinaryWashCollectionStorageCondition -> Refrigerator
					}
				],
				TimeConstraint -> 1800
			],

			(* -- NumberOfMagneticBeadSeparationQuinaryWashes Tests -- *)
			Example[{Options, NumberOfMagneticBeadSeparationQuinaryWashes, "If MagneticBeadSeparationQuinaryWash is True, NumberOfMagneticBeadSeparationQuinaryWashes is automatically set to 1:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuinaryWash -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						NumberOfMagneticBeadSeparationQuinaryWashes -> 1
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationQuinaryWashAirDry Tests -- *)
			Example[{Options, MagneticBeadSeparationQuinaryWashAirDry, "If MagneticBeadSeparationQuinaryWash is set to True, MagneticBeadSeparationQuinaryWashAirDry is automatically set to False:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuinaryWash -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuinaryWashAirDry -> False
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationQuinaryWashAirDryTime Tests -- *)
			Example[{Options, MagneticBeadSeparationQuinaryWashAirDryTime, "If MagneticBeadSeparationQuinaryWashAirDry is set to True, MagneticBeadSeparationQuinaryWashAirDryTime is automatically set to 1 Minute:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationQuinaryWashAirDry -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationQuinaryWashAirDryTime -> EqualP[1 Minute]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSenaryWash Tests -- *)
			Example[{Options, MagneticBeadSeparationSenaryWash, "If any magnetic bead separation senary wash options are set (MagneticBeadSeparationSenaryWashSolution, MagneticBeadSeparationSenaryWashSolutionVolume, MagneticBeadSeparationSenaryWashMix, etc.), MagneticBeadSeparationSenaryWash is automatically set to True:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSenaryWashMixType -> Shake,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSenaryWash -> True
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationSenaryWash, "If no magnetic bead separation senary wash options are set (MagneticBeadSeparationSenaryWashSolution, MagneticBeadSeparationSenaryWashSolutionVolume, MagneticBeadSeparationSenaryWashMix, etc.), MagneticBeadSeparationSenaryWash is automatically set to False:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> MagneticBeadSeparation,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSenaryWash -> False
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSenaryWashSolution Tests -- *)
			Example[{Options, MagneticBeadSeparationSenaryWashSolution, "If MagneticBeadSeparationSenaryWash is set to True, MagneticBeadSeparationSenaryWashSolution is automatically set to Model[Sample,\"Milli-Q water\"]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSenaryWash -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSenaryWashSolution -> ObjectP[Model[Sample,"Milli-Q water"]]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSenaryWashSolutionVolume Tests -- *)
			Example[{Options, MagneticBeadSeparationSenaryWashSolutionVolume, "If MagneticBeadSeparationSenaryWash and MagneticBeadSeparationPreWash are set to True, MagneticBeadSeparationSenaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationPreWashSolutionVolume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationPreWash -> True,
					MagneticBeadSeparationPreWashSolutionVolume -> 0.2 Milliliter,
					MagneticBeadSeparationSenaryWash -> True,
					(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSenaryWashSolutionVolume -> EqualP[0.2 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationSenaryWashSolutionVolume, "If MagneticBeadSeparationSenaryWash is set to True and MagneticBeadSeparationPreWash is set to False, MagneticBeadSeparationSenaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationSampleVolume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
					MagneticBeadSeparationPreWash -> False,
					MagneticBeadSeparationSenaryWash -> True,
					(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSenaryWashSolutionVolume -> EqualP[0.2 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSenaryWashMix Tests -- *)
			Example[{Options, MagneticBeadSeparationSenaryWashMix, "If MagneticBeadSeparationSenaryWash is set to True, MagneticBeadSeparationSenaryWashMix is automatically set to True:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSenaryWash -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSenaryWashMix -> True
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSenaryWashMixType Tests -- *)
			Example[{Options, MagneticBeadSeparationSenaryWashMixType, "If MagneticBeadSeparationSenaryWashMixRate or MagneticBeadSeparationSenaryWashMixTime are set, MagneticBeadSeparationSenaryWashMixType is automatically set to Shake:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSenaryWashMixTime -> 1 Minute,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSenaryWashMixType -> Shake
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationSenaryWashMixType, "If NumberOfMagneticBeadSeparationSenaryWashMixes or MagneticBeadSeparationSenaryWashMixVolume are set, MagneticBeadSeparationSenaryWashMixType is automatically set to Pipette:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					NumberOfMagneticBeadSeparationSenaryWashMixes -> 10,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSenaryWashMixType -> Pipette
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationSenaryWashMixType, "If no magnetic bead separation senary wash mix options are set, MagneticBeadSeparationSenaryWashMixType is automatically set to Pipette:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSenaryWashMix -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSenaryWashMixType -> Pipette
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSenaryWashMixTime Tests -- *)
			Example[{Options, MagneticBeadSeparationSenaryWashMixTime, "If MagneticBeadSeparationSenaryWashMixType is set to Shake, MagneticBeadSeparationSenaryWashMixTime is automatically set to 5 minutes:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSenaryWashMixType -> Shake,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSenaryWashMixTime -> EqualP[5 Minute]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSenaryWashMixRate Tests -- *)
			Example[{Options, MagneticBeadSeparationSenaryWashMixRate, "If MagneticBeadSeparationSenaryWashMixType is set to Shake, MagneticBeadSeparationSenaryWashMixRate is automatically set to 300 RPM:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSenaryWashMixType -> Shake,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSenaryWashMixRate -> EqualP[300 RPM]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- NumberOfMagneticBeadSeparationSenaryWashMixes Tests -- *)
			Example[{Options, NumberOfMagneticBeadSeparationSenaryWashMixes, "If MagneticBeadSeparationSenaryWashMixType is set to Pipette, NumberOfMagneticBeadSeparationSenaryWashMixes is automatically set to 10:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSenaryWashMixType -> Pipette,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						NumberOfMagneticBeadSeparationSenaryWashMixes -> 10
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSenaryWashMixVolume Tests -- *)
			Example[{Options, MagneticBeadSeparationSenaryWashMixVolume, "If MagneticBeadSeparationSenaryWashMixType is set to Pipette and 1/2 of the combined MagneticBeadSeparationSenaryWashSolution and magnetic beads volume is less than 970 microliters, MagneticBeadSeparationSenaryWashMixVolume is automatically set to 1/2 of the combined MagneticBeadSeparationSenaryWashSolution and magnetic beads volume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSenaryWashMixType -> Pipette,
					MagneticBeadVolume -> 0.2 Milliliter,
					MagneticBeadSeparationSenaryWashSolutionVolume -> 0.2 Milliliter,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSenaryWashMixVolume -> EqualP[0.2 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationSenaryWashMixVolume, "If MagneticBeadSeparationSenaryWashMixType is set to Pipette and 1/2 of the combined MagneticBeadSeparationSenaryWashSolution and magnetic beads volume is greater than 970 microliters, MagneticBeadSeparationSenaryWashMixVolume is automatically set to 970 microliters:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSenaryWashMixType -> Pipette,
					MagneticBeadSeparationSenaryWashSolutionVolume -> 1.8 Milliliter,
					MagneticBeadVolume -> 0.2 Milliliter,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSenaryWashMixVolume -> EqualP[0.970 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSenaryWashMixTemperature Tests -- *)
			Example[{Options, MagneticBeadSeparationSenaryWashMixTemperature, "If MagneticBeadSeparationSenaryWashMix is set to True, MagneticBeadSeparationSenaryWashMixTemperature is automatically set to Ambient:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSenaryWashMix -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSenaryWashMixTemperature -> Ambient
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSenaryWashMixTipType Tests -- *)
			Example[{Options, MagneticBeadSeparationSenaryWashMixTipType, "If MagneticBeadSeparationSenaryWashMixType is set to Pipette, MagneticBeadSeparationSenaryWashMixTipType is automatically set to WideBore:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSenaryWashMixType -> Pipette,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSenaryWashMixTipType -> WideBore
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSenaryWashMixTipMaterial Tests -- *)
			Example[{Options, MagneticBeadSeparationSenaryWashMixTipMaterial, "If MagneticBeadSeparationSenaryWashMixType is set to Pipette, MagneticBeadSeparationSenaryWashMixTipMaterial is automatically set to Polypropylene:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSenaryWashMixType -> Pipette,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSenaryWashMixTipMaterial -> Polypropylene
					}
				],
				TimeConstraint -> 1800
			],

			(* -- SenaryWashMagnetizationTime Tests -- *)
			Example[{Options, SenaryWashMagnetizationTime, "If MagneticBeadSeparationSenaryWash is set to True, SenaryWashMagnetizationTime is automatically set to 5 minutes:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSenaryWash -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						SenaryWashMagnetizationTime -> EqualP[5 Minute]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSenaryWashAspirationVolume Tests -- *)
			Example[{Options, MagneticBeadSeparationSenaryWashAspirationVolume, "If MagneticBeadSeparationSenaryWash is set to True, MagneticBeadSeparationSenaryWashAspirationVolume is automatically set the same as the MagneticBeadSeparationSenaryWashSolutionVolume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSenaryWash -> True,
					MagneticBeadSeparationSenaryWashSolutionVolume -> 0.2 Milliliter,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSenaryWashAspirationVolume -> EqualP[0.2 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSenaryWashCollectionContainer Tests -- *)
			Example[{Options, MagneticBeadSeparationSenaryWashCollectionContainer, "If MagneticBeadSeparationSenaryWash is set to True, MagneticBeadSeparationSenaryWashCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSenaryWash -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSenaryWashCollectionContainer -> {{(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}}
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSenaryWashCollectionStorageCondition Tests -- *)
			Example[{Options, MagneticBeadSeparationSenaryWashCollectionStorageCondition, "If MagneticBeadSeparationSenaryWash is set to True, MagneticBeadSeparationSenaryWashCollectionStorageCondition is automatically set to Refrigerator unless otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSenaryWash -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSenaryWashCollectionStorageCondition -> Refrigerator
					}
				],
				TimeConstraint -> 1800
			],

			(* -- NumberOfMagneticBeadSeparationSenaryWashes Tests -- *)
			Example[{Options, NumberOfMagneticBeadSeparationSenaryWashes, "If MagneticBeadSeparationSenaryWash is True, NumberOfMagneticBeadSeparationSenaryWashes is automatically set to 1:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSenaryWash -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						NumberOfMagneticBeadSeparationSenaryWashes -> 1
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSenaryWashAirDry Tests -- *)
			Example[{Options, MagneticBeadSeparationSenaryWashAirDry, "If MagneticBeadSeparationSenaryWash is set to True, MagneticBeadSeparationSenaryWashAirDry is automatically set to False:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSenaryWash -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSenaryWashAirDry -> False
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSenaryWashAirDryTime Tests -- *)
			Example[{Options, MagneticBeadSeparationSenaryWashAirDryTime, "If MagneticBeadSeparationSenaryWashAirDry is set to True, MagneticBeadSeparationSenaryWashAirDryTime is automatically set to 1 Minute:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSenaryWashAirDry -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSenaryWashAirDryTime -> EqualP[1 Minute]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSeptenaryWash Tests -- *)
			Example[{Options, MagneticBeadSeparationSeptenaryWash, "If any magnetic bead separation septenary wash options are set (MagneticBeadSeparationSeptenaryWashSolution, MagneticBeadSeparationSeptenaryWashSolutionVolume, MagneticBeadSeparationSeptenaryWashMix, etc.), MagneticBeadSeparationSeptenaryWash is automatically set to True:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSeptenaryWashMixType -> Shake,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					MagneticBeadSeparationSenaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSeptenaryWash -> True
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationSeptenaryWash, "If no magnetic bead separation septenary wash options are set (MagneticBeadSeparationSeptenaryWashSolution, MagneticBeadSeparationSeptenaryWashSolutionVolume, MagneticBeadSeparationSeptenaryWashMix, etc.), MagneticBeadSeparationSeptenaryWash is automatically set to False:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> MagneticBeadSeparation,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSeptenaryWash -> False
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSeptenaryWashSolution Tests -- *)
			Example[{Options, MagneticBeadSeparationSeptenaryWashSolution, "If MagneticBeadSeparationSeptenaryWash is set to True, MagneticBeadSeparationSeptenaryWashSolution is automatically set to Model[Sample,\"Milli-Q water\"]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSeptenaryWash -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					MagneticBeadSeparationSenaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSeptenaryWashSolution -> ObjectP[Model[Sample,"Milli-Q water"]]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSeptenaryWashSolutionVolume Tests -- *)
			Example[{Options, MagneticBeadSeparationSeptenaryWashSolutionVolume, "If MagneticBeadSeparationSeptenaryWash and MagneticBeadSeparationPreWash are set to True, MagneticBeadSeparationSeptenaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationPreWashSolutionVolume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationPreWash -> True,
					MagneticBeadSeparationPreWashSolutionVolume -> 0.2 Milliliter,
					MagneticBeadSeparationSeptenaryWash -> True,
					(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					MagneticBeadSeparationSenaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSeptenaryWashSolutionVolume -> EqualP[0.2 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationSeptenaryWashSolutionVolume, "If MagneticBeadSeparationSeptenaryWash is set to True and MagneticBeadSeparationPreWash is set to False, MagneticBeadSeparationSeptenaryWashSolutionVolume is automatically set to the same value as the MagneticBeadSeparationSampleVolume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
					MagneticBeadSeparationPreWash -> False,
					MagneticBeadSeparationSeptenaryWash -> True,
					(* MagneticBeadSeparationWash needs to be set to True avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					MagneticBeadSeparationSenaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSeptenaryWashSolutionVolume -> EqualP[0.2 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSeptenaryWashMix Tests -- *)
			Example[{Options, MagneticBeadSeparationSeptenaryWashMix, "If MagneticBeadSeparationSeptenaryWash is set to True, MagneticBeadSeparationSeptenaryWashMix is automatically set to True:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSeptenaryWash -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					MagneticBeadSeparationSenaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSeptenaryWashMix -> True
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSeptenaryWashMixType Tests -- *)
			Example[{Options, MagneticBeadSeparationSeptenaryWashMixType, "If MagneticBeadSeparationSeptenaryWashMixRate or MagneticBeadSeparationSeptenaryWashMixTime are set, MagneticBeadSeparationSeptenaryWashMixType is automatically set to Shake:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSeptenaryWashMixTime -> 1 Minute,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					MagneticBeadSeparationSenaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSeptenaryWashMixType -> Shake
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationSeptenaryWashMixType, "If NumberOfMagneticBeadSeparationSeptenaryWashMixes or MagneticBeadSeparationSeptenaryWashMixVolume are set, MagneticBeadSeparationSeptenaryWashMixType is automatically set to Pipette:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					NumberOfMagneticBeadSeparationSeptenaryWashMixes -> 10,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					MagneticBeadSeparationSenaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSeptenaryWashMixType -> Pipette
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationSeptenaryWashMixType, "If no magnetic bead separation septenary wash mix options are set, MagneticBeadSeparationSeptenaryWashMixType is automatically set to Pipette:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSeptenaryWashMix -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					MagneticBeadSeparationSenaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSeptenaryWashMixType -> Pipette
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSeptenaryWashMixTime Tests -- *)
			Example[{Options, MagneticBeadSeparationSeptenaryWashMixTime, "If MagneticBeadSeparationSeptenaryWashMixType is set to Shake, MagneticBeadSeparationSeptenaryWashMixTime is automatically set to 5 minutes:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSeptenaryWashMixType -> Shake,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					MagneticBeadSeparationSenaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSeptenaryWashMixTime -> EqualP[5 Minute]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSeptenaryWashMixRate Tests -- *)
			Example[{Options, MagneticBeadSeparationSeptenaryWashMixRate, "If MagneticBeadSeparationSeptenaryWashMixType is set to Shake, MagneticBeadSeparationSeptenaryWashMixRate is automatically set to 300 RPM:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSeptenaryWashMixType -> Shake,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					MagneticBeadSeparationSenaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSeptenaryWashMixRate -> EqualP[300 RPM]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- NumberOfMagneticBeadSeparationSeptenaryWashMixes Tests -- *)
			Example[{Options, NumberOfMagneticBeadSeparationSeptenaryWashMixes, "If MagneticBeadSeparationSeptenaryWashMixType is set to Pipette, NumberOfMagneticBeadSeparationSeptenaryWashMixes is automatically set to 10:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSeptenaryWashMixType -> Pipette,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					MagneticBeadSeparationSenaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						NumberOfMagneticBeadSeparationSeptenaryWashMixes -> 10
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSeptenaryWashMixVolume Tests -- *)
			Example[{Options, MagneticBeadSeparationSeptenaryWashMixVolume, "If MagneticBeadSeparationSeptenaryWashMixType is set to Pipette and 1/2 of the combined MagneticBeadSeparationSeptenaryWashSolution and magnetic beads volume is less than 970 microliters, MagneticBeadSeparationSeptenaryWashMixVolume is automatically set to 1/2 of the combined MagneticBeadSeparationSeptenaryWashSolution and magnetic beads volume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSeptenaryWashMixType -> Pipette,
					MagneticBeadVolume -> 0.2 Milliliter,
					MagneticBeadSeparationSeptenaryWashSolutionVolume -> 0.2 Milliliter,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					MagneticBeadSeparationSenaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSeptenaryWashMixVolume -> EqualP[0.2 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationSeptenaryWashMixVolume, "If MagneticBeadSeparationSeptenaryWashMixType is set to Pipette and 1/2 of the combined MagneticBeadSeparationSeptenaryWashSolution and magnetic beads volume is greater than 970 microliters, MagneticBeadSeparationSeptenaryWashMixVolume is automatically set to 970 microliters:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSeptenaryWashMixType -> Pipette,
					MagneticBeadSeparationSeptenaryWashSolutionVolume -> 1.8 Milliliter,
					MagneticBeadVolume -> 0.2 Milliliter,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					MagneticBeadSeparationSenaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSeptenaryWashMixVolume -> EqualP[0.970 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSeptenaryWashMixTemperature Tests -- *)
			Example[{Options, MagneticBeadSeparationSeptenaryWashMixTemperature, "If MagneticBeadSeparationSeptenaryWashMix is set to True, MagneticBeadSeparationSeptenaryWashMixTemperature is automatically set to Ambient:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSeptenaryWashMix -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					MagneticBeadSeparationSenaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSeptenaryWashMixTemperature -> Ambient
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSeptenaryWashMixTipType Tests -- *)
			Example[{Options, MagneticBeadSeparationSeptenaryWashMixTipType, "If MagneticBeadSeparationSeptenaryWashMixType is set to Pipette, MagneticBeadSeparationSeptenaryWashMixTipType is automatically set to WideBore:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSeptenaryWashMixType -> Pipette,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					MagneticBeadSeparationSenaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSeptenaryWashMixTipType -> WideBore
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSeptenaryWashMixTipMaterial Tests -- *)
			Example[{Options, MagneticBeadSeparationSeptenaryWashMixTipMaterial, "If MagneticBeadSeparationSeptenaryWashMixType is set to Pipette, MagneticBeadSeparationSeptenaryWashMixTipMaterial is automatically set to Polypropylene:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSeptenaryWashMixType -> Pipette,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					MagneticBeadSeparationSenaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSeptenaryWashMixTipMaterial -> Polypropylene
					}
				],
				TimeConstraint -> 1800
			],

			(* -- SeptenaryWashMagnetizationTime Tests -- *)
			Example[{Options, SeptenaryWashMagnetizationTime, "If MagneticBeadSeparationSeptenaryWash is set to True, SeptenaryWashMagnetizationTime is automatically set to 5 minutes:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSeptenaryWash -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					MagneticBeadSeparationSenaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						SeptenaryWashMagnetizationTime -> EqualP[5 Minute]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSeptenaryWashAspirationVolume Tests -- *)
			Example[{Options, MagneticBeadSeparationSeptenaryWashAspirationVolume, "If MagneticBeadSeparationSeptenaryWash is set to True, MagneticBeadSeparationSeptenaryWashAspirationVolume is automatically set the same as the MagneticBeadSeparationSeptenaryWashSolutionVolume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSeptenaryWash -> True,
					MagneticBeadSeparationSeptenaryWashSolutionVolume -> 0.2 Milliliter,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					MagneticBeadSeparationSenaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSeptenaryWashAspirationVolume -> EqualP[0.2 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSeptenaryWashCollectionContainer Tests -- *)
			Example[{Options, MagneticBeadSeparationSeptenaryWashCollectionContainer, "If MagneticBeadSeparationSeptenaryWash is set to True, MagneticBeadSeparationSeptenaryWashCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSeptenaryWash -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					MagneticBeadSeparationSenaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSeptenaryWashCollectionContainer -> {{(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}}
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSeptenaryWashCollectionStorageCondition Tests -- *)
			Example[{Options, MagneticBeadSeparationSeptenaryWashCollectionStorageCondition, "If MagneticBeadSeparationSeptenaryWash is set to True, MagneticBeadSeparationSeptenaryWashCollectionStorageCondition is automatically set to Refrigerator unless otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSeptenaryWash -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					MagneticBeadSeparationSenaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSeptenaryWashCollectionStorageCondition -> Refrigerator
					}
				],
				TimeConstraint -> 1800
			],

			(* -- NumberOfMagneticBeadSeparationSeptenaryWashes Tests -- *)
			Example[{Options, NumberOfMagneticBeadSeparationSeptenaryWashes, "If MagneticBeadSeparationSeptenaryWash is True, NumberOfMagneticBeadSeparationSeptenaryWashes is automatically set to 1:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSeptenaryWash -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					MagneticBeadSeparationSenaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						NumberOfMagneticBeadSeparationSeptenaryWashes -> 1
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSeptenaryWashAirDry Tests -- *)
			Example[{Options, MagneticBeadSeparationSeptenaryWashAirDry, "If MagneticBeadSeparationSeptenaryWash is set to True, MagneticBeadSeparationSeptenaryWashAirDry is automatically set to False:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSeptenaryWash -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					MagneticBeadSeparationSenaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSeptenaryWashAirDry -> False
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationSeptenaryWashAirDryTime Tests -- *)
			Example[{Options, MagneticBeadSeparationSeptenaryWashAirDryTime, "If MagneticBeadSeparationSeptenaryWashAirDry is set to True, MagneticBeadSeparationSeptenaryWashAirDryTime is automatically set to 1 Minute:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationSeptenaryWashAirDry -> True,
					(* Prior washes need to be set to True to avoid an error. *)
					MagneticBeadSeparationWash -> True,
					MagneticBeadSeparationSecondaryWash -> True,
					MagneticBeadSeparationTertiaryWash -> True,
					MagneticBeadSeparationQuaternaryWash -> True,
					MagneticBeadSeparationQuinaryWash -> True,
					MagneticBeadSeparationSenaryWash -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationSeptenaryWashAirDryTime -> EqualP[1 Minute]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationElution Tests -- *)
			Example[{Options, MagneticBeadSeparationElution, "If any magnetic bead separation elution options are set (MagneticBeadSeparationElutionSolution, MagneticBeadSeparationElutionSolutionVolume, MagneticBeadSeparationElutionMix, etc.), MagneticBeadSeparationElution is automatically set to True:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationElutionMixType -> Shake,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationElution -> True
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationElution, "If MagneticBeadSeparationSelectionStrategy is Positive, MagneticBeadSeparationElution is automatically set to True:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> MagneticBeadSeparation,
					MagneticBeadSeparationSelectionStrategy -> Positive,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationElution -> True
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationElution, "If no magnetic bead separation elution options are set (MagneticBeadSeparationElutionSolution, MagneticBeadSeparationElutionSolutionVolume, MagneticBeadSeparationElutionMix, etc.) and MagneticBeadSeparationSelectionStrategy is Negative, MagneticBeadSeparationElution is automatically set to False:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> MagneticBeadSeparation,
					MagneticBeadSeparationSelectionStrategy -> Negative,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationElution -> False
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationElutionSolution Tests -- *)
			Example[{Options, MagneticBeadSeparationElutionSolution, "If MagneticBeadSeparationElution is set to True, MagneticBeadSeparationElutionSolution is automatically set to Model[Sample,\"Milli-Q water\"]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationElution -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationElutionSolution -> ObjectP[Model[Sample,"Milli-Q water"]]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationElutionSolutionVolume Tests -- *)
			Example[{Options, MagneticBeadSeparationElutionSolutionVolume, "If MagneticBeadSeparationElution is set to True, MagneticBeadSeparationElutionSolutionVolume is automatically set 1/10 of the MagneticBeadSeparationSampleVolume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationElution -> True,
					MagneticBeadSeparationSampleVolume -> 0.2 Milliliter,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationElutionSolutionVolume -> EqualP[0.02 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationElutionMix Tests -- *)
			Example[{Options, MagneticBeadSeparationElutionMix, "If MagneticBeadSeparationElution is set to True, MagneticBeadSeparationElutionMix is automatically set to True:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationElution -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationElutionMix -> True
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationElutionMixType Tests -- *)
			Example[{Options, MagneticBeadSeparationElutionMixType, "If MagneticBeadSeparationElutionMixRate or MagneticBeadSeparationElutionMixTime are set, MagneticBeadSeparationElutionMixType is automatically set to Shake:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationElutionMixTime -> 1 Minute,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationElutionMixType -> Shake
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationElutionMixType, "If NumberOfMagneticBeadSeparationElutionMixes or MagneticBeadSeparationElutionMixVolume are set, MagneticBeadSeparationElutionMixType is automatically set to Pipette:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					NumberOfMagneticBeadSeparationElutionMixes -> 10,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationElutionMixType -> Pipette
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationElutionMixType, "If no magnetic bead separation elution mix options are set, MagneticBeadSeparationElutionMixType is automatically set to Pipette:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationElutionMix -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationElutionMixType -> Pipette
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationElutionMixTime Tests -- *)
			Example[{Options, MagneticBeadSeparationElutionMixTime, "If MagneticBeadSeparationElutionMixType is set to Shake, MagneticBeadSeparationElutionMixTime is automatically set to 5 minutes:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationElutionMixType -> Shake,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationElutionMixTime -> EqualP[5 Minute]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationElutionMixRate Tests -- *)
			Example[{Options, MagneticBeadSeparationElutionMixRate, "If MagneticBeadSeparationElutionMixType is set to Shake, MagneticBeadSeparationElutionMixRate is automatically set to 300 RPM:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationElutionMixType -> Shake,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationElutionMixRate -> EqualP[300 RPM]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- NumberOfMagneticBeadSeparationElutionMixes Tests -- *)
			Example[{Options, NumberOfMagneticBeadSeparationElutionMixes, "If MagneticBeadSeparationElutionMixType is set to Pipette, NumberOfMagneticBeadSeparationElutionMixes is automatically set to 10:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationElutionMixType -> Pipette,
					Output->Options
				],
				KeyValuePattern[
					{
						NumberOfMagneticBeadSeparationElutionMixes -> 10
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationElutionMixVolume Tests -- *)
			Example[{Options, MagneticBeadSeparationElutionMixVolume, "If MagneticBeadSeparationElutionMixType is set to Pipette and 1/2 of the combined MagneticBeadSeparationElutionSolutionVolume and MagneticBeadVolume is less than 970 microliters, MagneticBeadSeparationElutionMixVolume is automatically set to 1/2 of theMagneticBeadSeparationElutionSolutionVolume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationElutionMixType -> Pipette,
					MagneticBeadVolume -> 0.2 Milliliter,
					MagneticBeadSeparationElutionSolutionVolume -> 0.2 Milliliter,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationElutionMixVolume -> EqualP[0.2 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],
			Example[{Options, MagneticBeadSeparationElutionMixVolume, "If MagneticBeadSeparationElutionMixType is set to Pipette and 1/2 of the combined MagneticBeadSeparationElutionSolutionVolume and MagneticBeadVolume is greater than 970 microliters, MagneticBeadSeparationElutionMixVolume is automatically set to 970 microliters:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationElutionMixType -> Pipette,
					MagneticBeadSeparationElutionSolutionVolume -> 1.8 Milliliter,
					MagneticBeadVolume -> 0.2 Milliliter,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationElutionMixVolume -> EqualP[0.970 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationElutionMixTemperature Tests -- *)
			Example[{Options, MagneticBeadSeparationElutionMixTemperature, "If MagneticBeadSeparationElutionMix is set to True, MagneticBeadSeparationElutionMixTemperature is automatically set to Ambient:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationElutionMix -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationElutionMixTemperature -> Ambient
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationElutionMixTipType Tests -- *)
			Example[{Options, MagneticBeadSeparationElutionMixTipType, "If MagneticBeadSeparationElutionMixType is set to Pipette, MagneticBeadSeparationElutionMixTipType is automatically set to WideBore:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationElutionMixType -> Pipette,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationElutionMixTipType -> WideBore
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationElutionMixTipMaterial Tests -- *)
			Example[{Options, MagneticBeadSeparationElutionMixTipMaterial, "If MagneticBeadSeparationElutionMixType is set to Pipette, MagneticBeadSeparationElutionMixTipMaterial is automatically set to Polypropylene:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationElutionMixType -> Pipette,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationElutionMixTipMaterial -> Polypropylene
					}
				],
				TimeConstraint -> 1800
			],

			(* -- ElutionMagnetizationTime Tests -- *)
			Example[{Options, ElutionMagnetizationTime, "If MagneticBeadSeparationElution is set to True, ElutionMagnetizationTime is automatically set to 5 minutes:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationElution -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						ElutionMagnetizationTime -> EqualP[5 Minute]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationElutionAspirationVolume Tests -- *)
			Example[{Options, MagneticBeadSeparationElutionAspirationVolume, "If MagneticBeadSeparationElution is set to True, MagneticBeadSeparationElutionAspirationVolume is automatically set the same as the MagneticBeadSeparationElutionSolutionVolume:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationElution -> True,
					MagneticBeadSeparationElutionSolutionVolume -> 0.2 Milliliter,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationElutionAspirationVolume -> EqualP[0.2 Milliliter]
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationElutionCollectionContainer Tests -- *)
			Example[{Options, MagneticBeadSeparationElutionCollectionContainer, "If MagneticBeadSeparationElution is set to True, MagneticBeadSeparationElutionCollectionContainer is automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate, Sterile\"]:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationElution -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationElutionCollectionContainer -> {(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]]}
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparationElutionCollectionStorageCondition Tests -- *)
			Example[{Options, MagneticBeadSeparationElutionCollectionStorageCondition, "If MagneticBeadSeparationElution is set to True, MagneticBeadSeparationElutionCollectionStorageCondition is automatically set to Refrigerator unless otherwise specified:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationElution -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						MagneticBeadSeparationElutionCollectionStorageCondition -> Refrigerator
					}
				],
				TimeConstraint -> 1800
			],

			(* -- NumberOfMagneticBeadSeparationElutions Tests -- *)
			Example[{Options, NumberOfMagneticBeadSeparationElutions, "If MagneticBeadSeparationElution is True, NumberOfMagneticBeadSeparationElutions is automatically set to 1:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					MagneticBeadSeparationElution -> True,
					Output->Options
				],
				KeyValuePattern[
					{
						NumberOfMagneticBeadSeparationElutions -> 1
					}
				],
				TimeConstraint -> 1800
			],

			(* -- NumberOfMagneticBeadSeparationElutions Tests -- *)
			Example[{Options, NumberOfMagneticBeadSeparationElutions, "If NumberOfMagneticBeadSeparationElutions is set to larger than 1, samples collected from multiple rounds are pooled to one container (and to one well if applicable):"},
				myFunction[
					previouslyExtractedSampleInPlate,
					NumberOfMagneticBeadSeparationElutions -> 3,
					Output->Options
				],
				KeyValuePattern[
					{
						NumberOfMagneticBeadSeparationElutions -> 3,
						MagneticBeadSeparationElutionCollectionContainer -> {(_String),ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]]}
					}
				],
				TimeConstraint -> 1800
			],

			(* -- MagneticBeadSeparation collection container formats -- *)
			Example[{Options, {MagneticBeadSeparationPreWashCollectionContainer,MagneticBeadSeparationEquilibrationCollectionContainer,MagneticBeadSeparationLoadingCollectionContainer,MagneticBeadSeparationWashCollectionContainer,MagneticBeadSeparationSecondaryWashCollectionContainer,MagneticBeadSeparationElutionCollectionContainer}, "The collection containers can be specied in a variety of formats for all stages of magnetic bead separation:"},
				myFunction[
					previouslyExtractedSampleInPlate,
					Purification -> MagneticBeadSeparation,
					MagneticBeadSeparationPreWashCollectionContainer -> {"A1", Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]},
					NumberOfMagneticBeadSeparationPreWashes -> 2,
					MagneticBeadSeparationEquilibrationCollectionContainer -> {"A2", Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]},
					MagneticBeadSeparationLoadingCollectionContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
					MagneticBeadSeparationWashCollectionContainer -> {"A1", {1, Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]}},
					NumberOfMagneticBeadSeparationWashes -> 1,
					MagneticBeadSeparationSecondaryWashCollectionContainer -> {"A1", {2, Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]}},
					NumberOfMagneticBeadSeparationSecondaryWashes -> 3,
					NumberOfMagneticBeadSeparationElutions -> 2,
					MagneticBeadSeparationElutionCollectionContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
					Output -> Result],
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				TimeConstraint -> 1800
			],
			(* -- MagneticBeadSeparation collection container formats -- *)
			Example[{Options, {MagneticBeadSeparationPreWashCollectionContainer,MagneticBeadSeparationEquilibrationCollectionContainer,MagneticBeadSeparationLoadingCollectionContainer,MagneticBeadSeparationWashCollectionContainer,MagneticBeadSeparationSecondaryWashCollectionContainer,MagneticBeadSeparationElutionCollectionContainer}, "For multiple input samples, the collection containers can be specied in a variety of formats for all stages of magnetic bead separation:"},
				ExperimentExtractProtein[{
					previouslyExtractedSampleInPlate,
					lysateSample
				},
					Purification -> MagneticBeadSeparation,
					MagneticBeadSeparationPreWashCollectionContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
					NumberOfMagneticBeadSeparationPreWashes -> 2,
					MagneticBeadSeparationEquilibrationCollectionContainer -> {{"A2", Model[Container, Plate,
						"96-well 2mL Deep Well Plate, Sterile"]}, {"A1",Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]}},
					MagneticBeadSeparationLoadingCollectionContainer -> {"A1", Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]},
					MagneticBeadSeparationWashCollectionContainer -> {"A1", {1, Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]}},
					NumberOfMagneticBeadSeparationWashes -> 1,
					MagneticBeadSeparationSecondaryWashCollectionContainer -> {{"A1", {1, Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]}}, {"A2", {1, Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]}}},
					NumberOfMagneticBeadSeparationSecondaryWashes -> 3,
					NumberOfMagneticBeadSeparationElutions -> 2,
					MagneticBeadSeparationElutionCollectionContainer -> {Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"], Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"]},
					Output -> Result
				],
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				TimeConstraint -> 1800
			]

		};
