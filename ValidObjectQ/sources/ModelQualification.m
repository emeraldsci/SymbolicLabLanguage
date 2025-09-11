(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *) 


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*validModelQualificationQTests*)


validModelQualificationQTests[packet:PacketP[Model[Qualification]]] := {

	(*(* General fields filled in *)
	NotNullFieldTest[packet,{Authors,Purpose}],*)

	(* Additional fields that must be filled in if active*)
	If[!MemberQ[Lookup[packet,{Deprecated,DeveloperObject}],True] && !MatchQ[packet,ObjectP[Model[Qualification,InteractiveTraining]]],
		NotNullFieldTest[packet,{Targets}],
		Nothing
	],

	(* Linked Objects *)
	ObjectTypeTest[packet,Objects]
	
};


(* ::Subsection::Closed:: *)
(*validModelQualificationAcousticLiquidHandlerQTests*)


validModelQualificationAcousticLiquidHandlerQTests[packet:PacketP[Model[Qualification,AcousticLiquidHandler]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{
			PreparatoryUnitOperations,
			MaxDMSOStandardDeviation,
			Sources,
			Destinations,
			Amounts
		}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument, LiquidHandler, AcousticLiquidHandler]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument, LiquidHandler, AcousticLiquidHandler]]...}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationAutoclaveQTests*)


validModelQualificationAutoclaveQTests[packet:PacketP[Model[Qualification,Autoclave]]]:={
	(* must always be informed *)
	NotNullFieldTest[
		packet,
		{
			AutoclaveProgram,
			IndicatorModel,
			BioHazardBagModel,
			AutoclaveTapeModel,
			IndicatorModel,
			ControlIndicatorModel,
			VortexModel,
			IncubationTime
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationBiosafetyCabinetQTests*)


validModelQualificationBiosafetyCabinetQTests[packet : PacketP[Model[Qualification, BiosafetyCabinet]]] := {

	(* required fields *)
	NotNullFieldTest[
		packet,
		{TestLight, TestUVLight, TestAlarm, RecordFlowSpeed, RecordLaminarFlowSpeed, ImageCertification}
	],

	Test["At least one test must be performed:",
		Lookup[packet, {TestLight, TestUVLight, TestAlarm, RecordFlowSpeed, RecordLaminarFlowSpeed, ImageCertification}],
		{___, True, ___}
	],

	Test["If ImageCertification is True, ExampleCertificationImage must be informed:",
		If[
			Lookup[packet, ImageCertification],
			MatchQ[
				Lookup[packet, ExampleCertificationImage],
				ObjectP[Object[EmeraldCloudFile]]
			],
			True
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationBottleRollerQTests*)


validModelQualificationBottleRollerQTests[packet:PacketP[Model[Qualification,BottleRoller]]]:={
	
	(* required fields *)
	RequiredTogetherTest[
		packet,
		{Tachometer,ExpectedRotationRate,MaxRotationRateError}
	],
	
	AnyInformedTest[
		packet,
		{PreparatoryUnitOperations, Tachometer}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationBalanceQTests*)


validModelQualificationBalanceQTests[packet:PacketP[Model[Qualification,Balance]]]:={
	
	(* must always be informed *)
	NotNullFieldTest[
		packet,
		{
			CalibrationWeights,
			WeightHandles
		}
	]
};



validModelQualificationCapillaryELISAQTests[packet:PacketP[Model[Qualification,CapillaryELISA]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{PreparatoryUnitOperations}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,CapillaryELISA]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,CapillaryELISA]]...}
	]
};

validModelQualificationELISAQTests[packet:PacketP[Model[Qualification,ELISA]]]:={


	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,LiquidHandler]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,LiquidHandler]]...}
	]
};

(* ::Subsection::Closed:: *)
(*validModelQualificationCentrifugeQTests*)


validModelQualificationCentrifugeQTests[packet:PacketP[Model[Qualification,Centrifuge]]]:={
	
	(* required fields *)
	NotNullFieldTest[
		packet,
		{PreparatoryUnitOperations}
	],
	
	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,Centrifuge]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,Centrifuge]]...}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationColonyHandlerQTests*)


validModelQualificationColonyHandlerQTests[packet:PacketP[Model[Qualification, ColonyHandler]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{ImageStrategies, PickColonies, SpreadCells}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,ColonyHandler]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,ColonyHandler]]...}
	]
};

(* ::Subsection::Closed:: *)
(*validModelQualificationConductivityMeterQTests*)


validModelQualificationConductivityMeterQTests[packet:PacketP[Model[Qualification,ConductivityMeter]]]:= {
	NotNullFieldTest[packet, {ConductivityStandards, Probes}]
};

(* ::Subsection::Closed:: *)
(*validModelQualificationConductivityMeterQTests*)


validModelQualificationCrossFlowFiltrationQTests[packet:PacketP[Model[Qualification,CrossFlowFiltration]]]:={
	
	NotNullFieldTest[packet,{
		PreparatoryUnitOperations,
		CalibrationWeights
	}]
};

(* ::Subsection::Closed:: *)
(*validModelQualificationCryogenicFreezerQTests*)


validModelQualificationCryogenicFreezerQTests[packet:PacketP[Model[Qualification,CryogenicFreezer]]]:={
	
	(* required fields *)
	NotNullFieldTest[
		packet,
		{
			AutomaticExecutionFunction,
			TimePeriod,
			SamplingRate,
			MeanTarget,
			MeanTolerance,
			StandardDeviationTolerance,
			MaintenanceRecoveryTime
		}
	],
	
	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,CryogenicFreezer]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,CryogenicFreezer]]...}
	]
};

(* ::Subsection::Closed:: *)
(*validModelQualificationCrystalIncubatorQTests*)


validModelQualificationCrystalIncubatorQTests[packet:PacketP[Model[Qualification,CrystalIncubator]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{SampleModel,SampleVolume,SampleWells,CrystallizationPlate,CrystallizationCover,MaxCrystallizationTime,CrystalScoreThreshold,BlankScoreThreshold}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,CrystalIncubator]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,CrystalIncubator]]...}
	]
};

(* ::Subsection::Closed:: *)
(*validModelQualificationControlledRateFreezerQTests*)


validModelQualificationControlledRateFreezerQTests[packet:PacketP[Model[Qualification,ControlledRateFreezer]]]:={

	NotNullFieldTest[packet,
		{
			QualificationSample
		}
	]
};

(* ::Subsection::Closed:: *)
(*validModelQualificationCoulterCounterQTests*)


validModelQualificationCoulterCounterQTests[packet:PacketP[Model[Qualification, CoulterCounter]]] := {

	(* required fields *)
	NotNullFieldTest[packet,
		{
			Target
		}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,CoulterCounter]:",
		Lookup[packet, Targets],
		{LinkP[Model[Instrument, CoulterCounter]]...}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationDensityMeterQTests*)


validModelQualificationDensityMeterQTests[packet:PacketP[Model[Qualification,DensityMeter]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{PreparatoryUnitOperations, ExpectedDensity, DensityTolerance}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,DensityMeter]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,DensityMeter]]...}
	]
};



(* ::Subsection::Closed:: *)
(* validModelQualificationDesiccatorQTests *)


validModelQualificationDesiccatorQTests[packet : PacketP[Model[Qualification, Desiccator]]] := {

	(* required fields *)
	NotNullFieldTest[
		packet,
		{
			QualificationSample,
			Amount,
			Method,
			Time
		}
	],

	RequiredTogetherTest[packet, {Desiccant, DesiccantAmount}],

	Test["Desiccant and DesiccantAmount must be informed only if Method is StandardDesiccant or DesiccantUnderVacuum:",
		If[
			Or[
				NullQ[Lookup[packet, Desiccant]],
				NullQ[Lookup[packet, DesiccantAmount]]
			],
			MatchQ[Lookup[packet, Method], Vacuum],
			MatchQ[Lookup[packet, Method], StandardDesiccant | DesiccantUnderVacuum]
		],
		True
	]
};



(* ::Subsection::Closed:: *)
(*validModelQualificationDewarQTests*)


validModelQualificationDewarQTests[packet:PacketP[Model[Qualification,Dewar]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{PreparatoryUnitOperations}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,Dewar]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,Dewar]]...}
	]
};



(* ::Subsection::Closed:: *)
(*validModelQualificationDialyzerQTests*)


validModelQualificationDialyzerQTests[packet:PacketP[Model[Qualification,Dialyzer]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{PreparatoryUnitOperations}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,Dialyzer]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,Dialyzer]]...}
	]

};


(* ::Subsection::Closed:: *)
(*validModelQualificationDifferentialScanningCalorimeterQTests*)


validModelQualificationDifferentialScanningCalorimeterQTests[packet:PacketP[Model[Qualification,DifferentialScanningCalorimeter]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{PreparatoryUnitOperations}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument, DifferentialScanningCalorimeter]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument, DifferentialScanningCalorimeter]]...}
	]
};



(* ::Subsection::Closed:: *)
(*validModelQualificationDiffractometerQTests*)


validModelQualificationDiffractometerQTests[packet:PacketP[Model[Qualification,Diffractometer]]]:={
	(* required fields *)
	NotNullFieldTest[packet,
		{
			TestSamples,
			LinePositionTestSample,
			BlankSample,
			TransferType,
			LinePositionTestAngles,
			DetectorRotations,
			DetectorDistances,
			ExposureTimes,
			LinePositionAccuracyTestCriterion,
			LinePositionPrecisionTestCriterion
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationNutatorQTests*)


validModelQualificationDisruptorQTests[packet:PacketP[Model[Qualification,Disruptor]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{PreparatoryUnitOperations, DisruptionSpeed, DisruptionTime}
	],

	(* When we use a tachometer, need these fields together *)
	RequiredTogetherTest[
		packet,
		{Tachometer, ExpectedLinearSpeed, MaxLinearSpeedError}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,Disruptor]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,Disruptor]]...}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationDissolvedOxygenMeterQTests*)


validModelQualificationDissolvedOxygenMeterQTests[packet:PacketP[Model[Qualification,DissolvedOxygenMeter]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{PreparatoryUnitOperations}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,DissolvedOxygenMeter]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,DissolvedOxygenMeter]]...}
	]

};


(* ::Subsection::Closed:: *)
(*validModelQualificationDNASynthesizerQTests*)


validModelQualificationDNASynthesizerQTests[packet:PacketP[Model[Qualification,DNASynthesizer]]]:={

	(* required fields *)

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,DNASynthesizer]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,DNASynthesizer]]...}
	]
};



(* ::Subsection::Closed:: *)
(*validModelQualificationDynamicFoamAnalyzerQTests*)


validModelQualificationDynamicFoamAnalyzerQTests[packet:PacketP[Model[Qualification,DynamicFoamAnalyzer]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{PreparatoryUnitOperations}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,DynamicFoamAnalyzer]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,DynamicFoamAnalyzer]]...}
	]
};



(* ::Subsection::Closed:: *)
(*validModelQualificationElectrochemicalReactorQTests*)


validModelQualificationElectrochemicalReactorQTests[packet:PacketP[Model[Qualification,ElectrochemicalReactor]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{PreparatoryUnitOperations}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,Reactor,Electrochemical]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,Reactor,Electrochemical]]...}
	]
};



(* ::Subsection::Closed:: *)
(*validModelQualificationElectrophoresisQTests*)


validModelQualificationElectrophoresisQTests[packet:PacketP[Model[Qualification,Electrophoresis]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{PreparatoryUnitOperations}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,Homogenizer]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,Electrophoresis]]...}
	]
};

(* ::Subsection::Closed:: *)
(*validModelQualificationFragmentAnalyzerQTests*)


validModelQualificationFragmentAnalyzerQTests[packet:PacketP[Model[Qualification,FragmentAnalyzer]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{PreparatoryUnitOperations}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,FragmentAnalyzer]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,FragmentAnalyzer]]...}
	]
};



(* ::Subsection::Closed:: *)
(*validModelQualificationEngineBenchmarkQTests*)


validModelQualificationEngineBenchmarkQTests[packet:PacketP[Model[Qualification,EngineBenchmark]]]:={
	
	(* -- Type Specific Test -- *)
	(* The qualification doesn't have to test everything, but it should test something *)
	AnyInformedTest[
		packet,
		{
			WaterModels,
			SensorModel
		}
	]
};

(* ::Subsection::Closed:: *)
(*validModelQualificationEnvironmentalChamberQTests*)


validModelQualificationEnvironmentalChamberQTests[packet:PacketP[Model[Qualification,EnvironmentalChamber]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{
			AutomaticExecutionFunction,
			TimePeriod,
			SamplingRate,
			MeanTolerance,
			StandardDeviationTolerance
		}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,EnvironmentalChamber]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,EnvironmentalChamber]]...}
	]
};

(* ::Subsection:: *)
(*validModelQualificationEvaporatorQTests*)


validModelQualificationEvaporatorQTests[packet:PacketP[Model[Qualification,Evaporator]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{PreparatoryUnitOperations, EvaporationTemperature, EvaporationTime, VolumeTolerance}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,Evaporator]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,Evaporator]]...}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationFilterBlockQTests*)


validModelQualificationFilterBlockQTests[packet:PacketP[Model[Qualification,FilterBlock]]]:={
	
	(* required fields *)
	NotNullFieldTest[
		packet,
		{PreparatoryUnitOperations}
	],
	
	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,FilterBlock]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,FilterBlock]]...}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationFilterHousingQTests*)


validModelQualificationFilterHousingQTests[packet:PacketP[Model[Qualification,FilterHousing]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{PreparatoryUnitOperations}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,FilterHousing]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,FilterHousing]]...}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationFlashChromatographyQTests*)


validModelQualificationFlashChromatographyQTests[packet:PacketP[Model[Qualification,FlashChromatography]]]:={

	NotNullFieldTest[packet,{PreparatoryUnitOperations}],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,FlashChromatography]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,FlashChromatography]]...}
	]
};

(* ::Subsection::Closed:: *)
(*validModelQualificationFlowCytometerQTests*)


validModelQualificationFlowCytometerQTests[packet:PacketP[Model[Qualification,FlowCytometer]]]:={

	NotNullFieldTest[packet,
		{
			PreparatoryUnitOperations
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationFPLCQTests*)


validModelQualificationFPLCQTests[packet:PacketP[Model[Qualification,FPLC]]]:={

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,FPLC]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,FPLC]]...}
	]

};


(* ::Subsection::Closed:: *)

(* ::Subsection::Closed:: *)
(*validModelQualificationFreezePumpThawApparatusQTests*)


validModelQualificationFreezePumpThawApparatusQTests[packet:PacketP[Model[Qualification,FreezePumpThawApparatus]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{PreparatoryUnitOperations,DissolvedOxygenMeter}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,FreezePumpThawApparatus]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,FreezePumpThawApparatus]]...}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationFreezerQTests*)


validModelQualificationFreezerQTests[packet:PacketP[Model[Qualification,Freezer]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{
			AutomaticExecutionFunction,
			TimePeriod,
			SamplingRate,
			MeanTarget,
			MeanTolerance,
			StandardDeviationTolerance,
			MaintenanceRecoveryTime
		}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,Freezer]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,Freezer]]...}
	]
};

(* ::Subsection::Closed:: *)
(*validModelQualificationWaterPurifierQTests*)


validModelQualificationWaterPurifierQTests[packet : PacketP[Model[Qualification, WaterPurifier]]] := {

	(* required fields *)
	NotNullFieldTest[
		packet,
		{ExpectedTemperature, TemperatureTolerance, ExampleQualityReportImage, DispenseTime}
	]
};

(* ::Subsection::Closed:: *)
(*validModelQualificationFumeHoodQTests*)


validModelQualificationFumeHoodQTests[packet : PacketP[Model[Qualification, FumeHood]]] := {

	(* required fields *)
	NotNullFieldTest[
		packet,
		{TestLight, TestAlarm, RecordFlowSpeed, ImageCertification}
	],

	Test["At least one test must be performed:",
		Lookup[packet, {TestLight, TestAlarm, RecordFlowSpeed, ImageCertification}],
		{___, True, ___}
	],

	Test["If either TestAlarm or RecordFlowSpeed is True, they both must be True:",
		If[
			Or[
				Lookup[packet, TestAlarm],
				Lookup[packet, RecordFlowSpeed]
			],
			And[
				Lookup[packet, TestAlarm],
				Lookup[packet, RecordFlowSpeed]
			],
			True
		],
		True
	],

	Test["If ImageCertification is True, ExampleCertificationImage must be informed:",
		If[
			Lookup[packet, ImageCertification],
			MatchQ[
				Lookup[packet, ExampleCertificationImage],
				ObjectP[Object[EmeraldCloudFile]]
			],
			True
		],
		True
	]
};

(* ::Subsection::Closed:: *)
(*validModelQualificationRefrigeratorQTests*)


validModelQualificationRefrigeratorQTests[packet:PacketP[Model[Qualification,Refrigerator]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{
			AutomaticExecutionFunction,
			TimePeriod,
			SamplingRate,
			MeanTarget,
			MeanTolerance,
			StandardDeviationTolerance,
			MaintenanceRecoveryTime
		}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,Refrigerator]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,Refrigerator]]...}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationGasChromatographyQTests*)


validModelQualificationGasChromatographyQTests[packet:PacketP[Model[Qualification,GasChromatography]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{Column,Detector}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationGeneticAnalyzerQTests*)


validModelQualificationGeneticAnalyzerQTests[packet:PacketP[Model[Qualification,GeneticAnalyzer]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{
			PreparatoryUnitOperations,
			SequencingStandard,
			Solvent
		}
	]
};

(* ::Subsection::Closed:: *)
(* validModelQualificationGrinderQTests *)


validModelQualificationGrinderQTests[packet : PacketP[Model[Qualification, Grinder]]] := {
	(* required fields *)
	NotNullFieldTest[
		packet,
		{
			QualificationSample,
			Amount,
			BulkDensity,
			GrindingRate,
			Time,
			NumberOfGrindingSteps,
			CoarsePowderReferenceImage,
			FinePowderReferenceImage,
			ImagingDirection
		}
	],

	(* CoolingTime must be informed if NumberOfGrindingSteps is greater than 1 *)
	Test["CoolingTime must be informed if NumberOfGrindingSteps is greater than 1:",
		If[
			GreaterQ[Lookup[packet, NumberOfGrindingSteps], 1],
			MatchQ[CoolingTime, TimeP],
			True
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationHeatBlockQTests*)


validModelQualificationHeatBlockQTests[packet:PacketP[Model[Qualification,HeatBlock]]]:={
	
	(* required fields *)
	NotNullFieldTest[
		packet,
		{PreparatoryUnitOperations}
	],
	
	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,HeatBlock]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,HeatBlock]]...}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationHomogenizerQTests*)


