(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*validModelMaintenanceQTests*)


validModelMaintenanceQTests[packet:PacketP[Model[Maintenance]]] := {

	(* General fields filled in *)
	NotNullFieldTest[packet,{Authors, Name}],

	(* Linked objects *)
	ObjectTypeTest[packet,Objects]

};

(* ::Subsection::Closed:: *)
(*validModelMaintenanceAlignLiquidHandlerDevicePrecisionQTests*)


validModelMaintenanceAlignLiquidHandlerDevicePrecisionQTests[packet:PacketP[Model[Maintenance,AlignLiquidHandlerDevicePrecision]]]:={

	(* fields not null *)
	NotNullFieldTest[packet,
		{
			Targets,
			ChannelCalibrationTool,
			ChannelPositioningTool,
			AdjustmentScrewdriver,
			FasteningScrewdriver,
			Wrenches,
			CoverTool,
			LeftTrack,
			RightTrack
		}
	]
};

(* ::Subsection::Closed:: *)
(*validMaintenanceTrainInternalRobotArmPositionQTests*)


validModelMaintenanceTrainInternalRobotArmPositionQTests[packet:PacketP[Model[Maintenance,TrainInternalRobotArm]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,Target,Author,TrainingPlate
		}
	]
};



(* ::Subsection::Closed:: *)
(*validModelMaintenanceAutoclaveQTests*)


validModelMaintenanceAutoclaveQTests[packet:PacketP[Model[Maintenance,Autoclave]]]:={

	(* fields not null *)
	NotNullFieldTest[packet,
		{
			Targets,
			MinThreshold,
			Autoclaves,
			AutoclaveBins
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceCalibrateApertureTubeQTests*)


validModelMaintenanceCalibrateApertureTubeQTests[packet:PacketP[Model[Maintenance,CalibrateApertureTube]]]:={

	(* fields not null *)
	NotNullFieldTest[packet,
		{
			Targets,
			Authors,
			ApertureTube,
			ElectrolyteSolution,
			SizeStandards,
			MeasurementContainers,
			SampleAmounts,
			ElectrolyteSampleDilutionVolumes
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceCalibrateAutosamplerQTests*)


validModelMaintenanceCalibrateAutosamplerQTests[packet:PacketP[Model[Maintenance,CalibrateAutosampler]]]:={

	(* fields not null *)
	NotNullFieldTest[packet,
		{
			Targets,
			CalibrationContainer,
			CalibrationContainerCap
		}
	]
};



(* ::Subsection::Closed:: *)
(*validModelMaintenanceCalibrateBalanceQTests*)


validModelMaintenanceCalibrateBalanceQTests[packet:PacketP[Model[Maintenance,CalibrateBalance]]]:={

	(* fields not null *)
	NotNullFieldTest[packet,
		{
			Targets,
			CalibrationWeights,
			ValidationWeights
		}
	]
};

(* ::Subsection::Closed:: *)
(*validModelMaintenanceCalibrateBalanceCrossFlowFiltrationQTests*)


validModelMaintenanceCalibrateBalanceCrossFlowFiltrationQTests[packet:PacketP[Model[Maintenance, CalibrateBalance, CrossFlowFiltration]]]:={

	(* fields not null *)
	NotNullFieldTest[packet,
		{
			Targets,
			CalibrationWeights,
			ValidationWeights
		}
	]
};



(* ::Subsection::Closed:: *)
(*validModelMaintenanceCalibratePathLengthQTests*)


validModelMaintenanceCalibratePathLengthQTests[packet:PacketP[Model[Maintenance,CalibratePathLength]]]:={

	(* fields not null *)
	NotNullFieldTest[packet,
		{
			Targets,
			BufferModel,
			PlateModel,
			NumberOfReplicates,
			WavelengthRange,
			MaxMeanError,
			MaxSingleError,
			VolumeRanges
		}
	],

	(* more advanced checks which serve as maintenance function gates *)
	Test[
		"The number of replicates must be between 1 and 5 due to limitations on the robot deck:",
		Lookup[packet,NumberOfReplicates],
		RangeP[1, 5]
	],

	Test[
		"The volume ranges must all be within the plate's minimum and maximum volumes:",
		Module[{volumeRanges,validRange},
			volumeRanges=Lookup[packet,VolumeRanges];
			validRange=Download[Lookup[packet,PlateModel],{MinVolume,MaxVolume}];
			(Min[volumeRanges[[All,1]]]>=First[validRange])&&(Max[volumeRanges[[All,2]]]<=Last[validRange])
		],
		True
	],

	Test[
		"The total number of volume range increments cannot exceed the the number of plate columns times whichever is smaller, the number of plate rows or the number of liquid handler channels:",
		Module[{volumeIncrements,columns,rows},
			volumeIncrements=Total[Lookup[packet,VolumeRanges][[All,3]]];
			{rows,columns}=Download[Lookup[packet,PlateModel],{Rows,Columns}];
			volumeIncrements<=(Min[8,rows]*columns)
		],
		True
	]
};



(* ::Subsection::Closed:: *)
(*validModelMaintenanceCalibrateCarbonDioxideQTests*)


validModelMaintenanceCalibrateCarbonDioxideQTests[packet:PacketP[Model[Maintenance,CalibrateCarbonDioxide]]]:={
	NotNullFieldTest[packet,Targets]
};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceCalibrateCarbonDioxideQTests*)


validModelMaintenanceCalibrateGasSensorQTests[packet:PacketP[Model[Maintenance,CalibrateGasSensor]]]:={
	NotNullFieldTest[packet,Targets]
};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceCalibrateLevelQTests*)


validModelMaintenanceCalibrateLevelQTests[packet:PacketP[Model[Maintenance,CalibrateLevel]]]:={
	NotNullFieldTest[packet,Targets]
};

(* ::Subsection::Closed:: *)
(*validModelMaintenanceCalibrateLightScatteringQTests*)


validModelMaintenanceCalibrateLightScatteringQTests[packet:PacketP[Model[Maintenance,CalibrateLightScattering]]]:={
	NotNullFieldTest[packet,{
		Targets,
		CalibrationStandard,
		CapillaryLoading
	}]
};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceCalibrateLightScatteringPlateQTests*)


validModelMaintenanceCalibrateLightScatteringPlateQTests[packet:PacketP[Model[Maintenance,CalibrateLightScattering,Plate]]]:={
	NotNullFieldTest[packet,{
		AssayContainer
	}]
};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceCalibrateNMRShimQTests*)


