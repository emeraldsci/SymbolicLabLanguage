(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*validUnitOperationQTests*)


validUnitOperationQTests[packet:PacketP[Object[UnitOperation]]]:= {};
validUnitOperationTransferQTests[packet:PacketP[Object[UnitOperation, Transfer]]]:= {};
validUnitOperationFillToVolumeQTests[packet:PacketP[Object[UnitOperation, FillToVolume]]]:= {};
validUnitOperationAliquotQTests[packet:PacketP[Object[UnitOperation, Aliquot]]]:= {};
validUnitOperationLiquidLiquidExtractionQTests[packet:PacketP[Object[UnitOperation, LiquidLiquidExtraction]]]:= {};
validUnitOperationFilterQTests[packet:PacketP[Object[UnitOperation, Filter]]]:={
	(* required for all filters: *)
	Test["At least one of SampleLink, SampleString, and SampleExpression needs to be populated:",
		MapThread[
			Or[
				MatchQ[#1, ObjectP[]],
				MatchQ[#2, _String],
				Not[NullQ[#3]]
			]&,
			Lookup[packet, {SampleLink, SampleString, SampleExpression}]
		],
		{True..}
	]
};
validUnitOperationDiluteQTests[packet:PacketP[Object[UnitOperation, Dilute]]]:={};
validUnitOperationResuspendQTests[packet:PacketP[Object[UnitOperation, Resuspend]]]:={};
validUnitOperationDegasQTests[packet:PacketP[Object[UnitOperation, Degas]]]:={};
validUnitOperationCentrifugeQTests[packet:PacketP[Object[UnitOperation, Centrifuge]]]:= {
	
	(* Required for both robotic and manual unit operation*)
	NotNullFieldTest[packet,{
		Instrument,
		Intensity,
		Time,
		Sterile
		(* Temperature*)
	}],
	
	(* required field for a batched centrifuge unit operations *)
	If[
		MatchQ[Lookup[packet,UnitOperationType], Batched],
		NotNullFieldTest[packet,
			{
				BatchParameters,
				BucketPlacements,
				ContainerPlacements,
				CounterweightPlacements
			}
		],
		Nothing
	],
	
	(* fields that are unique to ultracentrifuge*)
	If[
		MatchQ[Lookup[packet,UnitOperationType], Batched],
		RequiredTogetherTest[packet,
			{
				SampleCap,
				CounterbalanceCap,
				StickerSheet}
		],
		Nothing
	]
};

validUnitOperationCoulterCountQTests[packet:PacketP[Object[UnitOperation,CoulterCount]]]:={
	(* fields that should be populated *)
	NotNullFieldTest[
		(* Unique fields *)
		Instrument,
		ApertureTube,
		ApertureDiameter,
		ElectrolyteSolutionVolume,
		ElectrolyteSolutionFlushVolume,
		FlushFlowRate,
		FlushTime,
		SystemSuitabilityCheck,
		Dilute,
		SampleAmount,
		ElectrolyteSampleDilutionVolume,
		ElectrolytePercentage,
		NumberOfReadings,
		FlowRate,
		MinParticleSize,
		EquilibrationTime,
		StopCondition,
		ElectrolyteSolutionStorageCondition
	],

	(* fields that should be null *)
	NullFieldTest[
		(* no sample prep filter fields *)
		Filtration,
		FiltrationType,
		FilterInstrument,
		FilterLink,
		FilterString,
		FilterExpression,
		FilterMaterial,
		PrefilterMaterial,
		FilterPoreSize,
		PrefilterPoreSize,
		FilterSyringe,
		FilterHousingLink,
		FilterHousingExpression,
		FilterIntensity,
		FilterTime,
		FilterTemperature,
		FilterContainerOutLink,
		FilterContainerOutString,
		FilterContainerOutExpression,
		FilterAliquotDestinationWell,
		FilterAliquotContainerLink,
		FilterAliquotContainerString,
		FilterAliquotContainerExpression,
		FilterAliquotReal,
		FilterAliquotExpression,
		FilterSterile,
		(* no incubate/mix fields *)
		Incubate,
		Thaw,
		IncubationTemperatureReal,
		IncubationTemperatureExpression,
		IncubationTime,
		AnnealingTime,
		Mix,
		MixType,
		MixUntilDissolved,
		MaxIncubationTime,
		IncubationInstrument,
		IncubateAliquotContainerLink,
		IncubateAliquotContainerExpression,
		IncubateAliquotDestinationWell,
		IncubateAliquotReal,
		IncubateAliquotExpression,
		(* no centrifuge fields *)
		Centrifuge,
		CentrifugeInstrument,
		CentrifugeIntensity,
		CentrifugeTime,
		CentrifugeTemperatureReal,
		CentrifugeTemperatureExpression,
		CentrifugeAliquotContainerLink,
		CentrifugeAliquotContainerExpression,
		CentrifugeAliquotDestinationWell,
		CentrifugeAliquotReal,
		CentrifugeAliquotExpression,
		(* no sample out *)
		SamplesOutStorageCondition
	],

	(* if we are doing system suitability check, the corresponding index matched options should be populated; if no suitability check, the corresponding index matched fields should all be Null *)
	indexMatchingRequiredTogetherTest[packet,
		{
			SuitabilityParticleSize,
			SuitabilityTargetConcentration,
			SuitabilitySampleAmount,
			SuitabilityElectrolyteSampleDilutionVolume,
			NumberOfSuitabilityReadings,
			SuitabilityFlowRate,
			MinSuitabilityParticleSize,
			SuitabilityEquilibrationTime,
			SuitabilityStopCondition
		}
	],

	(* if Dilute is True for SamplesIn, the corresponding Dilution options should be populated *)
	indexMatchingRequiredTogetherTest[packet,
		{
			DilutionType,
			NumberOfDilutions,
			TargetAnalyte,
			CumulativeDilutionFactor,
			TargetAnalyteConcentration,
			TransferVolume,
			TotalDilutionVolume,
			FinalVolume,
			DilutionIncubate
		}
	],

	(* if incubating during dilution, the corresponding incubate options should be populated *)
	indexMatchingRequiredTogetherTest[packet,
		{
			DilutionIncubationTime,
			DilutionIncubationInstrument,
			DilutionIncubationTemperature,
			DilutionMixType
		}
	]
};

validUnitOperationMeasureContactAngleQTests[packet:PacketP[Object[UnitOperation,MeasureContactAngle]]]:={};
validUnitOperationMeasureRefractiveIndexQTests[packet:PacketP[Object[UnitOperation,MeasureRefractiveIndex]]]:={};
validUnitOperationLyseCellsQTests[packet:PacketP[Object[UnitOperation,LyseCells]]]:={};
validUnitOperationDesiccateQTests[packet:PacketP[Object[UnitOperation,Desiccate]]]:={};
validUnitOperationGrindQTests[packet:PacketP[Object[UnitOperation,Grind]]]:={};
validUnitOperationMeasureMeltingPointQTests[packet:PacketP[Object[UnitOperation,MeasureMeltingPoint]]]:={};
validUnitOperationExtractRNAQTests[packet:PacketP[Object[UnitOperation, ExtractRNA]]]:={};
validUnitOperationExtractPlasmidDNATests[packet:Object[UnitOperation, ExtractPlasmidDNA]]={};
validUnitOperationExtractProteinTests[packet:Object[UnitOperation, ExtractProtein]]={};
validUnitOperationFreezeCellsTests[packet:Object[UnitOperation, FreezeCells]]={};

(* ::Subsection::Closed:: *)
(* Test Registration *)

registerValidQTestFunction[Object[UnitOperation],validUnitOperationQTests];
registerValidQTestFunction[Object[UnitOperation,Transfer],validUnitOperationTransferQTests];
registerValidQTestFunction[Object[UnitOperation,FillToVolume],validUnitOperationFillToVolumeQTests];
registerValidQTestFunction[Object[UnitOperation,Aliquot],validUnitOperationAliquotQTests];
registerValidQTestFunction[Object[UnitOperation,LiquidLiquidExtraction],validUnitOperationLiquidLiquidExtractionQTests];
registerValidQTestFunction[Object[UnitOperation,Filter],validUnitOperationFilterQTests];
registerValidQTestFunction[Object[UnitOperation,Dilute],validUnitOperationDiluteQTests];
registerValidQTestFunction[Object[UnitOperation,CoulterCount],validUnitOperationCoulterCountQTests];
registerValidQTestFunction[Object[UnitOperation,Resuspend],validUnitOperationResuspendQTests];
registerValidQTestFunction[Object[UnitOperation,Degas],validUnitOperationDegasQTests];
registerValidQTestFunction[Object[UnitOperation,Centrifuge],validUnitOperationCentrifugeQTests];
registerValidQTestFunction[Object[UnitOperation,MeasureRefractiveIndex],validUnitOperationCoulterCountQTests];
registerValidQTestFunction[Object[UnitOperation,MeasureContactAngle],validUnitOperationMeasureContactAngleQTests];
registerValidQTestFunction[Object[UnitOperation,MeasureRefractiveIndex],validUnitOperationMeasureRefractiveIndexQTests];
registerValidQTestFunction[Object[UnitOperation,LyseCells],validUnitOperationLyseCellsQTests];
registerValidQTestFunction[Object[UnitOperation,Desiccate],validUnitOperationDesiccateQTests];
registerValidQTestFunction[Object[UnitOperation,Grind],validUnitOperationGrindQTests];
registerValidQTestFunction[Object[UnitOperation,MeasureMeltingPoint],validUnitOperationMeasureMeltingPointQTests];
registerValidQTestFunction[Object[UnitOperation, ExtractRNA], validUnitOperationExtractRNAQTests];
registerValidQTestFunction[Object[UnitOperation, ExtractPlasmidDNA], validUnitOperationExtractPlasmidDNATests];
registerValidQTestFunction[Object[UnitOperation, ExtractProtein], validUnitOperationExtractProteinTests];
registerValidQTestFunction[Object[UnitOperation, FreezeCells], validUnitOperationFreezeCellsTests];