validModelQualificationHomogenizerQTests[packet:PacketP[Model[Qualification,Homogenizer]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{PreparatoryUnitOperations}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,Homogenizer]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,Homogenizer]]...}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationHPLCQTests*)


validModelQualificationHPLCQTests[packet:PacketP[Model[Qualification,HPLC]]]:=Module[{models},

	models=Download[packet,Targets[Object]];
	
{
	(* required fields *)
	NotNullFieldTest[
		packet,
		{Column,BufferA,BufferB,BufferC,ColumnPrimeGradient,ColumnFlushGradient,Wavelength}
	],
	
	(* all flow linearity test fields *)
	RequiredTogetherTest[
		packet,
		{FlowLinearityTestSample,FlowLinearityGradients,FlowLinearityInjectionVolume,FlowLinearityReplicates,MinFlowLinearityCorrelation,MaxFlowRateError}
	],
	
	(* all autosampler test fields *)
	RequiredTogetherTest[
		packet,
		{AutosamplerTestSample,AutosamplerGradient,AutosamplerInjectionVolumes,AutosamplerReplicates,MaxInjectionPrecisionPeakAreaRSD,MaxFlowPrecisionRetentionRSD,MinInjectionLinearityCorrelation,MaxInjectionVolumeError}
	],
	
	(* fraction collection test fields *)
	RequiredTogetherTest[
		packet,
		{FractionCollectionTestSample,FractionCollectionGradient,FractionCollectionInjectionVolume,FractionCollectionMethods,MinAbsorbance}
	],
	
	(* wavelength accuracy test fields *)
	RequiredTogetherTest[
		packet,
		{WavelengthAccuracyTestSample,WavelengthAccuracyGradient,WavelengthAccuracyInjectionVolume,WavelengthAccuracyReplicates,ReferenceAbsorbanceSpectrum,LambdaMaxes,MaxPeakWavelengthDifference}
	],
	
	(* detector linearity test fields *)
	RequiredTogetherTest[
		packet,
		{DetectorLinearityTestSample,DetectorLinearityGradient,DetectorLinearityInjectionVolume,DetectorLinearityReplicates,DetectorLinearityDilutions,DetectorLinearityDiluent,MaxDetectorResponseFactorRSD,MinDetectorLinearityCorrelation}
	],
	
	(* gradient proportioning test fields *)
	RequiredTogetherTest[
		packet,
		{GradientProportioningTestSample,GradientProportioningGradients,GradientProportioningInjectionVolume,GradientProportioningReplicates,MaxGradientProportioningPeakRetentionRSD}
	],
	
	(* have to be testing at least one thing *)
	AnyInformedTest[
		packet,
		{FlowLinearityTestSample,AutosamplerTestSample,FractionCollectionTestSample,WavelengthAccuracyTestSample,DetectorLinearityTestSample,GradientProportioningTestSample}
	],
	
	Test[
		"When the target is a Waters or Agilent instrument, Buffer D is required, otherwise it should be Null:",
		{
			MemberQ[models,Alternatives[Model[Instrument,HPLC,"id:GmzlKjY5EOAM"],Model[Instrument,HPLC,"id:1ZA60vw8X5eD"],Model[Instrument,HPLC,"id:Z1lqpMGJmR0O"],Model[Instrument,HPLC,"id:P5ZnEjx1oAAR"],Model[Instrument,HPLC,"id:dORYzZn6p31E"],Model[Instrument, HPLC, "id:R8e1Pjp1md8p"],Model[Instrument, HPLC, "id:dORYzZRWJlDD"], Model[Instrument, HPLC, "id:lYq9jRqD8OpV"], Model[Instrument, HPLC, "id:dORYzZRWmDn5"]]],
			Lookup[packet,BufferD]
		},
		Alternatives[
			{True,Except[Null]},
			{False,Null}
		]
	]
	
}];


(* ::Subsection::Closed:: *)
(*validModelQualificationIncubatorQTests*)


validModelQualificationIncubatorQTests[packet:PacketP[Model[Qualification,Incubator]]]:={

	NotNullFieldTest[
		packet,
		If[!TrueQ[Lookup[packet,AutomaticEvaluation]],
			{
				PreparatoryUnitOperations
			},
			{
				AutomaticExecutionFunction,
				TimePeriod,
				SamplingRate,
				MeanTarget,
				MeanTolerance,
				StandardDeviationTolerance,
				MaintenanceRecoveryTime
			}
		]
	]

};


(* ::Subsection::Closed:: *)
(*validModelQualificationInstrumentAlarmAuditQTests*)


validModelQualificationInstrumentAlarmAuditQTests[packet:PacketP[Model[Qualification,InstrumentAlarmAudit]]]:={

};