validModelMaintenanceCalibrateNMRShimQTests[packet:PacketP[Model[Maintenance,CalibrateNMRShim]]]:={
	NotNullFieldTest[packet,{
		Targets,
		ShimmingStandard
	}]
};



(* ::Subsection::Closed:: *)
(*validModelMaintenanceCalibrateMicroscopeQTests*)


validModelMaintenanceCalibrateMicroscopeQTests[packet:PacketP[Model[Maintenance,CalibrateMicroscope]]]:={
	NotNullFieldTest[packet,Targets]
};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceCalibratepHQTests*)


validModelMaintenanceCalibratepHQTests[packet:PacketP[Model[Maintenance,CalibratepH]]]:={
	NotNullFieldTest[packet,Targets]
};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceCalibratePressureQTests*)


validModelMaintenanceCalibratePressureQTests[packet:PacketP[Model[Maintenance,CalibratePressure]]]:={
	NotNullFieldTest[packet,Targets]
};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceCalibrateRelativeHumidityQTests*)


validModelMaintenanceCalibrateRelativeHumidityQTests[packet:PacketP[Model[Maintenance,CalibrateRelativeHumidity]]]:={
	NotNullFieldTest[packet,Targets]
};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceCalibrateTemperatureQTests*)


validModelMaintenanceCalibrateTemperatureQTests[packet:PacketP[Model[Maintenance,CalibrateTemperature]]]:={
	NotNullFieldTest[packet,Targets]
};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceCalibrateConductivityQTests*)


validModelMaintenanceCalibrateConductivityQTests[packet:PacketP[Model[Maintenance,CalibrateConductivity]]]:={
	NotNullFieldTest[packet,Targets]
};



(* ::Subsection::Closed:: *)
(*validModelMaintenanceCalibrateElectrochemicalReactorQTests*)


validModelMaintenanceCalibrateElectrochemicalReactorQTests[packet:PacketP[Model[Maintenance,CalibrateElectrochemicalReactor]]]:={
	NotNullFieldTest[packet,{Targets, CalibrationCapModel, ReactionVesselHolderModel}]
};



(* ::Subsection::Closed:: *)
(*validModelMaintenanceCalibrateVolumeQTests*)


validModelMaintenanceCalibrateVolumeQTests[packet:PacketP[Model[Maintenance,CalibrateVolume]]]:={
	(* shared fields not null *)
	NotNullFieldTest[packet,
		{
			Targets,
			BufferModel,
			ContainerModel,
			NumberOfReplicates,
			VolumeRanges
		}
	],

	(* more advanced checks which serve as maintenance function gates *)
	Test[
		"If the container model is a plate, the number of replicates must be between 1 and 5 due to limitations on the robot deck:",
		{Lookup[packet,NumberOfReplicates],Lookup[packet,ContainerModel]},
		{RangeP[1,5],ObjectP[Model[Container, Plate]]}|{_,ObjectP[Model[Container, Vessel]]}|{_,ObjectP[Model[Container, Cuvette]]}
	],



	Test[
		"The volume ranges must all be within the container's minimum and maximum volumes:",
		Module[{volumeRanges,validRange},
			volumeRanges=Lookup[packet,VolumeRanges];
			validRange=Download[Lookup[packet,ContainerModel],{MinVolume,MaxVolume}]/.{Null,x_}:>{0Milliliter,x};
			(Min[volumeRanges[[All,1]]]>=First[validRange])&&(Max[volumeRanges[[All,2]]]<=Last[validRange])
		],
		True
	]

};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceCalibrateWeightQTests*)


validModelMaintenanceCalibrateWeightQTests[packet:PacketP[Model[Maintenance,CalibrateWeight]]]:={
	NotNullFieldTest[packet,Targets]
};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceCellBleachQTests*)


validModelMaintenanceCellBleachQTests[packet:PacketP[Model[Maintenance,CellBleach]]]:={
	(* Shared field shaping *)
	NullFieldTest[packet,Targets],

	(* Unique fields *)
	NotNullFieldTest[packet,
		{
			LiquidHandler,
			Bleach,
			BleachVolumeFraction,
			BleachTime
		}
	]

};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceCleanQTests*)