validModelQualificationInteractiveTrainingQTests[packet:ObjectP[Model[Qualification,InteractiveTraining]]]:={

	NotNullFieldTest[packet,{
		TrainingTasks,
		NumberOfQuestions,
		PassingPercentage
	}],

	Test["There are no duplicate Targets listed:",
		DuplicateFreeQ[Download[Lookup[packet,Targets],Object]],
		True
	],

	(* Duplicate questions are not currently supported because of grading *)
	Test["There are no duplicate questions in the training tasks:",
		DuplicateFreeQ[Cases[Lookup[packet,TrainingTasks],ObjectP[Model[Question]]],MatchQ[#1,ObjectP[#2]]&],
		True
	],

	Test["TimeAllowed is informed if the protocol is not interruptible:",
		Lookup[packet,{Interruptible,TimeAllowed}],
		{False,GreaterP[0 Minute]}|{Except[False],_}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationIonChromatographyQTests*)


validModelQualificationIonChromatographyQTests[packet:PacketP[Model[Qualification,IonChromatography]]]:=Module[{models},

	models=Download[packet,Targets[Object]];

	{
		RequiredTogetherTest[
			packet,
			{BufferA,BufferB,BufferC,BufferD}
		],

		(* required fields *)
		RequiredTogetherTest[
			packet,
			{AnionColumn,AnionGuardColumn,EluentGeneratorInletSolution,AnionColumnPrimeGradient,AnionColumnFlushGradient}
		],

		RequiredTogetherTest[
			packet,
			{CationColumn,CationGuardColumn,CationColumnPrimeGradient,CationColumnFlushGradient}
		],

		RequiredTogetherTest[
			packet,
			{Column,GuardColumn,ColumnPrimeGradient,ColumnFlushGradient}
		],

		(* all flow linearity test fields *)
		RequiredTogetherTest[
			packet,
			{AnionFlowLinearityTestSample,AnionFlowLinearityGradients,AnionFlowLinearityInjectionVolume,AnionFlowLinearityReplicates,AnionMinFlowLinearityCorrelation,AnionMaxFlowRateError}
		],

		RequiredTogetherTest[
			packet,
			{CationFlowLinearityTestSample,CationFlowLinearityGradients,CationFlowLinearityInjectionVolume,CationFlowLinearityReplicates,CationMinFlowLinearityCorrelation,CationMaxFlowRateError}
		],

		RequiredTogetherTest[
			packet,
			{FlowLinearityTestSample,FlowLinearityGradients,FlowLinearityInjectionVolume,FlowLinearityReplicates,MinFlowLinearityCorrelation,MaxFlowRateError}
		],

		(* all autosampler test fields *)
		RequiredTogetherTest[
			packet,
			{AnionAutosamplerTestSample,AnionAutosamplerGradient,AnionAutosamplerInjectionVolumes,AnionAutosamplerReplicates,AnionMaxInjectionPrecisionPeakAreaRSD,AnionMaxFlowPrecisionRetentionRSD,AnionMinInjectionLinearityCorrelation,AnionMaxInjectionVolumeError}
		],

		RequiredTogetherTest[
			packet,
			{CationAutosamplerTestSample,CationAutosamplerGradient,CationAutosamplerInjectionVolumes,CationAutosamplerReplicates,CationMaxInjectionPrecisionPeakAreaRSD,CationMaxFlowPrecisionRetentionRSD,CationMinInjectionLinearityCorrelation,CationMaxInjectionVolumeError}
		],

		RequiredTogetherTest[
			packet,
			{AutosamplerTestSample,AutosamplerGradient,AutosamplerInjectionVolumes,AutosamplerReplicates,MaxInjectionPrecisionPeakAreaRSD,MaxFlowPrecisionRetentionRSD,MinInjectionLinearityCorrelation,MaxInjectionVolumeError}
		],

		(* gradient proportioning test fields *)
		RequiredTogetherTest[
			packet,
			{GradientProportioningTestSample, GradientProportioningGradients,GradientProportioningInjectionVolume,GradientProportioningReplicates,MaxGradientProportioningPeakRetentionRSD}
		],

		(* eluent generator cartridge concentration test fields *)
		RequiredTogetherTest[
			packet,
			{EluentConcentrationTestSample,EluentConcentrationGradients,EluentConcentrationInjectionVolume,EluentConcentrationReplicates,MaxEluentConcentrationConductivityRSD}
		],

		(* detector linearity test fields *)
		RequiredTogetherTest[
			packet,
			{AnionDetectorLinearityTestSample,AnionDetectorLinearityGradient,AnionDetectorLinearityInjectionVolume,AnionDetectorLinearityReplicates,AnionDetectorLinearityDilutions,AnionDetectorLinearityDiluent,MaxAnionDetectorResponseFactorRSD,MinAnionDetectorLinearityCorrelation}
		],

		RequiredTogetherTest[
			packet,
			{CationDetectorLinearityTestSample,CationDetectorLinearityGradient,CationDetectorLinearityInjectionVolume,CationDetectorLinearityReplicates,CationDetectorLinearityDilutions,CationDetectorLinearityDiluent,MaxCationDetectorResponseFactorRSD,MinCationDetectorLinearityCorrelation}
		],

		RequiredTogetherTest[
			packet,
			{ElectrochemicalDetectorLinearityTestSample,ElectrochemicalDetectorLinearityGradient,ElectrochemicalDetectorLinearityInjectionVolume,ElectrochemicalDetectorLinearityReplicates,ElectrochemicalDetectorLinearityDilutions,ElectrochemicalDetectorLinearityDiluent,MaxElectrochemicalDetectorResponseFactorRSD,MinElectrochemicalDetectorLinearityCorrelation}
		],

		RequiredTogetherTest[
			packet,
			{DetectorLinearityTestSample,DetectorLinearityGradient,DetectorLinearityInjectionVolume,DetectorLinearityReplicates,DetectorLinearityDilutions,DetectorLinearityDiluent,MaxDetectorResponseFactorRSD,MinDetectorLinearityCorrelation}
		],


		(* have to be testing at least one thing *)
		AnyInformedTest[
			packet,
			{AnionFlowLinearityTestSample,CationFlowLinearityTestSample,FlowLinearityTestSample,AnionAutosamplerTestSample,CationAutosamplerTestSample,AutosamplerTestSample,GradientProportioningTestSample,EluentConcentrationTestSample,AnionDetectorLinearityTestSample,CationDetectorLinearityTestSample,ElectrochemicalDetectorLinearityTestSample,DetectorLinearityTestSample}
		]

	}];


(* ::Subsection::Closed:: *)
(*validModelQualificationLCMSQTests*)


validModelQualificationLCMSQTests[packet:PacketP[Model[Qualification,LCMS]]]:=Module[{models},

	models=Download[packet,Targets[Object]];

	{
		(* required fields *)
		NotNullFieldTest[
			packet,
			{Columns,CosolventA,CosolventB,CosolventC,CosolventD,MakeupSolvent,ColumnPrimeGradient,ColumnFlushGradient,AbsorbanceWavelength}
		],

		(* all flow linearity test fields *)
		RequiredTogetherTest[
			packet,
			{FlowLinearityTestSample,FlowLinearityGradients,FlowLinearityInjectionVolume,FlowLinearityReplicates,MinFlowLinearityCorrelation,MaxFlowRateError}
		],

		(* all autosampler test fields *)
		RequiredTogetherTest[
			packet,
			{AutosamplerTestSample,AutosamplerGradient,AutosamplerInjectionVolumes,AutosamplerReplicates,MaxInjectionPrecisionPeakAreaRSD,MaxFlowPrecisionRetentionRSD,MinInjectionLinearityCorrelation,MaxInjectionVolumeError}
		],

		(* wavelength accuracy test fields *)
		RequiredTogetherTest[
			packet,
			{WavelengthAccuracyTestSample,WavelengthAccuracyGradient,WavelengthAccuracyInjectionVolume,WavelengthAccuracyReplicates,ReferenceAbsorbanceSpectrum,LambdaMaxes,MaxPeakWavelengthDifference}
		],

		(* mass accuracy test fields *)
		RequiredTogetherTest[
			packet,
			{MassAccuracyTestSample,MassAccuracyAcquisitionMethod,MassAccuracyGradient,MassAccuracyInjectionVolume,MassAccuracyReplicates,ExpectedMasses,MaxMassDifference,MinMassArea}
		],

		(* detector linearity test fields *)
		RequiredTogetherTest[
			packet,
			{DetectorLinearityTestSample,DetectorLinearityGradient,DetectorLinearityInjectionVolume,DetectorLinearityReplicates,DetectorLinearityDilutions,DetectorLinearityDiluent,MaxDetectorResponseFactorRSD,MinDetectorLinearityCorrelation}
		],

		(* gradient proportioning test fields *)
		RequiredTogetherTest[
			packet,
			{GradientProportioningTestSample,GradientProportioningGradients,GradientProportioningInjectionVolume,GradientProportioningReplicates,MaxGradientProportioningPeakRetentionRSD}
		],

		(* have to be testing at least one thing *)
		AnyInformedTest[
			packet,
			{FlowLinearityTestSample,AutosamplerTestSample,FractionCollectionTestSample,WavelengthAccuracyTestSample,DetectorLinearityTestSample,GradientProportioningTestSample}
		]

	}];

(* ::Subsection::Closed:: *)
(*validModelQualificationLiquidLevelDetectionQTests*)


validModelQualificationLiquidLevelDetectionQTests[packet:PacketP[Model[Qualification,LiquidLevelDetection]]]:={

	(* must always be informed *)
	NotNullFieldTest[
		packet,
		{
			WashSolution,
			WashSolutionVolume,
			WashSolutionContainer,
			CottonTipApplicators
		}
	]
};

(* ::Subsection::Closed:: *)
(*validModelQualificationLiquidLevelDetectorQTests*)


validModelQualificationLiquidLevelDetectorQTests[packet:PacketP[Model[Qualification,LiquidLevelDetector]]]:={

	(* For macro and carboy volume checks *)
	RequiredTogetherTest[packet,{SensorArmHeight,GageBlockDistances,TareDistanceTolerance,GageBlockDistanceTolerance}],

	(* For plate volume checks *)
	RequiredTogetherTest[packet,{PlateModel,PlatePreparation,PlateSampleVolumes,BufferModel,PlateVolumeTolerances,EmptyWellDistanceTolerance}],

	(* Check that we're not populating both sets *)
	UniquelyInformedTest[packet,{SensorArmHeight,PlateModel}]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationLyophilizerQTests*)


validModelQualificationLyophilizerQTests[packet:PacketP[Model[Qualification,Lyophilizer]]]:={

	(* For macro volume checks *)
	NotNullFieldTest[packet,{PreparatoryUnitOperations}]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationMeltingPointApparatusQTests*)


validModelQualificationMeltingPointApparatusQTests[packet:PacketP[Model[Qualification,MeltingPointApparatus]]]:={

	(* fields that must not be empty *)
	NotNullFieldTest[packet,{MeltingPointStandards, MeltingPointTolerance, Desiccate, Grind}],

	(* Temperature boundaries in MeltingPointTolerance should not be duplicated: *)
	Test["Temperature boundaries in MeltingPointTolerance are not duplicated:",
		meltingPointTolerancePairs = Lookup[packet, MeltingPointTolerance];
		toleranceBoundaries = Transpose[Sort[meltingPointTolerancePairs]][[1]];
		DuplicateFreeQ[toleranceBoundaries],
		True,
		Variables :> {meltingPointTolerancePairs, toleranceBoundaries}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationLiquidHandlerQTests*)


validModelQualificationLiquidHandlerQTests[packet:PacketP[Model[Qualification,LiquidHandler]]]:={

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,LiquidHandler]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,LiquidHandler]]...}
	]
};

(* ::Subsection::Closed:: *)
(*validModelQualificationLiquidParticleCounterQTests*)


validModelQualificationLiquidParticleCounterQTests[packet:PacketP[Model[Qualification,LiquidParticleCounter]]]:={

	(* the target should be of the right instrument type *)
	NotNullFieldTest[
		packet,
		{
			BlankSamples,
			IntensityTestSamples
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationMassSpectrometerQTests*)


validModelQualificationMassSpectrometerQTests[packet:PacketP[Model[Qualification,MassSpectrometer]]] := {
	NotNullFieldTest[packet,
		Which[
			MatchQ[Lookup[packet,Model],ObjectP[Model[Qualification, MassSpectrometer, "id:01G6nvw16LxE"]]],
			{
				Replicates,
				PreparatoryUnitOperations
			},
			(* The Waters ESI-QTOF direct injection Qualification *)
			MatchQ[Lookup[packet,Object],ObjectP[Model[Qualification, MassSpectrometer, "id:XnlV5jKXRXGn"]]],
			{
				Replicates
			},
			(* The Bruker MALDI Qualification  *)
			MatchQ[Lookup[packet,Object],ObjectP[{Model[Qualification, MassSpectrometer, "id:wqW9BP7VwqMR"],Model[Qualification,MassSpectrometer,"id:6V0npvmZPA0E"]}]],
			{
				MALDIPlate,
				TestSamples,
				PeakPositionTestSample,
				CalibrationTestSample,
				CrossContaminationTestSample,
				BlankSample,
				PeakPositionTestMasses,
				CalibrationTestMasses,
				CrossContaminationTestMasses,
				Replicates,
				SampleVolume,
				Matrices,
				MassRanges,
				LaserPowerRanges,
				AccelerationVoltages,
				GridVoltages,
				LensVoltages
			},
			(* Catch all*)
			True,
			{
				Replicates
			}
		]
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationMicroscopeQTests*)


validModelQualificationMicroscopeQTests[packet:PacketP[Model[Qualification,Microscope]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{
			QualificationMicroscopeSlide,
			(* QualificationMicroscope doesn't currently use nor populate these fields *)
			(*QualificationSamples,
			AdjustmentSamples,
			AcquireImagePrimitives,*)
			SamplingPattern,
			ObjectiveMagnification
		}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,Microscope]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,Microscope]]...}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationMicrowaveQTests*)


validModelQualificationMicrowaveQTests[packet:PacketP[Model[Qualification,Microwave]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{
			PreparatoryUnitOperations
		}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,Microwave]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,Reactor,Microwave]]...}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationMultimodeSpectrophotometerQTests*)


validModelQualificationMultimodeSpectrophotometerQTests[packet:PacketP[Model[Qualification,MultimodeSpectrophotometer]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{PreparatoryUnitOperations}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,MultimodeSpectrophotometer]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,MultimodeSpectrophotometer]]...}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationNMRQTests*)


validModelQualificationNMRQTests[packet:PacketP[Model[Qualification,NMR]]]:={

	(* required fields *)
	NotNullFieldTest[packet,{QualificationSamples,Nuclei,Tests,Programs,SpinningFrequencies,MinSignalToNoise,MaxWidths}]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationNutatorQTests*)


validModelQualificationNutatorQTests[packet:PacketP[Model[Qualification,Nutator]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{PreparatoryUnitOperations, NutationSpeed, NutationTime}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,Nutator]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,Nutator]]...}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationOsmometerQTests*)


validModelQualificationOsmometerQTests[packet:PacketP[Model[Qualification,Osmometer]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{Samples}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,Osmometer]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,Osmometer]]...}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationOverheadStirrerQTests*)


validModelQualificationOverheadStirrerQTests[packet:PacketP[Model[Qualification,OverheadStirrer]]]:={
	
	(* required fields *)
	NotNullFieldTest[
		packet,
		{PreparatoryUnitOperations}
	],
	
	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,OverheadStirrer]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,OverheadStirrer]]...}
	]
};

(* ::Subsection::Closed:: *)
(*validModelQualificationPCRQTests*)


validModelQualificationPCRQTests[packet:PacketP[Model[Qualification,PCR]]]:={
	
	(* required fields *)
	NotNullFieldTest[
		packet,
		{MasterMix,MasterMixVolume,Diluent,DiluentVolume,Primers,PrimerVolumes,Sample,SampleVolume,ReactionVolume}
	],
	
	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,Thermocycler]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,Thermocycler]]...}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationPeptideSynthesizerQTests*)


validModelQualificationPeptideSynthesizerQTests[packet:PacketP[Model[Qualification,PeptideSynthesizer]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{StrandModels}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,PeptideSynthesizer]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,PeptideSynthesizer]]...}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationPeristalticPumpQTests*)


validModelQualificationPeristalticPumpQTests[packet:PacketP[Model[Qualification,PeristalticPump]]]:={
	
	(* required fields *)
	NotNullFieldTest[
		packet,
		{PreparatoryUnitOperations}
	],
	
	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,PeristalticPump]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,PeristalticPump]]...}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationpHMeterQTests*)


validModelQualificationpHMeterQTests[packet:PacketP[Model[Qualification,pHMeter]]]:=Module[
	{
		sensornetQ=If[
			Or[
				MemberQ[Lookup[packet, Targets], ObjectP[Model[Instrument, pHMeter, "id:AEqRl9K8o1D5"]]],
				MemberQ[Lookup[packet, Targets], ObjectP[Model[Instrument, pHMeter, "id:BYDOjvG65vLz"]]]
			],
			True,
			False
		]
	},

	{
		(* required fields *)
		NotNullFieldTest[
			packet,
			{pHStandards}
		],

		(* the target should be of the right instrument type *)
		Test["pHStandards should be the same length as the Probes:",
			Length[Lookup[packet,pHStandards]]==Length[Lookup[packet,Probes]],
			True
		],

		Test["Three or fewer pHStandards for the SensorNet pH meter and nine or fewer pHStandards for SevenExcellence pH meter should be populated:",
			If[
				sensornetQ,
				(*sensornet meter has only one probe and because of that only three calibration standards (low, middle, and high) need to calibrate it*)
				LessEqual[Length[Lookup[packet,pHStandards]],3],
				(*SevenExcellence meter can have up to three probes and hence it needs up to 9 standards (3 standards for probe) *)
				LessEqual[Length[Lookup[packet,pHStandards]],9]
			],
			True
		]

	}
];

(* ::Subsection::Closed:: *)
(*validModelQualificationpHTitratorQTests*)


validModelQualificationpHTitratorQTests[packet:PacketP[Model[Qualification,pHTitrator]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{pHMixRate, pHMixImpeller, TitrationContainerCap, AcidVolume, BaseVolume}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,pHTitrator]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,pHTitrator]]...}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationPipetteQTests*)


validModelQualificationPipetteQTests[packet:PacketP[Model[Qualification,Pipette]]] := {
	(* If the qualification targets the building, ensure fields are empty and ScheduleOverride is set to Always *)
	Sequence@@Switch[Lookup[packet,Targets],

		{ObjectP[Model[Container, Building]]..},
		{
			(* Check that standard fields are Null *)
			NullFieldTest[packet,
				{
					BufferModel,
					BufferReservoirModel,
					BufferVolumes,
					TipModel
				}
			],

			(* Check that this parent qualification has special scheduling to always run *)
			Test["The ScheduleOverride field is set to Always, to ensure special scheduling of qualification:",
				MatchQ[Lookup[packet,ScheduleOverride],Always],
				True
			]
		},

		{ObjectP[Model[Instrument,Pipette]]..},
		{
			(* Check that standard fields are Null *)
			NotNullFieldTest[packet,
				{
					BufferModel,
					BufferReservoirModel,
					BufferVolumes,
					TipModel
				}
			],

			(* Check that this parent qualification has special scheduling to never enqueue directly *)
			Test["The ScheduleOverride field is set to Never, to ensure special scheduling of qualification:",
				MatchQ[Lookup[packet,ScheduleOverride],Never],
				True
			]
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationPipettingLinearityQTests*)


validModelQualificationPipettingLinearityQTests[packet:PacketP[Model[Qualification,PipettingLinearity]]] := {
	(* Fields that should be filled in *)
	NotNullFieldTest[packet,
		{
			BufferModel,
			BufferReservoirModel,
			BufferDeadVolume,
			PlateReader,
			ExcitationWavelength,
			EmissionWavelength
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationPlateImagerQTests*)


validModelQualificationPlateImagerQTests[packet:PacketP[Model[Qualification,PlateImager]]]:={

	(* -- Type Specific Test -- *)
	(* The qualification doesn't have to test everything, but it should test something *)
	NotNullFieldTest[
		packet,
		{
			IlluminationDirections,
			PreparatoryUnitOperations
		}
	]
};



(* ::Subsection::Closed:: *)
(*validModelQualificationPlateReaderQTests*)


validModelQualificationPlateReaderQTests[packet:PacketP[Model[Qualification,PlateReader]]]:={

	(* -- Type Specific Test -- *)
	(* The qualification doesn't have to test everything, but it should test something *)
	AnyInformedTest[
		packet,
		{
			SamplePreparationVolume,
			PreparationModelContainer,
			PrepareReplicates
		}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,PlateReader], or Model[Instrument,Nephelometer]:",
		Lookup[packet,Targets],
		{Alternatives[LinkP[Model[Instrument, PlateReader]], LinkP[Model[Instrument, Nephelometer]]]...}
	],

	(* If AlphaScreenSamples are populated, the AlphaScreenReplicates should not be Null *)
	RequiredTogetherTest[
		packet,
		{AlphaScreenAbsorbanceAccuracySamples,AlphaScreenAbsorbanceAccuracyReplicates}
	],

	RequiredTogetherTest[
		packet,
		{AlphaScreenLinearitySamples,AlphaScreenLinearityReplicates}
	],

	RequiredTogetherTest[
		packet,
		{
			CircularDichroismRectusSample,
			CircularDichroismSinisterSample,
			CircularDichroismReplicates
		}
	]


};



(* ::Subsection::Closed:: *)
(*validModelQualificationDLSPlateReaderQTests*)


validModelQualificationDLSPlateReaderQTests[packet:PacketP[Model[Qualification,DLSPlateReader]]]:={

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,DLSPlateReader]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,DLSPlateReader]]}
	],

	(*required fields*)
	NotNullFieldTest[
		packet,
		{
			LightScatteringValidationSamples,
			LightScatteringIndependentReplicates,
			LightScatteringWellReplicates
		}
	]
};



(* ::Subsection::Closed:: *)
(*validModelQUalificationPortableCoolerQTests*)


validModelQualificationPortableCoolerQTests[packet:PacketP[Model[Qualification, PortableCooler]]] := {
	
	(* required fields *)
	NotNullFieldTest[
		packet,
		{
			AutomaticExecutionFunction,
			TimePeriod,
			SamplingRate,
			MeanTolerance,
			StandardDeviationTolerance,
			MaintenanceRecoveryTime
		}
	],
	
	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument, PortableCooler]:",
		Lookup[packet, Targets],
		{LinkP[Model[Instrument, PortableCooler]]...}
	]
};



(* ::Subsection::Closed:: *)
(*validModelQUalificationPortableHeaterQTests*)


validModelQualificationPortableHeaterQTests[packet:PacketP[Model[Qualification, PortableHeater]]] := {
	
	(* required fields *)
	NotNullFieldTest[
		packet,
		{
			TimePeriod,
			SamplingRate,
			MeanTolerance,
			StandardDeviationTolerance
		}
	],
	
	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument, PortableHeater]:",
		Lookup[packet, Targets],
		{LinkP[Model[Instrument, PortableHeater]]...}
	]
};



(* ::Subsection::Closed:: *)
(*validModelQualificationPressureManifoldQTests*)


validModelQualificationPressureManifoldQTests[packet:PacketP[Model[Qualification,PressureManifold]]]:={
	
	(* required fields *)
	NotNullFieldTest[
		packet,
		{PreparatoryUnitOperations}
	],
	
	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,PressureManifold]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,PressureManifold]]...}
	]
};



(* ::Subsection::Closed:: *)
(*validModelQualificationProteinCapillaryElectrophoresisQTests*)


validModelQualificationProteinCapillaryElectrophoresisQTests[packet:PacketP[Model[Qualification,ProteinCapillaryElectrophoresis]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{
			QualifiedExperiments
		}
	],
	RequiredTogetherTest[
		packet,
		{
			CESDSStandards,
			CESDSStandardVolumes
		}
	],
	RequiredTogetherTest[
		packet,
		{
			CESDSLadders,
			CESDSLadderVolumes
		}
	],
	RequiredTogetherTest[
		packet,
		{
			CESDSSamplePremadeMastermix,
			CESDSSamplePremadeMastermixVolumes
		}
	],
	RequiredTogetherTest[
		packet,
		{
			CESDSStandardPremadeMastermix,
			CESDSStandardPremadeMastermixVolumes
		}
	],
	RequiredTogetherTest[
		packet,
		{
			CESDSLadderPremadeMastermix,
			CESDSLadderPremadeMastermixVolumes
		}
	],
	RequiredTogetherTest[
		packet,
		{
			CIEFStandards,
			CIEFStandardVolumes
		}
	],

	RequiredTogetherTest[
		packet,
		{
			CIEFSamplePremadeMastermix,
			CIEFSamplePremadeMastermixVolumes
		}
	],
	RequiredTogetherTest[
		packet,
		{
			CIEFStandardPremadeMastermix,
			CIEFStandardPremadeMastermixVolumes
		}
	],
	(* Length of samples and volume is the same *)
	Test["A sample volume is specified for each CIEF Standard",
		MatchQ[
			Length[ToList[Lookup[packet, CIEFStandards]]],
			Length[ToList[Lookup[packet, CIEFStandardVolumes]]]
		],
		True
	],
	Test["A sample volume is specified for each CIEF sample Diluent",
		MatchQ[
			Length[ToList[Lookup[packet, CIEFSampleDiluents]]],
			Length[ToList[Lookup[packet, CIEFSampleDiluentVolumes]]]
		],
		True
	],
	Test["A sample volume is specified for each CIEF Standard Diluent",
		MatchQ[
			Length[ToList[Lookup[packet, CIEFStandardDiluents]]],
			Length[ToList[Lookup[packet, CIEFStandardDiluentVolumes]]]
		],
		True
	],
	Test["A sample volume is specified for each CIEF Sample PremadeMastermix",
		MatchQ[
			Length[ToList[Lookup[packet, CIEFSamplePremadeMastermix]]],
			Length[ToList[Lookup[packet, CIEFSamplePremadeMastermixVolumes]]]
		],
		True
	],
	Test["A sample volume is specified for each CIEF Standard PremadeMastermix",
		MatchQ[
			Length[ToList[Lookup[packet, CIEFStandardPremadeMastermix]]],
			Length[ToList[Lookup[packet, CIEFStandardPremadeMastermixVolumes]]]
		],
		True
	],
	(* Length of samples and volume is the same *)
	Test["A sample volume is specified for each CESDS Standard",
		MatchQ[
			Length[ToList[Lookup[packet, CESDSStandards]]],
			Length[ToList[Lookup[packet, CESDSStandardVolumes]]]
		],
		True
	],
	Test["A sample volume is specified for each CESDS Ladder",
		MatchQ[
			Length[ToList[Lookup[packet, CESDSLadders]]],
			Length[ToList[Lookup[packet, CESDSLadderVolumes]]]
		],
		True
	],
	Test["A sample volume is specified for each CESDS sample Diluent",
		MatchQ[
			Length[ToList[Lookup[packet, CESDSSampleDiluents]]],
			Length[ToList[Lookup[packet, CESDSSampleDiluentVolumes]]]
		],
		True
	],
	Test["A sample volume is specified for each CESDS Standard Diluent",
		MatchQ[
			Length[ToList[Lookup[packet, CESDSStandardDiluents]]],
			Length[ToList[Lookup[packet, CESDSStandardDiluentVolumes]]]
		],
		True
	],
	Test["A sample volume is specified for each CESDS Ladder Diluent",
		MatchQ[
			Length[ToList[Lookup[packet, CESDSLadderDiluents]]],
			Length[ToList[Lookup[packet, CESDSLadderDiluentVolumes]]]
		],
		True
	],
	Test["A sample volume is specified for each CESDS Sample PremadeMastermix",
		MatchQ[
			Length[ToList[Lookup[packet, CESDSSamplePremadeMastermix]]],
			Length[ToList[Lookup[packet, CESDSSamplePremadeMastermixVolumes]]]
		],
		True
	],
	Test["A sample volume is specified for each CESDS Standard PremadeMastermix",
		MatchQ[
			Length[ToList[Lookup[packet, CESDSStandardPremadeMastermix]]],
			Length[ToList[Lookup[packet, CESDSStandardPremadeMastermixVolumes]]]
		],
		True
	],
	Test["A sample volume is specified for each CESDS Ladder PremadeMastermix",
		MatchQ[
			Length[ToList[Lookup[packet, CESDSLadderPremadeMastermix]]],
			Length[ToList[Lookup[packet, CESDSLadderPremadeMastermixVolumes]]]
		],
		True
	],
	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,ProteinCapillaryElectrophoresis]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,ProteinCapillaryElectrophoresis]]...}
	]
};



(* ::Subsection::Closed:: *)
(*validModelQualificationqPCRQTests*)


validModelQualificationqPCRQTests[packet:PacketP[Model[Qualification,qPCR]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{TestSamples, ForwardPrimers, ReversePrimers, Standards, StandardForwardPrimers, StandardReversePrimers}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,Thermocycler]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,Thermocycler]]...}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationDigitalPCRQTests*)


validModelQualificationDigitalPCRQTests[packet:PacketP[Model[Qualification,DigitalPCR]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{Sample, ForwardPrimers, ReversePrimers, Probes, Diluent, ReactionVolume}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,Thermocycler,DigitalPCR]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,Thermocycler,DigitalPCR]]...}
	]
};



(* ::Subsection::Closed:: *)
(*validModelQualificationDigitalPlateSealerQTests*)


validModelQualificationPlateSealerQTests[packet:PacketP[Model[Qualification,PlateSealer]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{Cover,Container}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,PlateSealer]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,PlateSealer]]...}
	]
};



(* ::Subsection::Closed:: *)
(*validModelQualificationRamanSpectrometerQTests*)


validModelQualificationRamanSpectrometerQTests[packet:PacketP[Model[Qualification,RamanSpectrometer]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{SamplingPatternsTested}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,RamanSpectrometer]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,RamanSpectrometer]]...}
	]
};



(* ::Subsection::Closed:: *)
(*validModelQualificationRockerQTests*)


validModelQualificationRockerQTests[packet:PacketP[Model[Qualification,Rocker]]]:={

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,Rocker]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,Rocker]]...}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationRollerQTests*)


validModelQualificationRollerQTests[packet:PacketP[Model[Qualification,Roller]]]:={
	
	(* required fields *)
	NotNullFieldTest[
		packet,
		{PreparatoryUnitOperations}
	],
	
	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,Roller]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,Roller]]...}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationRotaryEvaporatorQTests*)


validModelQualificationRotaryEvaporatorQTests[packet:PacketP[Model[Qualification,RotaryEvaporator]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{PreparatoryUnitOperations}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,RotaryEvaporator]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,RotaryEvaporator]]...}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationSampleImagerQTests*)


validModelQualificationSampleImagerQTests[packet:PacketP[Model[Qualification,SampleImager]]]:={
	
	(* required fields *)
	NotNullFieldTest[
		packet,
		{ImagingReagent,ImagingContainers}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,SampleImager]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,SampleImager]]...}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationSampleInspectorQTests*)


validModelQualificationSampleInspectorQTests[packet:PacketP[Model[Qualification,SampleInspector]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{
			Standards,
			StandardContainers,
			StandardVolumes
		}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,SampleInspector]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,SampleInspector]]...}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationShakerQTests*)


validModelQualificationShakerQTests[packet:PacketP[Model[Qualification,Shaker]]]:={
	
	(* required fields *)
	NotNullFieldTest[
		packet,
		{PreparatoryUnitOperations}
	],
	
	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,Shaker]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,Shaker]]...}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationSonicatorQTests*)


validModelQualificationSonicatorQTests[packet:PacketP[Model[Qualification,Sonicator]]]:={
	
	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,Sonicator]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,Sonicator]]...}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationSpargingApparatusQTests*)


validModelQualificationSpargingApparatusQTests[packet:PacketP[Model[Qualification,SpargingApparatus]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{PreparatoryUnitOperations,DissolvedOxygenMeter}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,SpargingApparatus]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,SpargingApparatus]]...}
	]
};



(* ::Subsection::Closed:: *)
(*validModelQualificationSpectrophotometerQTests*)


validModelQualificationSpectrophotometerQTests[packet:PacketP[Model[Qualification,Spectrophotometer]]]:={
	
	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,Spectrophotometer]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,Spectrophotometer]]...}
	]
};



(* ::Subsection::Closed:: *)
(*validModelQualificationSFCQTests*)