validModelMaintenanceCleanQTests[packet:PacketP[Model[Maintenance,Clean]]]:={

	NotNullFieldTest[packet,Targets]

};




(* ::Subsection::Closed:: *)
(*validModelMaintenanceCleanDSCQTests*)


validModelMaintenanceCleanDSCQTests[packet:PacketP[Model[Maintenance,Clean,DifferentialScanningCalorimeter]]]:={
	
	(* Fields that should be filled in *)
	NotNullFieldTest[packet,{
		Targets,
		CleaningSolution
	}]
};





(* ::Subsection::Closed:: *)
(*validModelMaintenanceCleanDispenserQTests*)


validModelMaintenanceCleanDispenserQTests[packet:PacketP[Model[Maintenance,Clean,Dispenser]]]:={
	(* Fields that should be filled in *)
	NotNullFieldTest[
		packet,
		{
			Targets,
			GraduatedCylinders
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceCleanESISourceQTests*)


validModelMaintenanceCleanESISourceQTests[packet:PacketP[Model[Maintenance,Clean,ESISource]]]:={
	RequiredTogetherTest[packet,
		{CleaningSolventModel,RinseContainerModel,FillVolume}
	]
};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceCleanFreezerQTests*)


validModelMaintenanceCleanFreezerQTests[packet:PacketP[Model[Maintenance, Clean, Freezer]]]:={

	(* fields that should be filled. *)
	NotNullFieldTest[packet,
		{
			Targets,
			FrostRemoval
		}
	],

	Test[
		"If FrostRemoval-> True then IceScraperModel and RubberMalletModel are informed",
		Lookup[packet,{FrostRemoval, IceScraperModel, RubberMalletModel}],
		Alternatives[{True, ObjectP[Model[Item, IceScraper]], ObjectP[Model[Item, RubberMallet]]}, {False, Null, Null}]
	]

};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceCleanOperatorCartQTests*)


validModelMaintenanceCleanOperatorCartQTests[packet:PacketP[Model[Maintenance,Clean,OperatorCart]]]:={
	(* fields that should be filled. *)
	NotNullFieldTest[packet,{Targets,ReservoirRacks,Ethanol,Methanol,Isopropanol,Acetone}]
};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceCleanPeptideSynthesizerQTests*)


validModelMaintenanceCleanPeptideSynthesizerQTests[packet:PacketP[Model[Maintenance,Clean,PeptideSynthesizer]]]:={
	(* Fields that should be filled in *)
	NotNullFieldTest[
		packet,
		{
			PrimaryWashSolvent,
			SecondaryWashSolvent,
			CleavageLineSolvent,
			PrimaryWashSolventContainer,
			SecondaryWashSolventContainer,
			CleavageLineSolventContainer,
			PrimaryWashSolventVolume,
			SecondaryWashSolventVolume,
			CleavageLineSolventVolume,
			CollectionVessels
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceCleanpHDetectorQTests*)


validModelMaintenanceCleanpHDetectorQTests[packet:PacketP[Model[Maintenance,Clean,pHDetector]]]:={
	(* Fields that should be filled in *)
	NotNullFieldTest[
		packet,
		{
			pHElectrodeWashSolvent,
			pHElectrodeRinseSolvent,
			pHElectrodeFillSolution,
			ElectrodeWashSolventContainer,
			ElectrodeRinseSolventContainer,
			FillSolutionContainer,
			pHElectrodeWashSolventVolume,
			pHElectrodeRinseSolventVolume,
			FillSolutionVolume
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceCleanPlateWasherQTests*)


validModelMaintenanceCleanPlateWasherQTests[packet:PacketP[Model[Maintenance,Clean,PlateWasher]]]:={
	(* Fields that should be filled in *)
	NotNullFieldTest[
		packet,
		{
			WashSolvent,
			MaintenancePlate,
			WashVolume,
			NumberOfWashes
		}
	]
};
(* ::Subsection::Closed:: *)
(*validModelMaintenanceCreateHamiltonLabwareQTests*)


validModelMaintenanceCreateHamiltonLabwareQTests[packet:PacketP[Model[Maintenance,CreateHamiltonLabware]]]:={

};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceHandwashQTests*)


validModelMaintenanceHandwashQTests[packet:PacketP[Model[Maintenance,Handwash]]]:={
	(* Fields that should be informed *)
	NotNullFieldTest[packet,
		{
			LabwareTypes,
			MinThreshold,
			PartitionThreshold,
			ThermoplasticWrapModel,
			WaterPurifierModel,
			BottleRollerModel,
			Targets,
			FumeHoodModels
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceDecontaminateQTests*)


validModelMaintenanceDecontaminateQTests[packet:PacketP[Model[Maintenance,Decontaminate]]]:={
	(* Fields that should be filled in *)
	NotNullFieldTest[packet,Targets]

};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceDecontaminateHPLCQTests*)


validModelMaintenanceDecontaminateHPLCQTests[packet:PacketP[Model[Maintenance,Decontaminate,HPLC]]]:={
	(* Fields that should be filled in *)
	NotNullFieldTest[packet,
		{
			(* shared fields*)
			Targets,
			(* unique fields*)
			BufferA,
			BufferB,
			BufferC,
			GradientMethods
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceDecontaminateIncubatorQTests*)


validModelMaintenanceDecontaminateIncubatorQTests[packet:PacketP[Model[Maintenance,Decontaminate,Incubator]]]:={
	(* Fields that should be filled in *)
	NotNullFieldTest[packet,
		{
			(* unique fields*)
			DrainReservoir,
			RefillRequired,
			RemovableIncubatorDeck,
			ContentsStorageLocation
		}
	],
	(* All required for draining reservoir *)
	RequiredTogetherTest[packet,
		{
			WasteContainer,
			Aspirator
		}
	],
	Test["If DrainReservoir is set to True, then ReservoirDeckSlotName, Aspirator and WasteContainer are informed",
		Lookup[packet,{DrainReservoir,ReservoirDeckSlotName,Aspirator,WasteContainer}],
		Alternatives[{True,_String,ObjectP[{Model[Instrument,Aspirator],Model[Part,HandPump]}],ObjectP[Model[Container]]},{False,Null,Null,Null}]
	]
};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceDecontaminateLiquidHandlerQTests*)


validModelMaintenanceDecontaminateLiquidHandlerQTests[packet:PacketP[Model[Maintenance,Decontaminate, LiquidHandler]]]:={
	(* Fields that should be filled in *)
	NotNullFieldTest[packet,Targets]

};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceDefrostQTests*)


validModelMaintenanceDefrostQTests[packet:PacketP[Model[Maintenance,Defrost]]]:={
	(* Fields that should be filled in *)
	NotNullFieldTest[
		packet,
		{
			Targets,
			AbsorbentMatModel,
			AbsorbentMatNumber
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceDishwashQTests*)


validModelMaintenanceDishwashQTests[packet:PacketP[Model[Maintenance,Dishwash]]]:={
	NotNullFieldTest[packet,
		{
			DishwashMethod,
			Targets,
			MinThreshold
		}
	],

	(* more advanced checks *)
	Test[
		"If the Dishwash method is plastic or intensive then FumeHood models must be specified:",
		Lookup[packet, {DishwashMethod, FumeHoodModels}],
		Alternatives[{DishwashIntensive|DishwashPlastic, Except[NullP|{}]}, {Except[DishwashIntensive|DishwashPlastic], _}]
	]
};

(* ::Subsection::Closed:: *)
(*validModelMaintenanceFlushQTests*)

validModelMaintenanceFlushQTests[packet:PacketP[Model[Maintenance,Flush]]]:={
	NotNullFieldTest[packet,
		{
			SystemFlushGradient
		}
	]
};

(* ::Subsection::Closed:: *)
(*validModelMaintenanceEmptyWasteQTests*)


validModelMaintenanceEmptyWasteQTests[packet:PacketP[Model[Maintenance,EmptyWaste]]]:={

	(* Fields that should be informed *)
	NotNullFieldTest[packet,
		{
			Targets,
			WasteType,
			ReplacementResources
		}
	],

	Test[
		"If Model[Maintenance, EmptyWaste, \"Empty Biohazardous Waste\"] for Biohazard waste, then AutoclaveModel and AutoclaveProgram should be informed:",
		Lookup[packet, {Object, AutoclaveModel, AutoclaveProgram}],
		Alternatives[{Model[Maintenance, EmptyWaste, "id:dORYzZn0o4Kb"],ObjectP[Model[Instrument, Autoclave]], Liquid},{Except[Model[Maintenance, EmptyWaste, "id:dORYzZn0o4Kb"]], _, _}]
	]
};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceParameterizeContainerQTests*)


validModelMaintenanceParameterizeContainerQTests[packet:PacketP[Model[Maintenance,ParameterizeContainer]]]:={
(* don't need any tests *)
};

(* ::Subsection::Closed:: *)
(*validModelMaintenanceRefillReservoirQTests*)


validModelMaintenanceRefillTransferEnvironmentQTests[packet:PacketP[Model[Maintenance,RefillTransferEnvironment]]]:={};

(* ::Subsection::Closed:: *)
(*validModelMaintenanceRefillReservoirQTests*)


validModelMaintenanceRefillReservoirQTests[packet:PacketP[Model[Maintenance,RefillReservoir]]]:={

	(* shared fields shaping *)
	If[!MatchQ[Lookup[packet,Type], (Model[Maintenance,RefillReservoir,NMR]|Model[Maintenance, RefillReservoir, HPLC]|Model[Maintenance, RefillReservoir, pHMeter]|Model[Maintenance,RefillReservoir,LiquidParticleCounter]|Model[Maintenance, RefillReservoir, FPLC])],
		 NotNullFieldTest[packet,
			{
				Targets,
				FillContainerModel,
				DrainReservoir,
				RemovableReservoirContainer
			}
		];

		 (* All required for refilling reservoir, none required when emptying speedvac trap *)
		RequiredTogetherTest[packet,
			{
				Capacity,
				FillVolume,
				FillLiquidModel,
				RemovableReservoirContainer
			}
		],
		{}
	],

	(* If rinsing then all rinsing stuff required together *)
	RequiredTogetherTest[packet, {ReservoirRinseLiquid, ReservoirRinseVolume, RinseContainerModel}],

	(* If MinResistivity is informed, then we need MaxResistivity *)
	RequiredTogetherTest[packet, {MinResistivity, MaxResistivity}],

	(* If both Capacity and RefillReservoir are informed, they should have the same unit. *)
	Test[
		"Capacity and RefillReservoir should have compatible units if both are informed:",
		If[
			!NullQ[Lookup[packet, Capacity]] && !NullQ[Lookup[packet, FillVolume]],
			CompatibleUnitQ[Lookup[packet, Capacity], Lookup[packet, FillVolume]],
			True
		],
		True
	],

	(* comparison *)
	FieldComparisonTest[packet, {MinResistivity, MaxResistivity}, LessEqual],
	FieldComparisonTest[packet, {Capacity , FillVolume}, GreaterEqual]

};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceRefillReservoirHPLCQTests*)


validModelMaintenanceRefillReservoirHPLCQTests[packet:PacketP[Model[Maintenance,RefillReservoir, HPLC]]]:={

	(* shared fields shaping *)
	NotNullFieldTest[packet,
		{
			Targets,
			Capacity,
			FillVolume,
			ReservoirContainerModel,
			FillLiquidModel,
			FillContainerModel,
			ReservoirDeck,
			ReservoirDeckName,
			ReservoirDeckSlotName
		}
	]
};

(* ::Subsection::Closed:: *)
(*validModelMaintenanceRefillReservoirHPLCQTests*)


validModelMaintenanceRefillReservoirLiquidParticleCounterQTests[packet:PacketP[Model[Maintenance,RefillReservoir, LiquidParticleCounter]]]:={

	(* shared fields shaping *)
	NotNullFieldTest[packet,
		{
			Targets,
			FillVolume,
			FillLiquidModel,
			FillContainerModel,
			ReservoirLocationName
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceRefillReservoirNMRQTests*)


validModelMaintenanceRefillReservoirNMRQTests[packet:PacketP[Model[Maintenance,RefillReservoir, NMR]]]:={

	(* shared fields shaping *)
	NotNullFieldTest[packet,
		{
			Targets,
			Capacity,
			RemovableReservoirContainer,
			PartialRefill,
			FillLiquidModel,
			FillContainerModel,
			ReservoirDeckSlotName,
			HeatGunModels,
			FaceShieldModels,
			CryoGloveModels
		}
	]
};

(* ::Subsection::Closed:: *)
(*validModelMaintenanceRefillReservoirpHMeterQTests*)


validModelMaintenanceRefillReservoirpHMeterQTests[packet:PacketP[Model[Maintenance,RefillReservoir, pHMeter]]]:={

	(* shared fields shaping *)
	NotNullFieldTest[packet,
		{
			Targets,
			Capacities,
			FillLiquidModel,
			FillContainerModel,
			ReservoirDeckSlotNames,
			ReservoirContainers
		}
	]
};

(* ::Subsection::Closed:: *)
(*validModelMaintenanceRebuildQTests*)


validModelMaintenanceRebuildQTests[packet:PacketP[Model[Maintenance,Rebuild]]]:={
	NotNullFieldTest[packet,Targets]
};

(* ::Subsection::Closed:: *)
(*validModelMaintenanceRebuildPumpQTests*)


validModelMaintenanceRebuildPumpQTests[packet:PacketP[Model[Maintenance,Rebuild,Pump]]]:={
	NotNullFieldTest[packet,
		{
			ToolBox,
			FlowRestrictor,
			CheckValves,
			PistonSeals,
			Pistons,
			FlushBuffer
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceInstallGasCylinderQTests*)


validModelMaintenanceInstallGasCylinderQTests[packet:PacketP[Model[Maintenance,InstallGasCylinder]]]:={
	NotNullFieldTest[packet,{Targets, ExchangeableCylinder}]
};

(* ::Subsection::Closed:: *)
(*validMaintenanceLubricateQTests*)


validModelMaintenanceLubricateQTests[packet:PacketP[Model[Maintenance,Lubricate]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Target,
			Lubricant
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceReceiveInventoryQTests*)


validModelMaintenanceReceiveInventoryQTests[packet:PacketP[Model[Maintenance,ReceiveInventory]]]:={
	NotNullFieldTest[packet, {ReceivingBench, ReceivingPrice, MeasureVolumePrice, MeasureWeightPrice}]
};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceReplaceQTests*)


validModelMaintenanceReplaceQTests[packet:PacketP[Model[Maintenance,Replace]]]:={
	NotNullFieldTest[packet,Targets]
};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceReplaceBufferCartridgeQTests*)


validModelMaintenanceReplaceBufferCartridgeQTests[packet:PacketP[Model[Maintenance,Replace,BufferCartridge]]]:={
	NotNullFieldTest[packet, {Targets,BufferCartridgeSepta}]
};

(* ::Subsection::Closed:: *)
(*validModelMaintenanceReplacepHProbeQTests*)


validModelMaintenanceReplacepHProbeQTests[packet:PacketP[Model[Maintenance,Replace,pHProbe]]]:={

};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceReplaceFilterQTests*)


validModelMaintenanceReplaceFilterQTests[packet:PacketP[Model[Maintenance,Replace,Filter]]]:={

	NotNullFieldTest[packet,{Targets,Preactivation}],

	(* If activation liquid is filled, its volume and container must also be filled. *)
	RequiredTogetherTest[packet, {FilterActivationLiquid, ActivationLiquidContainer, ActivationLiquidVolume}]
};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceReplaceLampQTests*)


validModelMaintenanceReplaceLampQTests[packet:PacketP[Model[Maintenance,Replace,Lamp]]]:={

};

(* ::Subsection::Closed:: *)
(*validModelMaintenanceReplaceSealsQTests*)


validModelMaintenanceReplaceSealsQTests[packet:PacketP[Model[Maintenance,Replace,Seals]]]:={

	NotNullFieldTest[packet,{CleaningSolventModel, ReplacementParts, RinseContainerModel, FillVolume,TargetPumps, BufferModel, ContainerModels}]
};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceReplaceSensorQTests*)


validModelMaintenanceReplaceSensorQTests[packet:PacketP[Model[Maintenance,Replace,Sensor]]]:={
	
	NotNullFieldTest[packet,{Target,PressureSensor,ConductivitySensor}]
};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceStorageUpdateQTests*)


validModelMaintenanceStorageUpdateQTests[packet:PacketP[Model[Maintenance,StorageUpdate]]]:={
	NotNullFieldTest[packet,Targets]
};



(* ::Subsection::Closed:: *)
(*validModelMaintenanceShippingQTests*)


validModelMaintenanceShippingQTests[packet:PacketP[Model[Maintenance,Shipping]]]:={
	NotNullFieldTest[packet,{HandlingPrice,Ice,DryIce,Padding,PlateSeal,PeanutsDispenser,DryIceDispenser,ShippingLabelFilePath,PackageCapacity,PackingMaterialsCapacity}]
};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceReplaceVacuumPumpQTests*)


validModelMaintenanceReplaceVacuumPumpQTests[packet:PacketP[Model[Maintenance,Replace,VacuumPump]]]:={
	NotNullFieldTest[packet,{
		Targets,
		HPLCStackTool,
		HPLCStackToolBit,
		HPLCDegasserTool,
		HPLCVacuumPumpTool
	}]
};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceReplaceGasFilterQTests*)


validModelMaintenanceReplaceGasFilterQTests[packet:PacketP[Model[Maintenance,Replace,GasFilter]]]:={
	NotNullFieldTest[packet,{
		Targets,
		GasFilter
	}]
};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceCalibrateLLDQTests*)


validModelMaintenanceCalibrateLLDQTests[packet:PacketP[Model[Maintenance,CalibrateLLD]]]:={
	NotNullFieldTest[packet,{
		Targets,
		Distances
	}]
};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceCalibrateMeltingPointApparatusQTests*)