validModelQualificationSFCQTests[packet:PacketP[Model[Qualification,SupercriticalFluidChromatography]]]:=Module[{models},

	models=Download[packet,Targets[Object]];

	{
		(* required fields *)
		NotNullFieldTest[
			packet,
			{Columns,CosolventA,CosolventB,CosolventC,CosolventD,MakeupSolvent,ColumnPrimeGradient,ColumnFlushGradient,AbsorbanceWavelength}
		],

		(* all flow linearity test fields *)
		RequiredTogetherTest[
			packet,
			{FlowLinearityTestSample,FlowLinearityGradients,FlowLinearityInjectionVolume,FlowLinearityReplicates,MinFlowLinearityCorrelation,MaxFlowRateError}
		],

		(* all autosampler test fields *)
		RequiredTogetherTest[
			packet,
			{AutosamplerTestSample,AutosamplerGradient,AutosamplerInjectionVolumes,AutosamplerReplicates,MaxInjectionPrecisionPeakAreaRSD,MaxFlowPrecisionRetentionRSD,MinInjectionLinearityCorrelation,MaxInjectionVolumeError}
		],

		(* fraction collection test fields *)
		RequiredTogetherTest[
			packet,
			{FractionCollectionTestSample,FractionCollectionGradient,FractionCollectionInjectionVolume,FractionCollectionMethods,MinAbsorbance}
		],

		(* wavelength accuracy test fields *)
		RequiredTogetherTest[
			packet,
			{WavelengthAccuracyTestSample,WavelengthAccuracyGradient,WavelengthAccuracyInjectionVolume,WavelengthAccuracyReplicates,ReferenceAbsorbanceSpectrum,LambdaMaxes,MaxPeakWavelengthDifference}
		],

		(* mass accuracy test fields *)
		RequiredTogetherTest[
			packet,
			{MassAccuracyTestSample,MassAccuracyGradient,MassAccuracyInjectionVolume,MassAccuracyReplicates,ExpectedMasses,MaxMassDifference,MinMassArea}
		],

		(* detector linearity test fields *)
		RequiredTogetherTest[
			packet,
			{DetectorLinearityTestSample,DetectorLinearityGradient,DetectorLinearityInjectionVolume,DetectorLinearityReplicates,DetectorLinearityDilutions,DetectorLinearityDiluent,MaxDetectorResponseFactorRSD,MinDetectorLinearityCorrelation}
		],

		(* gradient proportioning test fields *)
		RequiredTogetherTest[
			packet,
			{GradientProportioningTestSample,GradientProportioningGradients,GradientProportioningInjectionVolume,GradientProportioningReplicates,MaxGradientProportioningPeakRetentionRSD}
		],

		(* have to be testing at least one thing *)
		AnyInformedTest[
			packet,
			{FlowLinearityTestSample,AutosamplerTestSample,FractionCollectionTestSample,WavelengthAccuracyTestSample,DetectorLinearityTestSample,GradientProportioningTestSample}
		]

	}];


(* ::Subsection::Closed:: *)
(*validModelQualificationVacuumCentrifugeQTests*)


validModelQualificationVacuumCentrifugeQTests[packet:PacketP[Model[Qualification,VacuumCentrifuge]]]:={};


(* ::Subsection::Closed:: *)
(*validModelQualificationVacuumDegasserQTests*)


validModelQualificationVacuumDegasserQTests[packet:PacketP[Model[Qualification,VacuumDegasser]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{PreparatoryUnitOperations,DissolvedOxygenMeter}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,VacuumDegasser]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,VacuumDegasser]]...}
	]
};


(* ::Subsection:: *)
(*validModelQualificationViscometerQTests*)


validModelQualificationViscometerQTests[packet:PacketP[Model[Qualification,Viscometer]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{PreparatoryUnitOperations}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,Viscometer]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,Viscometer]]...}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationVortexQTests*)


validModelQualificationVortexQTests[packet:PacketP[Model[Qualification,Vortex]]]:={
	
	(* required fields *)
	NotNullFieldTest[
		packet,
		{PreparatoryUnitOperations}
	],
	
	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,Vortex]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,Vortex]]...}
	]
};



(* ::Subsection::Closed:: *)
(*validModelQualificationWesternQTests*)


validModelQualificationWesternQTests[packet:PacketP[Model[Qualification,Western]]]:={

(* required fields *)
	NotNullFieldTest[
		packet,
		{PreparatoryUnitOperations,PrimaryAntibodies}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,Western]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,Western]]...}
	]
};



(* ::Subsection::Closed:: *)
(*validModelQualificationTensiometerQTests*)


validModelQualificationTensiometerQTests[packet:PacketP[Model[Qualification,Tensiometer]]]:={};


(* ::Subsection:: *)
(*validModelQualificationSonicatorQTests*)


validModelQualificationBioLayerInterferometerQTests[packet:PacketP[Model[Qualification,BioLayerInterferometer]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{PreparatoryUnitOperations}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,BioLayerInterferometer]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,BioLayerInterferometer]]...}
	]
};


validModelQualificationCapillaryELISAQTests[packet:PacketP[Model[Qualification,CapillaryELISA]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{PreparatoryUnitOperations}
	],

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument,CapillaryELISA]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,CapillaryELISA]]...}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationVentilationQTests*)


validModelQualificationVentilationQTests[packet:PacketP[Model[Qualification,Ventilation]]]:={

	(* required fields *)
	NotNullFieldTest[
		packet,
		{Anemometer}
	]
};

(* ::Subsection:: *)
(*validModelQualificationRefractometerQTests*)


validModelQualificationRefractometerQTests[packet:PacketP[Model[Qualification,Refractometer]]]:={

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument, Refractometer]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,Refractometer]]...}
	]
};

(* ::Subsection::Closed:: *)
(*validQualificationAlignLiquidHandlerQTests*)