validModelMaintenanceCalibrateMeltingPointApparatusQTests[packet:PacketP[Model[Maintenance, CalibrateMeltingPointApparatus]]]:={
	NotNullFieldTest[packet,{
		MeltingPointStandards,
		AdjustmentMethod,
		Desiccate,
		Grind
	}],

	(* samples in MeltingPointStandards are not duplicates *)
	Test[
		"Samples in MeltingPointStandards are not duplicates:",
		DuplicateFreeQ[Download[Lookup[packet, MeltingPointStandards], Object]],
		True
	]
};

(* ::Subsection::Closed:: *)
(*validModelMaintenanceRefillReservoirFPLCQTests*)


validModelMaintenanceRefillReservoirFPLCQTests[packet:PacketP[Model[Maintenance,RefillReservoir, FPLC]]]:={

	(* shared fields shaping *)
	NotNullFieldTest[packet,
		{
			Capacities,
			FillVolumes,
			FillLiquidModel,
			FillContainerModel,
			ReservoirDeckSlotNames,
			ReservoirContainers
		}
	]
};

(* ::Subsection::Closed:: *)
(*validModelMaintenanceUpdateLiquidHandlerDeckAccuracyQTests*)


validModelMaintenanceUpdateLiquidHandlerDeckAccuracyQTests[packet:PacketP[Model[Maintenance,UpdateLiquidHandlerDeckAccuracy]]]:={

	(* shared fields shaping *)
	NotNullFieldTest[packet,
		{
			NumberOfWells
		}
	]
};