validModelQualificationMeasureLiquidHandlerDeckAccuracyQTests[packet:PacketP[Model[Qualification,MeasureLiquidHandlerDeckAccuracy]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Targets,NumberOfPositions,NumberOfWells
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelQualificationMeasureLiquidHandlerDevicePrecisionQTests*)

validModelQualificationMeasureLiquidHandlerDevicePrecisionQTests[packet:PacketP[Model[Qualification,MeasureLiquidHandlerDevicePrecision]]]:={

	(* fields not null *)
	NotNullFieldTest[packet,
		{
			Targets,
			ChannelCalibrationTool,
			ManualAlignmentFilePath,
			LeftTrack,
			RightTrack
		}
	]
};


(* ::Subsection:: *)
(*validModelQualificationVerifyHamiltonLabwareQTests*)


validModelQualificationVerifyHamiltonLabwareQTests[packet:PacketP[Model[Qualification,VerifyHamiltonLabware]]]:={

	(* the target should be of the right instrument type *)
	Test["The target must be a Model[Instrument, LiquidHandler]:",
		Lookup[packet,Targets],
		{LinkP[Model[Instrument,LiquidHandler]]...}
	]
};


(* ::Subsection:: *)
(*Test Registration *)


registerValidQTestFunction[Model[Qualification],validModelQualificationQTests];
registerValidQTestFunction[Model[Qualification, AcousticLiquidHandler],validModelQualificationAcousticLiquidHandlerQTests];
registerValidQTestFunction[Model[Qualification, MeasureLiquidHandlerDevicePrecision],validModelQualificationMeasureLiquidHandlerDevicePrecisionQTests];
registerValidQTestFunction[Model[Qualification, Autoclave],validModelQualificationAutoclaveQTests];
registerValidQTestFunction[Model[Qualification, BiosafetyCabinet],validModelQualificationBiosafetyCabinetQTests];
registerValidQTestFunction[Model[Qualification, BottleRoller],validModelQualificationBottleRollerQTests];
registerValidQTestFunction[Model[Qualification, Balance],validModelQualificationBalanceQTests];
registerValidQTestFunction[Model[Qualification, CapillaryELISA],validModelQualificationCapillaryELISAQTests];
registerValidQTestFunction[Model[Qualification, Centrifuge],validModelQualificationCentrifugeQTests];
registerValidQTestFunction[Model[Qualification, ColonyHandler], validModelQualificationColonyHandlerQTests];
registerValidQTestFunction[Model[Qualification, ConductivityMeter],validModelQualificationConductivityMeterQTests];
registerValidQTestFunction[Model[Qualification, ControlledRateFreezer],validModelQualificationControlledRateFreezerQTests];
registerValidQTestFunction[Model[Qualification, CoulterCounter],validModelQualificationCoulterCounterQTests];
registerValidQTestFunction[Model[Qualification, CrystalIncubator],validModelQualificationCrystalIncubatorQTests];
registerValidQTestFunction[Model[Qualification, CryogenicFreezer],validModelQualificationCryogenicFreezerQTests];
registerValidQTestFunction[Model[Qualification, CrossFlowFiltration],validModelQualificationCrossFlowFiltrationQTests];
registerValidQTestFunction[Model[Qualification, DensityMeter],validModelQualificationDensityMeterQTests];
registerValidQTestFunction[Model[Qualification, Desiccator],validModelQualificationDesiccatorQTests];
registerValidQTestFunction[Model[Qualification, Dewar],validModelQualificationDewarQTests];
registerValidQTestFunction[Model[Qualification, Dialyzer], validModelQualificationDialyzerQTests];
registerValidQTestFunction[Model[Qualification, DifferentialScanningCalorimeter],validModelQualificationDifferentialScanningCalorimeterQTests];
registerValidQTestFunction[Model[Qualification, Diffractometer],validModelQualificationDiffractometerQTests];
registerValidQTestFunction[Model[Qualification, Disruptor],validModelQualificationDisruptorQTests];
registerValidQTestFunction[Model[Qualification, DissolvedOxygenMeter],validModelQualificationDissolvedOxygenMeterQTests];
registerValidQTestFunction[Model[Qualification, DNASynthesizer],validModelQualificationDNASynthesizerQTests];
registerValidQTestFunction[Model[Qualification, DynamicFoamAnalyzer],validModelQualificationDynamicFoamAnalyzerQTests];
registerValidQTestFunction[Model[Qualification, ElectrochemicalReactor],validModelQualificationElectrochemicalReactorQTests];
registerValidQTestFunction[Model[Qualification, Electrophoresis],validModelQualificationElectrophoresisQTests];
registerValidQTestFunction[Model[Qualification, FragmentAnalyzer],validModelQualificationFragmentAnalyzerQTests];
registerValidQTestFunction[Model[Qualification, EngineBenchmark],validModelQualificationEngineBenchmarkQTests];
registerValidQTestFunction[Model[Qualification, EnvironmentalChamber],validModelQualificationEnvironmentalChamberQTests];
registerValidQTestFunction[Model[Qualification, Evaporator], validModelQualificationEvaporatorQTests];
registerValidQTestFunction[Model[Qualification, FilterBlock],validModelQualificationFilterBlockQTests];
registerValidQTestFunction[Model[Qualification, FilterHousing],validModelQualificationFilterHousingQTests];
registerValidQTestFunction[Model[Qualification, FlashChromatography],validModelQualificationFlashChromatographyQTests];
registerValidQTestFunction[Model[Qualification, FlowCytometer],validModelQualificationFlowCytometerQTests];
registerValidQTestFunction[Model[Qualification, FPLC],validModelQualificationFPLCQTests];
registerValidQTestFunction[Model[Qualification, FreezePumpThawApparatus],validModelQualificationFreezePumpThawApparatusQTests];
registerValidQTestFunction[Model[Qualification, Freezer],validModelQualificationFreezerQTests];
registerValidQTestFunction[Model[Qualification, FumeHood],validModelQualificationFumeHoodQTests];
registerValidQTestFunction[Model[Qualification, GasChromatography],validModelQualificationGasChromatographyQTests];
registerValidQTestFunction[Model[Qualification, GeneticAnalyzer],validModelQualificationGeneticAnalyzerQTests];
registerValidQTestFunction[Model[Qualification, Grinder],validModelQualificationGrinderQTests];
registerValidQTestFunction[Model[Qualification, HeatBlock],validModelQualificationHeatBlockQTests];
registerValidQTestFunction[Model[Qualification, Homogenizer],validModelQualificationHomogenizerQTests];
registerValidQTestFunction[Model[Qualification, HPLC],validModelQualificationHPLCQTests];
registerValidQTestFunction[Model[Qualification, LCMS],validModelQualificationLCMSQTests];
registerValidQTestFunction[Model[Qualification, Incubator],validModelQualificationIncubatorQTests];
registerValidQTestFunction[Model[Qualification, InstrumentAlarmAudit],validModelQualificationInstrumentAlarmAuditQTests];
registerValidQTestFunction[Model[Qualification,InteractiveTraining],validModelQualificationInteractiveTrainingQTests];
registerValidQTestFunction[Model[Qualification, IonChromatography],validModelQualificationIonChromatographyQTests];
registerValidQTestFunction[Model[Qualification, LiquidHandler],validModelQualificationLiquidHandlerQTests];
registerValidQTestFunction[Model[Qualification, LiquidParticleCounter],validModelQualificationLiquidParticleCounterQTests];
registerValidQTestFunction[Model[Qualification, LiquidLevelDetection],validModelQualificationLiquidLevelDetectionQTests];
registerValidQTestFunction[Model[Qualification, LiquidLevelDetector],validModelQualificationLiquidLevelDetectorQTests];
registerValidQTestFunction[Model[Qualification, Lyophilizer],validModelQualificationLyophilizerQTests];
registerValidQTestFunction[Model[Qualification, MeltingPointApparatus],validModelQualificationMeltingPointApparatusQTests];
registerValidQTestFunction[Model[Qualification, MassSpectrometer],validModelQualificationMassSpectrometerQTests];
registerValidQTestFunction[Model[Qualification, Microscope],validModelQualificationMicroscopeQTests];
registerValidQTestFunction[Model[Qualification, Microwave],validModelQualificationMicrowaveQTests];
registerValidQTestFunction[Model[Qualification, MultimodeSpectrophotometer],validModelQualificationMultimodeSpectrophotometerQTests];
registerValidQTestFunction[Model[Qualification, NMR],validModelQualificationNMRQTests];
registerValidQTestFunction[Model[Qualification, Nutator],validModelQualificationNutatorQTests];
registerValidQTestFunction[Model[Qualification, Osmometer],validModelQualificationOsmometerQTests];
registerValidQTestFunction[Model[Qualification, OverheadStirrer],validModelQualificationOverheadStirrerQTests];
registerValidQTestFunction[Model[Qualification, PCR],validModelQualificationPCRQTests];
registerValidQTestFunction[Model[Qualification, PeptideSynthesizer],validModelQualificationPeptideSynthesizerQTests];
registerValidQTestFunction[Model[Qualification, PeristalticPump],validModelQualificationPeristalticPumpQTests];
registerValidQTestFunction[Model[Qualification, pHMeter],validModelQualificationpHMeterQTests];
registerValidQTestFunction[Model[Qualification, pHTitrator],validModelQualificationpHTitratorQTests];
registerValidQTestFunction[Model[Qualification, Pipette],validModelQualificationPipetteQTests];
registerValidQTestFunction[Model[Qualification, PipettingLinearity],validModelQualificationPipettingLinearityQTests];
registerValidQTestFunction[Model[Qualification, PlateImager],validModelQualificationPlateImagerQTests];
registerValidQTestFunction[Model[Qualification, PlateReader],validModelQualificationPlateReaderQTests];
registerValidQTestFunction[Model[Qualification, DLSPlateReader],validModelQualificationDLSPlateReaderQTests];
registerValidQTestFunction[Model[Qualification, PlateSealer],validModelQualificationPlateSealerQTests];
registerValidQTestFunction[Model[Qualification, PortableCooler],validModelQualificationPortableCoolerQTests];
registerValidQTestFunction[Model[Qualification, PortableHeater],validModelQualificationPortableHeaterQTests];
registerValidQTestFunction[Model[Qualification, PressureManifold],validModelQualificationPressureManifoldQTests];
registerValidQTestFunction[Model[Qualification, ProteinCapillaryElectrophoresis],validModelQualificationProteinCapillaryElectrophoresisQTests];
registerValidQTestFunction[Model[Qualification, qPCR],validModelQualificationqPCRQTests];
registerValidQTestFunction[Model[Qualification, DigitalPCR],validModelQualificationDigitalPCRQTests];
registerValidQTestFunction[Model[Qualification, RamanSpectrometer], validModelQualificationRamanSpectrometerQTests];
registerValidQTestFunction[Model[Qualification, Refrigerator],validModelQualificationRefrigeratorQTests];
registerValidQTestFunction[Model[Qualification, Rocker],validModelQualificationRockerQTests];
registerValidQTestFunction[Model[Qualification, Roller],validModelQualificationRollerQTests];
registerValidQTestFunction[Model[Qualification, RotaryEvaporator],validModelQualificationRotaryEvaporatorQTests];
registerValidQTestFunction[Model[Qualification, Shaker],validModelQualificationShakerQTests];
registerValidQTestFunction[Model[Qualification, SampleImager],validModelQualificationSampleImagerQTests];
registerValidQTestFunction[Model[Qualification, SampleInspector],validModelQualificationSampleInspectorQTests];
registerValidQTestFunction[Model[Qualification, Sonicator],validModelQualificationSonicatorQTests];
registerValidQTestFunction[Model[Qualification, SpargingApparatus],validModelQualificationSpargingApparatusQTests];
registerValidQTestFunction[Model[Qualification, Spectrophotometer],validModelQualificationSpectrophotometerQTests];
registerValidQTestFunction[Model[Qualification, SupercriticalFluidChromatography],validModelQualificationSFCQTests];
registerValidQTestFunction[Model[Qualification, VacuumCentrifuge],validModelQualificationVacuumCentrifugeQTests];
registerValidQTestFunction[Model[Qualification, VacuumDegasser],validModelQualificationVacuumDegasserQTests];
registerValidQTestFunction[Model[Qualification, Ventilation],validModelQualificationVentilationQTests];
registerValidQTestFunction[Model[Qualification, Viscometer],validModelQualificationViscometerQTests];
registerValidQTestFunction[Model[Qualification, Vortex],validModelQualificationVortexQTests];
registerValidQTestFunction[Model[Qualification, WaterPurifier],validModelQualificationWaterPurifierQTests];
registerValidQTestFunction[Model[Qualification, Western],validModelQualificationWesternQTests];
registerValidQTestFunction[Model[Qualification, Tensiometer], validModelQualificationTensiometerQTests];
registerValidQTestFunction[Model[Qualification, BioLayerInterferometer],validModelQualificationBioLayerInterferometerQTests];
registerValidQTestFunction[Model[Qualification, CapillaryELISA],validModelQualificationCapillaryELISAQTests];
registerValidQTestFunction[Model[Qualification, ELISA],validModelQualificationELISAQTests];
registerValidQTestFunction[Model[Qualification, Refractometer],validModelQualificationRefractometerQTests];
registerValidQTestFunction[Model[Qualification, AlignLiquidHandler],validModelQualificationAlignLiquidHandlerQTests];
registerValidQTestFunction[Model[Qualification, MeasureLiquidHandlerDeckAccuracy],validModelQualificationMeasureLiquidHandlerDeckAccuracyQTests];
registerValidQTestFunction[Model[Qualification, VerifyHamiltonLabware],validModelQualificationVerifyHamiltonLabwareQTests];