(* ::Subsection::Closed:: *)
(*validModelMaintenanceCalibrateDNASynthesizerQTests*)


validModelMaintenanceCalibrateDNASynthesizerQTests[packet:PacketP[Model[Maintenance,CalibrateDNASynthesizer]]]:={

	(*Valves must not have duplicates*)
	Test[
		"Valves does not contain duplicates:",
		DuplicateFreeQ[Lookup[packet,Valves]],
		True
	],

	(* ValveDensities is same length as Valves *)
	Test[
		"The length of ValveDensities matches the length of Valves:",
		Length[Lookup[packet, ValveDensities]] == Length[Lookup[packet, Valves]],
		True
	],

	(* DispenseTimes outer list is same length as Valves *)
	Test[
		"The length of DispenseTimes matches the length of Valves:",
		Length[Lookup[packet, DispenseTimes]] == Length[Lookup[packet, Valves]],
		True
	],

	(* DispenseTimes innner list is same length as Valves *)
	Test[
		"The length of each DispenseTimes element matches DispensePoints:",
		MatchQ[Map[Length[#] &, Lookup[packet, DispenseTimes]], {Lookup[packet, DispensePoints]..}],
		True
	],

	NotNullFieldTest[packet,{MinRSquared}]
};


(* ::Subsection::Closed:: *)
(*validModelMaintenanceAuditGasCylindersQTests*)


validModelMaintenanceAuditGasCylindersQTests[packet:PacketP[Model[Maintenance,AuditGasCylinders]]]:={

	(* fields not null *)
	(*NotNullFieldTest[packet,
		{
		}
	]*)
};


(* ::Subsection:: *)
(* Test Registration*)


registerValidQTestFunction[Model[Maintenance],validModelMaintenanceQTests];
registerValidQTestFunction[Model[Maintenance, AlignLiquidHandlerDevicePrecision],validModelMaintenanceAlignLiquidHandlerDevicePrecisionQTests];
registerValidQTestFunction[Model[Maintenance, Autoclave],validModelMaintenanceAutoclaveQTests];
registerValidQTestFunction[Model[Maintenance, CalibrateApertureTube],validModelMaintenanceCalibrateApertureTubeQTests];
registerValidQTestFunction[Model[Maintenance, CalibrateAutosampler],validModelMaintenanceCalibrateAutosamplerQTests];
registerValidQTestFunction[Model[Maintenance, CalibrateBalance],validModelMaintenanceCalibrateBalanceQTests];
registerValidQTestFunction[Model[Maintenance, CalibrateBalance, CrossFlowFiltration],validModelMaintenanceCalibrateBalanceCrossFlowFiltrationQTests];
registerValidQTestFunction[Model[Maintenance, CalibrateCarbonDioxide],validModelMaintenanceCalibrateCarbonDioxideQTests];
registerValidQTestFunction[Model[Maintenance, CalibrateConductivity],validModelMaintenanceCalibrateConductivityQTests];
registerValidQTestFunction[Model[Maintenance, CalibrateDNASynthesizer],validModelMaintenanceCalibrateDNASynthesizerQTests];
registerValidQTestFunction[Model[Maintenance, CalibrateElectrochemicalReactor],validModelMaintenanceCalibrateElectrochemicalReactorQTests];
registerValidQTestFunction[Model[Maintenance, CalibrateGasSensor],validModelMaintenanceCalibrateGasSensorQTests];
registerValidQTestFunction[Model[Maintenance, CalibrateLevel],validModelMaintenanceCalibrateLevelQTests];
registerValidQTestFunction[Model[Maintenance, CalibrateLightScattering],validModelMaintenanceCalibrateLightScatteringQTests];
registerValidQTestFunction[Model[Maintenance, CalibrateLightScattering, Plate],validModelMaintenanceCalibrateLightScatteringPlateQTests];
registerValidQTestFunction[Model[Maintenance, CalibrateLLD],validModelMaintenanceCalibrateLLDQTests];
registerValidQTestFunction[Model[Maintenance, CalibrateMeltingPointApparatus],validModelMaintenanceCalibrateMeltingPointApparatusQTests];
registerValidQTestFunction[Model[Maintenance, CalibrateNMRShim],validModelMaintenanceCalibrateNMRShimQTests];
registerValidQTestFunction[Model[Maintenance, CalibrateMicroscope],validModelMaintenanceCalibrateMicroscopeQTests];
registerValidQTestFunction[Model[Maintenance, CalibratePathLength],validModelMaintenanceCalibratePathLengthQTests];
registerValidQTestFunction[Model[Maintenance, CalibratepH],validModelMaintenanceCalibratepHQTests];
registerValidQTestFunction[Model[Maintenance, CalibratePressure],validModelMaintenanceCalibratePressureQTests];
registerValidQTestFunction[Model[Maintenance, CalibrateRelativeHumidity],validModelMaintenanceCalibrateRelativeHumidityQTests];
registerValidQTestFunction[Model[Maintenance, CalibrateTemperature],validModelMaintenanceCalibrateTemperatureQTests];
registerValidQTestFunction[Model[Maintenance, CalibrateVolume],validModelMaintenanceCalibrateVolumeQTests];
registerValidQTestFunction[Model[Maintenance, CalibrateWeight],validModelMaintenanceCalibrateWeightQTests];
registerValidQTestFunction[Model[Maintenance, CellBleach],validModelMaintenanceCellBleachQTests];
registerValidQTestFunction[Model[Maintenance, Clean],validModelMaintenanceCleanQTests];
registerValidQTestFunction[Model[Maintenance, Clean, DifferentialScanningCalorimeter],validModelMaintenanceCleanDSCQTests];
registerValidQTestFunction[Model[Maintenance, Clean, Dispenser],validModelMaintenanceCleanDispenserQTests];
registerValidQTestFunction[Model[Maintenance, Clean, ESISource],validModelMaintenanceCleanESISourceQTests];
registerValidQTestFunction[Model[Maintenance, Clean, Freezer],validModelMaintenanceCleanFreezerQTests];
registerValidQTestFunction[Model[Maintenance, Clean, OperatorCart],validModelMaintenanceCleanOperatorCartQTests];
registerValidQTestFunction[Model[Maintenance, Clean, PeptideSynthesizer],validModelMaintenanceCleanPeptideSynthesizerQTests];
registerValidQTestFunction[Model[Maintenance, Clean, pHDetector],validModelMaintenanceCleanpHDetectorQTests];
registerValidQTestFunction[Model[Maintenance, Clean, PlateWasher],validModelMaintenanceCleanPlateWasherQTests];
registerValidQTestFunction[Model[Maintenance, CreateHamiltonLabware],validModelMaintenanceCreateHamiltonLabwareQTests];
registerValidQTestFunction[Model[Maintenance, Decontaminate],validModelMaintenanceDecontaminateQTests];
registerValidQTestFunction[Model[Maintenance, Decontaminate, HPLC],validModelMaintenanceDecontaminateHPLCQTests];
registerValidQTestFunction[Model[Maintenance, Decontaminate, Incubator],validModelMaintenanceDecontaminateIncubatorQTests];
registerValidQTestFunction[Model[Maintenance, Decontaminate, LiquidHandler],validModelMaintenanceDecontaminateLiquidHandlerQTests];
registerValidQTestFunction[Model[Maintenance, Defrost],validModelMaintenanceDefrostQTests];
registerValidQTestFunction[Model[Maintenance, Dishwash],validModelMaintenanceDishwashQTests];
registerValidQTestFunction[Model[Maintenance, Flush],validModelMaintenanceFlushQTests];
registerValidQTestFunction[Model[Maintenance, EmptyWaste],validModelMaintenanceEmptyWasteQTests];
registerValidQTestFunction[Model[Maintenance, Handwash],validModelMaintenanceHandwashQTests];
registerValidQTestFunction[Model[Maintenance, InstallGasCylinder],validModelMaintenanceInstallGasCylinderQTests];
registerValidQTestFunction[Model[Maintenance, Lubricate],validModelMaintenanceLubricateQTests];
registerValidQTestFunction[Model[Maintenance, ReceiveInventory], validModelMaintenanceReceiveInventoryQTests];
registerValidQTestFunction[Model[Maintenance, ParameterizeContainer], validModelMaintenanceParameterizeContainerQTests];
registerValidQTestFunction[Model[Maintenance, RefillReservoir],validModelMaintenanceRefillReservoirQTests];
registerValidQTestFunction[Model[Maintenance, RefillTransferEnvironment],validModelMaintenanceRefillTransferEnvironmentQTests];
registerValidQTestFunction[Model[Maintenance, RefillReservoir, FPLC],validModelMaintenanceRefillReservoirFPLCQTests];
registerValidQTestFunction[Model[Maintenance, RefillReservoir, HPLC],validModelMaintenanceRefillReservoirHPLCQTests];
registerValidQTestFunction[Model[Maintenance, RefillReservoir, LiquidParticleCounter],validModelMaintenanceRefillReservoirLiquidParticleCounterQTests];
registerValidQTestFunction[Model[Maintenance, RefillReservoir, NMR],validModelMaintenanceRefillReservoirNMRQTests];
registerValidQTestFunction[Model[Maintenance, RefillReservoir, pHMeter],validModelMaintenanceRefillReservoirpHMeterQTests];
registerValidQTestFunction[Model[Maintenance, Rebuild],validModelMaintenanceRebuildQTests];
registerValidQTestFunction[Model[Maintenance, Rebuild, Pump],validModelMaintenanceRebuildPumpQTests];
registerValidQTestFunction[Model[Maintenance, Replace],validModelMaintenanceReplaceQTests];
registerValidQTestFunction[Model[Maintenance, Replace, BufferCartridge],validModelMaintenanceReplaceBufferCartridgeQTests];
registerValidQTestFunction[Model[Maintenance, Replace, Filter],validModelMaintenanceReplaceFilterQTests];
registerValidQTestFunction[Model[Maintenance, Replace, Lamp],validModelMaintenanceReplaceLampQTests];
registerValidQTestFunction[Model[Maintenance, Replace, pHProbe],validModelMaintenanceReplacepHProbeQTests];
registerValidQTestFunction[Model[Maintenance, Replace, Seals],validModelMaintenanceReplaceSealsQTests];
registerValidQTestFunction[Model[Maintenance, Replace, Sensor],validModelMaintenanceReplaceSensorQTests];
registerValidQTestFunction[Model[Maintenance, Replace, GasFilter],validModelMaintenanceReplaceGasFilterQTests];
registerValidQTestFunction[Model[Maintenance, Replace, VacuumPump],validModelMaintenanceReplaceVacuumPumpQTests];
registerValidQTestFunction[Model[Maintenance, StorageUpdate],validModelMaintenanceStorageUpdateQTests];
registerValidQTestFunction[Model[Maintenance, Shipping],validModelMaintenanceShippingQTests];
registerValidQTestFunction[Model[Maintenance, TrainInternalRobotArm],validModelMaintenanceTrainInternalRobotArmPositionQTests];
registerValidQTestFunction[Model[Maintenance, UpdateLiquidHandlerDeckAccuracy],validModelMaintenanceUpdateLiquidHandlerDeckAccuracyQTests];
registerValidQTestFunction[Model[Maintenance, AuditGasCylinders],validModelMaintenanceAuditGasCylindersQTests];

