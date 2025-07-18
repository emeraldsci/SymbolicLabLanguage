(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*validMaintenanceQTests*)


validMaintenanceQTests[packet:PacketP[Object[Maintenance]]]:= Module[
	{
		parentProtocolStatus = If[
			NullQ[Lookup[packet, ParentProtocol]],
			Null,
			Download[Lookup[packet, ParentProtocol], Status]
		],
		parentProtocolOperationStatus = If[
			NullQ[Lookup[packet, ParentProtocol]],
			Null,
			Download[Lookup[packet, ParentProtocol], OperationStatus]
		]
	},

	{

		(* GENERAL*)
		NotNullFieldTest[packet,
			{
				Status
			}
		],

		(* maintenance doesn't use InCart *)
		Test[
			"Status is not InCart:",
			Lookup[packet, Status],
			Except[InCart]
		],

		(* Tests to be performed on all objects except maintenance calibration for which calibration function is supplied by manufacturer*)
		If[
			!TrueQ[Lookup[packet,ManufacturerCalibration]],
			{
				NotNullFieldTest[packet, DateConfirmed]
			},
			Nothing
		],

		(* DATES *)
		Test["DateConfirmed should be entered when the maintenance has been confirmed to run in the lab but has not yet entered the processing queue:",
			Flatten[{Lookup[packet, Status], ContainsOnly[Lookup[packet, StatusLog][[All, 2]], {InCart,Canceled}], Lookup[packet,{OperationStatus,DateConfirmed}]}],
			Alternatives[
				{InCart,_,_,Null},
			(* need to confirm a protocol for it to be in the backlog*)
				{Backlogged|ShippingMaterials,_,_,Except[Null]},
			(* if the protocol was canceled from InCart, then it was never Confirmed and should not have the associated date *)
				{Canceled,True,_,Null},
			(* if the protocol was canceled further along, then it must have been Confirmed first *)
				{Canceled,False,_,Except[Null]},
				{Processing,_,_, Except[Null]},
				{Completed,_,_, Except[Null]},
				{Aborted,_,_, Except[Null]}
			]
		],

		Test["DateEnqueued should be entered when the maintenance has been confirmed to run in the lab and has entered the processing queue:",
			Flatten[{Lookup[packet, Status], ContainsAny[Lookup[packet, StatusLog][[All, 2]], {OperatorStart}], Lookup[packet,{OperationStatus,DateEnqueued}]}],
			Alternatives[
				{InCart,_,_,Null},
				(* if protocol is Backlogged and has been started (i.e., it was sent into ShippingMaterials and then sent back), DateEnqueued can still be populated *)
				{Backlogged,True,_, _},
				(* if protocol is Backlogged and has not been started, DateEnqueued should not be populated *)
				{Backlogged,False,_, Null},
				(* If protocol is ShippingMaterials and has not been started, DateEnqueued should not be populated *)
				{ShippingMaterials,False,_,Null},
				(* If protocol is ShippingMaterials but has been started, DateEnqueued should be populated *)
				{ShippingMaterials,True,_,Except[Null]},
				(* If the protocol was canceled from Processing, the only status in its log can be InCart/OperatorStart/Backlogged/ShippingMaterials *)
				{Canceled,True,_,Except[Null]},
				{Canceled,False,_,Null},
				{Processing, _, _, Except[Null]},
				{Completed, _, _, Except[Null]},
				{Aborted, _, _, Except[Null]}
			]
		],

		Test["DateStarted should be entered when the maintenance has been started in the lab:",
			Lookup[packet, {Status,OperationStatus,DateStarted}],
			Alternatives[
				{InCart,_,Null},
				{Backlogged,_,Null},
				{Canceled,_,Null},
				{Processing, Alternatives[OperatorProcessing, InstrumentProcessing, OperatorReady, ScientificSupport], Except[Null]},
				(* a protocol is allowed to have DateStarted populated if in ShippingMaterials (or even Backlogged) (could have been started but then needed to wait) *)
				{ShippingMaterials, _, _},
				{Backlogged,_,_},
				(* DateStarted is set when the protocol is ran for the very first time. If OS is OS that means it means it hasn't been started yet*)
				(* however, if the protocol went into ShippingMaterials and then back into the Backlog and then back to OperatorStart, it would still have been started the first time *)
				{Processing, Alternatives[OperatorStart,None], _},
				{Completed, _, Except[Null]},
				{Aborted, _, Except[Null]}
			]
		],

		Test["DateCanceled should be entered when a protocol has been canceled:",
			Lookup[packet, {Status,DateCanceled}],
			Alternatives[
				{Canceled,Except[Null]},
				{Except[Canceled],Null}
			]
		],

		Test["DateCompleted should be entered when a protocol has finished running or been aborted:",
			Lookup[packet, {Status,DateCompleted}],
			Alternatives[
				{Completed|Aborted,Except[Null]},
				{Except[Completed|Aborted],Null}
			]
		],

		Test["If not Null, DateConfirmed <= DateEnqueued <= DateStarted <= DateCompleted:",
			LessEqual@@DeleteCases[Lookup[packet,{DateConfirmed,DateEnqueued,DateStarted,DateCompleted}],Null],
			True
		],

	(* Note DateCanceled can be before or after DateStarted... so cannot be in the same test *)
		Test["If not Null DateConfirmed <= DateEnqueued <= DateCanceled <= DateCompleted:",
			LessEqual@@DeleteCases[Lookup[packet,{DateConfirmed,DateEnqueued,DateCanceled,DateCompleted}],Null],
			True
		],

	(* CHILD/PARENT PROTOCOLS *)
		Test[
			"If the maintenance is OperationStatus->ScientificSupport, its parent protocol must be OperationStatus->ScientificSupport as well:",
			{Lookup[packet, ParentProtocol], parentProtocolOperationStatus, Lookup[packet, OperationStatus]},
			{ObjectP[], ScientificSupport, ScientificSupport} | {NullP, NullP, ScientificSupport} | {_, _, Except[ScientificSupport]}
		],

		Test[
			"If the maintenance has a ParentProtocol and the ParentProtocol is finished (Status-> Canceled, Completed, or Aborted), this control must also be finished (Status-> Canceled, Completed, or Aborted):",
			{parentProtocolStatus, Lookup[packet, Status]},
			{Canceled | Completed | Aborted, Canceled | Completed | Aborted} | {Except[Canceled | Completed | Aborted], _}
		],

		Test[
			"If the maintenance has a ParentProtocol and the ParentProtocol is not started (Status-> InCart), this maintenance must also be not started (Status-> InCart, or Canceled):",
			{parentProtocolStatus, Lookup[packet, Status]},
			{InCart, InCart} | {Except[InCart], _}
		],

	(* REPLACEMENT PROTOCOL*)
		Test[
			"A replacement protocol may only be specified if the status of this protocol is Aborted:",
			Lookup[packet, {Status, ReplacementProtocol}],
			{Except[Aborted], NullP} | {Aborted, _}
		],

		(* EXECUTION FIELDS *)
		Test[
			"If the maintenance has not been started, the following fields must be Null: Data, Figures, and UserCommunications:",
			Lookup[packet, {Status, Data, UserCommunications}],
			Alternatives[
				{Alternatives[InCart, Canceled], {}, {}},
				{Except[Alternatives[InCart, Canceled]], ___, ___}
			]
		],

		Test[
			"ActiveCart is not informed if Status is Completed or Aborted:",
			Lookup[packet, {Status, ActiveCart}],
			{Completed | Aborted, NullP} | {Except[Completed | Aborted], _}
		],

		Test[
			"CurrentOperator is not informed if Status is Completed or Aborted:",
			Lookup[packet, {Status, CurrentOperator}],
			{Completed | Aborted, NullP} | {Except[Completed | Aborted], _}
		],

		Test[
			"CurrentOperator is not informed if Status is InCart:",
			Lookup[packet, {Status, CurrentOperator}],
			{InCart, NullP} | {Except[InCart], _}
		],

	(* OPERATION STATUS *)
		Test[
			"If the maintenance Status is Processing, then OperationStatus is OperatorProcessing, InstrumentProcessing, ScientificSupport, or OperatorReady. If the control Status is not running, OperationStatus must be Null or None:",
			Lookup[packet, {Status, OperationStatus}],
			Alternatives[
				{Processing,OperatorStart|OperatorProcessing|InstrumentProcessing|OperatorReady|ScientificSupport},
				{Except[Processing],NullP|None}
			]
		],

		(* TROUBLESHOOTING *)
		Test["If a protocol is not currently executing, the ScientificSupport fields are not informed:",
			Lookup[packet,{Status,CartResources,CartInstruments}],
			{Processing,___}|{Except[(Processing)],{},{}}
		],

		(* INSTRUMENTS *)
		(* note if it's enqueued, some maintenance can have resources already picked like Dishwash *)
		Test[
			"If the maintenance has not been started, Resources, and CurrentInstruments must be Null:",
			Lookup[packet, {Status, Resources, CurrentInstruments}],
			Alternatives[
				{Alternatives[InCart, Canceled], {}, {}},
				{Except[Alternatives[InCart, Canceled]], ___, ___}
			]
		],
		Test["If the maintenance has been completed Resources and CurrentInstruments must be empty:",
			Lookup[packet, {Status,Resources,CurrentInstruments}],
			Alternatives[
				{Alternatives[Completed,Aborted],{},{}},
				{Except[Alternatives[Completed,Aborted]],___}
			]
		],

		(* QUEUED SAMPLES *)
		Test["If the maintenance has not been started, sample queue fields must be empty:",
			Lookup[packet,{Status,VolumeMeasurementSamples,ImagingSamples,WeightMeasurementSamples}],
			Alternatives[
				{Alternatives[InCart,Canceled],{},{},{}},
				{Except[Alternatives[InCart,Canceled]],___}
			]
		],

		Test["If the maintenance has been completed, sample queue fields must be empty:",
			Lookup[packet,{Status,VolumeMeasurementSamples,ImagingSamples,WeightMeasurementSamples}],
			Alternatives[
				{Alternatives[Completed,Aborted],{},{},{}},
				{Except[Alternatives[Completed,Aborted]],___}
			]
		],
		
		Test["If the maintenance has been completed, Resources field must be empty:",
			Lookup[packet,{Status,Resources}],
			Alternatives[
				{Alternatives[Completed,Aborted],{}},
				{Except[Alternatives[Completed,Aborted]],___}
			]
		]
	}

];


(* ::Subsection::Closed:: *)
(*validMaintenanceAlignLiquidHandlerQTests*)


validMaintenanceAlignLiquidHandlerDevicePrecisionQTests[packet:PacketP[Object[Maintenance,AlignLiquidHandlerDevicePrecision]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,Target,Author,ChannelPositioningTool,ChannelCalibrationTool,Wrenches,CoverTool,FasteningScrewdriver,AdjustmentScrewdriver
		}
	]
};

(* ::Subsection::Closed:: *)
(*validMaintenanceTrainInternalRobotArmPositionQTests*)


validMaintenanceTrainInternalRobotArmPositionQTests[packet:PacketP[Object[Maintenance,TrainInternalRobotArm]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,Target,Author,LiquidHandler,TrainingPlate,TrainingPositions,MaintenanceKey,VerificationCode
		}
	],

	RequiredWhenCompleted[packet,{
		DateCompleted,HamiltonManipulationsFile,HamiltonDeckFiles,DataFile,CarrierPositionOffsets,
		LiquidHandlingLogs,DeckPlacements,InitializationStartTime
	}],

	(* when the protocol is completed, the number of entries to the CarrierPositionOffsets should be double of the ones in the TrainingPositions*)
	Test["For a completed maintenance, the correct number of corrections for the number of positions trained were generated:",
		If[
			MatchQ[Lookup[packet,Status],Completed],
			Length[Lookup[packet,TrainingPositions]] * 2==Length[Lookup[packet,CarrierPositionOffsets]],
			True
		],
		True
	]
};

(* ::Subsection::Closed:: *)
(*validMaintenanceTreatWasteQTests*)

validMaintenanceTreatWasteQTests[packet:PacketP[Object[Maintenance,TreatWaste]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,WashBin
		}
	],

	RequiredTogetherTest[packet,{Instrument,ContainersToBleach,BatchedTreatmentParameters,WasteBin}],

	RequiredTogetherTest[packet,{ContainersToSeal,AutoclaveTape}]
}

(* ::Subsection::Closed:: *)
(*validMaintenanceAutoclaveQTests*)


validMaintenanceAutoclaveQTests[packet:PacketP[Object[Maintenance,Autoclave]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,Target,Author,Autoclave,ContainersIn
		}
	]
};


(* ::Subsection::Closed:: *)
(*validMaintenanceCalibrateApertureTubeQTests*)


validMaintenanceCalibrateApertureTubeQTests[packet:PacketP[Object[Maintenance,CalibrateApertureTube]]]:={

	(* fields not null *)
	NotNullFieldTest[packet,
		{
			Model,
			Targets,
			Authors,
			ApertureTube,
			ElectrolyteSolution,
			SizeStandards,
			MeasurementContainers,
			SampleAmounts,
			ElectrolyteSampleDilutionVolumes,
			RinseContainer,
			Instrument
		}
	]
};


(* ::Subsection::Closed:: *)
(*validMaintenanceCalibrateAutosamplerQTests*)


validMaintenanceCalibrateAutosamplerQTests[packet:PacketP[Object[Maintenance,CalibrateAutosampler]]]:={

	(* fields not null *)
	NotNullFieldTest[packet,
		{
			Model,
			Target,
			Author,
			CalibrationContainer,
			CalibrationContainerCap
		}
	]
};


(* ::Subsection::Closed:: *)
(*validMaintenanceCalibrateBalanceQTests*)


validMaintenanceCalibrateBalanceQTests[packet:PacketP[Object[Maintenance,CalibrateBalance]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,
			Target
		}
	],
	(* If DateCompleted is informed, then these fields should also be informed *)
	RequiredWhenCompleted[packet,{DateCompleted, ValidationData,Calibrated,Validated}]

};


(* ::Subsection::Closed:: *)
(*validMaintenanceCalibratePathLengthQTests*)


validMaintenanceCalibratePathLengthQTests[packet:PacketP[Object[Maintenance,CalibratePathLength]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,
			Target,
			DateConfirmed,
			LiquidHandler,
			LiquidLevelDetector,
			NumberOfReplicates,
			Volumes,
			TargetBuffer,
			TargetContainers,
			EstimatedProgramTime,
			PipetteTips
		}
	]
};


(* ::Subsection::Closed:: *)
(*validMaintenanceCalibrateCarbonDioxideQTests*)


validMaintenanceCalibrateCarbonDioxideQTests[packet:PacketP[Object[Maintenance,CalibrateCarbonDioxide]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,
			Target
		}
	],
	(* If DateCompleted is informed, then these fields should also be informed *)
	RequiredTogetherTest[packet,{DateCompleted, CalibrationFitFunction}]

};


(* ::Subsection::Closed:: *)
(*validMaintenanceCalibrateGasSensorQTests*)


validMaintenanceCalibrateGasSensorQTests[packet:PacketP[Object[Maintenance,CalibrateGasSensor]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,
			Target
		}
	]

};


(* ::Subsection::Closed:: *)
(*validMaintenanceCalibrateLevelQTests*)


validMaintenanceCalibrateLevelQTests[packet:PacketP[Object[Maintenance,CalibrateLevel]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,
			Target
		}
	],
	(* If DateCompleted is informed, then these fields should also be informed *)
	RequiredTogetherTest[packet,{DateCompleted, CalibrationFitFunction}]

};


(* ::Subsection::Closed:: *)
(*validMaintenanceCalibrateLightScatteringQTests*)


validMaintenanceCalibrateLightScatteringQTests[packet:PacketP[Object[Maintenance,CalibrateLightScattering]]]:=

	(* For an Object[Maintenance,CalibrateLightScattering,Plate] we actually need fewer fields - so we'll do a conditional
	for that first *)
	If[MatchQ[packet,PacketP[Object[Maintenance,CalibrateLightScattering,Plate]]],
		{
			(* Fields filled in *)
			NotNullFieldTest[packet,
				{
					Model,
					Target,
					CalibrationStandard,
					AssayContainer
				}
			],

			RequiredWhenCompleted[packet,
				{
					AssayPlatePrimitives,
					AssayPlateManipulation,
					WellCover
				}
			]
		},

		(* If we're in the parent type Object[Maintenance,CalibrateLightScattering], we need more fields *)
		{
			(* Fields filled in *)
			NotNullFieldTest[packet,
				{
					Model,
					Target,
					CalibrationStandard,
					AssayContainers,
					CapillaryClips,
					CapillaryGaskets,
					CapillaryStripLoadingRack,
					SampleStageLid
				}
			],

			(* Fields that should be filled in after protocol is complete *)
			RequiredWhenCompleted[packet,
				{
					AssayPlatePrimitives,
					AssayPlateManipulation,
					ContainerPlacements,
					SampleFilePath,
					InstrumentDataFilePath,
					DataTransferFilePath,
					DataFilePath,
					DataFileName,
					CalibrationStandardIntensity
				}
			]
		}
	];


(* ::Subsection::Closed:: *)
(*validMaintenanceCalibrateNMRShimQTests*)


validMaintenanceCalibrateNMRShimQTests[packet:PacketP[Object[Maintenance,CalibrateNMRShim]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,
			Target,
			ShimmingStandard
		}
	],

	RequiredWhenCompleted[packet,
		{
			StickerSheet,
			UnrackedNMRTubeStickerPositions,
			UnrackedNMRTubePlacements,
			UnrackedNMRTubeLoadingPlacements
		}
	]

	(* Fields that should be filled in after protocol is complete *)

};


(* ::Subsection::Closed:: *)
(*validMaintenanceCalibrateMicroscopeQTests*)


validMaintenanceCalibrateMicroscopeQTests[packet:PacketP[Object[Maintenance,CalibrateMicroscope]]]:={
	NotNullFieldTest[packet,
		{
			Model,
			Target
		}
	]
};


(* ::Subsection::Closed:: *)
(*validMaintenanceCalibratepHQTests*)


validMaintenanceCalibratepHQTests[packet:PacketP[Object[Maintenance,CalibratepH]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,
			Target
		}
	],
	(* If DateCompleted is informed, then these fields should also be informed *)
	RequiredTogetherTest[packet,{DateCompleted, CalibrationFitFunction}]

};


(* ::Subsection::Closed:: *)
(*validMaintenanceCalibratePressureQTests*)


validMaintenanceCalibratePressureQTests[packet:PacketP[Object[Maintenance,CalibratePressure]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,
			Target
		}
	],
	(* If DateCompleted is informed, then these fields should also be informed *)
	RequiredTogetherTest[packet,{DateCompleted, CalibrationFitFunction}]

};


(* ::Subsection::Closed:: *)
(*validMaintenanceCalibrateRelativeHumidityQTests*)


validMaintenanceCalibrateRelativeHumidityQTests[packet:PacketP[Object[Maintenance,CalibrateRelativeHumidity]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,
			Target
		}
	],
	(* If DateCompleted is informed, then these fields should also be informed *)
	RequiredTogetherTest[packet,{DateCompleted, CalibrationFitFunction}]

};


(* ::Subsection::Closed:: *)
(*validMaintenanceCalibrateTemperatureQTests*)


validMaintenanceCalibrateTemperatureQTests[packet:PacketP[Object[Maintenance,CalibrateTemperature]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,
			Target
		}
	],
	(* If DateCompleted is informed, then these fields should also be informed *)
	RequiredTogetherTest[packet,{DateCompleted, CalibrationFitFunction}]

};


(* ::Subsection::Closed:: *)
(*validMaintenanceCalibrateConductivityQTests*)


validMaintenanceCalibrateConductivityQTests[packet:PacketP[Object[Maintenance,CalibrateConductivity]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,
			Target
		}
	],
	(* If DateCompleted is informed, then these fields should also be informed *)
	RequiredTogetherTest[packet,{DateCompleted, CalibrationFitFunction}]

};


(* ::Subsection::Closed:: *)
(*validMaintenanceCalibrateElectrochemicalReactorQTests*)


validMaintenanceCalibrateElectrochemicalReactorQTests[packet:PacketP[Object[Maintenance,CalibrateElectrochemicalReactor]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,
			Target,
			CalibrationCap,
			ReactionVesselHolder
		}
	]

};


(* ::Subsection::Closed:: *)
(*validMaintenanceCalibrateVolumeQTests*)


validMaintenanceCalibrateVolumeQTests[packet:PacketP[Object[Maintenance,CalibrateVolume]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,
			Target,
			DateConfirmed,
			Volumes,
			TargetContainers
		}
	],

	(* vessel required after compile *)
	RequiredTogetherTest[packet,{VolumeIncrements,BufferReceivingContainers}],
	
	(* If status is Completed, then VolumeCalibration should also be informed *)
	If[  
		MatchQ[Lookup[packet,Status], Completed], 
		NotNullFieldTest[packet, VolumeCalibration],
		Nothing
	],
	
	(* Do not check folowing if protocol is aborted: *)
	If[
	MatchQ[Lookup[packet,Status], Except[Aborted]]&& (Lookup[packet, DateEnqueued]> DateObject[{2019,1, 26}]), 
	{
	Test[
		"If a model of target is not a plate reader TargetBuffer field should be populated:",
		{ MemberQ[Alternatives["Deck Slot"], Lookup[packet,Target][AllowedPositions]], Lookup[packet,TargetBuffer]},
		Alternatives[{True,Except[{}]} , {False, {}}]
	],
	
	Test[
		"If Target[Model] is a plate reader TargetBuffer shoul not be populated:",
		{ MemberQ[Alternatives["Plate Slot"], Lookup[packet,Target][AllowedPositions]], Lookup[packet,TargetBuffer]},
		Alternatives[{True,{}}, {False, Except[{}]}]
	]
	},
	Nothing
	]
};


(* ::Subsection::Closed:: *)
(*validMaintenanceCalibrateWeightQTests*)


validMaintenanceCalibrateWeightQTests[packet:PacketP[Object[Maintenance,CalibrateWeight]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,
			Target
		}
	],
	(* If DateCompleted is informed, then these fields should also be informed *)
	RequiredTogetherTest[packet,{DateCompleted, CalibrationFitFunction}]

};


(* ::Subsection::Closed:: *)
(*validMaintenanceCleanQTests*)


validMaintenanceCleanQTests[packet:PacketP[Object[Maintenance,Clean]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,
			Target
		}
	]
};

(* ::Subsection::Closed:: *)
(*validMaintenanceCleanViscometerQTests*)


validMaintenanceCleanViscometerQTests[packet:PacketP[Object[Maintenance,Clean,Viscometer]]]:={
	
	NotNullFieldTest[packet,{
		PistonCleaningSolution,
		PistonCleaningWipes
	}]
	
};



(* ::Subsection::Closed:: *)
(*validMaintenanceCleanDispenserQTests*)


validMaintenanceCleanDSCQTests[packet:PacketP[Object[Maintenance,Clean,DifferentialScanningCalorimeter]]]:={
	
	(* Fields filled in *)
	NotNullFieldTest[packet,{
		Model,
		Target,
		CleaningSolutions
	}]
};






(* ::Subsection::Closed:: *)
(*validMaintenanceCleanDispenserQTests*)


validMaintenanceCleanDispenserQTests[packet:PacketP[Object[Maintenance,Clean,Dispenser]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,
			Target,
			GraduatedCylinders
		}
	],

	(*Fields that should be filled in after protocol is complete*)
	RequiredWhenCompleted[packet, {DirtyLabware}]
};


(* ::Subsection::Closed:: *)
(*validMaintenanceCleanFreezerQTests*)


validMaintenanceCleanFreezerQTests[packet:PacketP[Object[Maintenance, Clean, Freezer]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,
			Target
		}
	]
};



(* ::Subsection::Closed:: *)
(*validMaintenanceCleanESISourceQTests*)


validMaintenanceCleanESISourceQTests[packet:PacketP[Object[Maintenance, Clean, ESISource]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Target,
			Instruments
		}
	],
	Test["If the Model has a Cleaning Solvent, it must be informed in the object. Conversely, it must be Null if Null in the Model:",
		Download[Lookup[packet,Object],{CleaningSolvent,Model[CleaningSolventModel]}],
		Alternatives[
			{ObjectP[],ObjectP[]},
			{Null,Null}
		]
	]
};


(* ::Subsection::Closed:: *)
(*validMaintenanceCleanOperatorCartQTests*)


validMaintenanceCleanOperatorCartQTests[packet:PacketP[Object[Maintenance,Clean,OperatorCart]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			ReservoirRacks
		}
	],

	(* Ethanol, Acetone, Methanol and Isopropanol shouls all be informed *)
	RequiredTogetherTest[packet,{Ethanol,Acetone,Methanol,Isopropanol}]

};


(* ::Subsection::Closed:: *)
(*validMaintenanceCleanPeptideSynthesizerQTests*)


validMaintenanceCleanPeptideSynthesizerQTests[packet:PacketP[Object[Maintenance,Clean,PeptideSynthesizer]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			PrimaryWashSolvent,
			SecondaryWashSolvent,
			CleavageLineSolvent
		}
	]

};


(* ::Subsection::Closed:: *)
(*validMaintenanceCleanpHDetectorQTests*)


validMaintenanceCleanpHDetectorQTests[packet:PacketP[Object[Maintenance,Clean,pHDetector]]]:={
	(* Fields that should be filled in *)
	NotNullFieldTest[
		packet,
		{
			pHElectrodeWashSolvent,
			pHElectrodeRinseSolvent,
			pHElectrodeFillSolution
		}
	]
};



(* ::Subsection::Closed:: *)
(*validMaintenanceCleanPlateWasherQTests*)


validMaintenanceCleanPlateWasherQTests[packet:PacketP[Object[Maintenance,Clean,PlateWasher]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			MaintenanceKey,
			WashSolvent,
			BufferContainerPlacements,
			MaintenancePlate,
			VesselRackPlacements
		}
	]

};

(* ::Subsection::Closed:: *)
(*validMaintenanceHandwashQTests*)


validMaintenanceHandwashQTests[packet:PacketP[Object[Maintenance,Handwash]]]:=Module[
	{
		dirtyLabwareModels=Download[Lookup[packet,DirtyLabware],Model],
		carboyModels=Search[Model[Container,Vessel],CleaningMethod==Handwash&&(StringContainsQ[Name,"Carboy"]||StringContainsQ[Name,"carboy"])]
	},

	{

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,
			Target,
			DirtyLabware
		}
	],

	(* checks on fields being informed according to the item being handwashed *)
	Test[
		"If Dirty labware consists of Graduated Cylinder(s), then ThermoplasticWrap must be informed. Else it should be Null:",
		Lookup[packet,{DirtyLabware, ThermoplasticWrap}],
		Alternatives[
			{{ObjectP[Object[Container,GraduatedCylinder]]..},Except[NullP]},
			{{Except[ObjectP[Object[Container,GraduatedCylinder]]]..},NullP}
		]
	],
		Test[
		"If Dirty labware consists of carboy(s), then BottleRoller must be informed. Else it should be Null:",
		{dirtyLabwareModels,Lookup[packet,BottleRoller]},
		Alternatives[
			{{ObjectP[carboyModels]..},Except[NullP]},
			{{Except[ObjectP[carboyModels]]..},_}
		]
	],
	Test[
		"If Dirty labware consists of Graduated Cylinders/Vessels, then WaterPurifier must be informed. Else it should be Null:",
		Lookup[packet,{DirtyLabware, WaterPurifier}],
		Alternatives[
			{{ObjectP[{Object[Container,GraduatedCylinder], Object[Container,Vessel]}]..},Except[NullP]},
			{Except[{ObjectP[{Object[Container,GraduatedCylinder], Object[Container,Vessel]}]..}],NullP}
		]
	],

	(* ensure that instruments in maintenance, match modelInstruments specified in modelMaintenance *)
	Test[
		"When maintenance is complete, if WaterPurifier is informed then WaterPurifierModel in modelMaintenance is the model of WaterPurifier in maintenance:",
		{Lookup[packet,Status], If[MatchQ[Lookup[packet,WaterPurifier], ObjectP[Object[Instrument]]], SameObjectQ[Download[Lookup[packet, Model],WaterPurifierModel] , Download[Lookup[packet, WaterPurifier], Model]], True]},
		Alternatives[{Completed, True},{Except[Completed],_}]
	],
	Test[
		"When maintenance is complete, if BottleRoller is informed then BottleRollerModel in modelMaintenance is the model of BottleRoller in maintenance:",
		{Lookup[packet,Status], If[MatchQ[Lookup[packet,BottleRoller],ObjectP[Object[Instrument]]], SameObjectQ[Download[Lookup[packet, Model],BottleRollerModel] , Download[Lookup[packet, BottleRoller], Model]], True]},
		Alternatives[{Completed, True},{Except[Completed],_}]
	],
	Test[
		"When maintenance is complete, if ThermoplasticWrap is informed then ThermoplasticWrapModel in modelMaintenance is the model of ThermoplasticWrap in maintenance:",
		{Lookup[packet,Status], If[MatchQ[Lookup[packet,ThermoplasticWrap], ObjectP[Object[Sample]]], SameObjectQ[Download[Lookup[packet, Model],ThermoplasticWrapModel] , Download[Lookup[packet, ThermoplasticWrap], Model]], True]},
		Alternatives[{Completed, True},{Except[Completed],_}]
	],
	(* cleanlabware and dirtylabware length must be same at end *)
	Test[
		"When maintenance is complete, length of DirtyLabware matches Length of CleanLabware:",
		{Lookup[packet,Status], Length[Lookup[packet,DirtyLabware]] == Length[Lookup[packet,CleanLabware]]},
		Alternatives[{Completed, True},{Except[Completed],_}]
	],
	(* Resolved when completed *)
	ResolvedWhenCompleted[packet, {FumeHood}]
	}
];


(* ::Subsection::Closed:: *)
(*validMaintenanceDecontaminateQTests*)


validMaintenanceDecontaminateQTests[packet:PacketP[Object[Maintenance,Decontaminate]]]:= {

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,
			Target
		}
	]
};


(* ::Subsection::Closed:: *)
(*validMaintenanceDecontaminateLiquidHandlerQTests*)


validMaintenanceDecontaminateLiquidHandlerQTests[packet:PacketP[Object[Maintenance,Decontaminate,LiquidHandler]]]:={

	RequiredWhenCompleted[packet, {DeckRackPlacements, ReverseDeckRackPlacements}],

	(*Fields that should be filled in after protocol is complete*)
	Test[
		"ReversedeckRackPlacements should be the reverse list of DeckRackPlacements",
		AllTrue[
			MapThread[
				SameObjectQ[#1, #2] &,
				{
					Cases[Flatten[Lookup[packet, ReverseDeckRackPlacements]], ObjectP[]],
					Cases[Flatten[Reverse[Lookup[packet, DeckRackPlacements]]], ObjectP[]]
				}
			],
			TrueQ
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validMaintenanceDecontaminateIncubatorQTests*)


validMaintenanceDecontaminateIncubatorQTests[packet:PacketP[Object[Maintenance,Decontaminate,Incubator]]]:= {

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			(* shared field *)
			Model,
			Target
		}
	]
};


(* ::Subsection::Closed:: *)
(*validMaintenanceDefrostQTests*)


validMaintenanceDefrostQTests[packet:PacketP[Object[Maintenance,Defrost]]]:={

	NotNullFieldTest[packet,
		{
			Model,
			Target,
			AbsorbentMats
		}
	]
};


(* ::Subsection::Closed:: *)
(*validMaintenanceDishwashQTests*)


validMaintenanceDishwashQTests[packet:PacketP[Object[Maintenance,Dishwash]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Target
		}
	],

	(* Resolved when completed *)
	ResolvedWhenCompleted[packet, {Detergent, Neutralizer, Dishwasher}],

	(* Required when completed *)
	RequiredWhenCompleted[packet,{Model,DishwashMethod}],

	(* specific tests *)
	Test[
		"If DishwashMethod is DishwashIntensive or DishwashPlastic, then DirtyLabware cannot be Null:",
		Lookup[packet,{DishwashMethod, DirtyLabware}],
		Alternatives[{DishwashIntensive|DishwashPlastic, Except[{}]},{Except[DishwashIntensive|DishwashPlastic], _}]
	],
	Test[
		"If DishwashMethod is DishwashIntensive or DishwashPlastic, then ContainerPlacements cannot be Null or {}:",
		If[DateObject[List[2021,1,18,0,0,0.`],"Instant","Gregorian",-7.`]>Lookup[packet,DateConfirmed]>DateObject[List[2017,10,5,17,34,30.`],"Instant","Gregorian",-7.`],
			Lookup[packet,{DishwashMethod,ContainerPlacements}],
			True
		],
		{(DishwashIntensive|DishwashPlastic),Except[Null|{}]}|{DishwashPlateSeals,({}|Null)}|True
	],
	Test[
		"If DishwashMethod is DishwashIntensive or DishwashPlastic, then length of CleanLabware matches the Length of DirtyLabware and/or LoadedLabware at protocol completion:",
		{Lookup[packet, Status], Lookup[packet, DishwashMethod], (Length[Lookup[packet,DirtyLabware]] == Length[Lookup[packet, CleanLabware]]||Length[Lookup[packet,LoadedLabware]] == Length[Lookup[packet, CleanLabware]])},
		Alternatives[{Completed, DishwashIntensive|DishwashPlastic, True},{Completed, Except[DishwashIntensive|DishwashPlastic],_},{Except[Completed],_,_}]
	],
	Test[
		"When using the Lancer Dishwasher, the RackPlacements Field should be informed:",
		{StringMatchQ[
			(* get the dishwasher fields Model Name, could be an object or model depending on if the maintenance has passed the compile step *)
			If[MatchQ[Lookup[packet,Dishwasher],LinkP[Model[Instrument,Dishwasher]]],
				Download[Lookup[packet,Dishwasher],Name],
				Download[Lookup[packet,Dishwasher],Model[Name]]
			],
			"1600 LXP Ultima"
		],Flatten[Lookup[packet,{RackPlacements,DishwasherRacks}]]},
		Alternatives[
			{True,Except[(Null|{})]},
			{False,_}
		]
	]
};



(* ::Subsection::Closed:: *)
(*validMaintenanceFlushQTests*)


validMaintenanceFlushQTests[packet:PacketP[Object[Maintenance,Flush]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,
			Target
		}
	]

};



(* ::Subsection::Closed:: *)
(*validMaintenanceEmptyWasteQTests*)


validMaintenanceEmptyWasteQTests[packet:PacketP[Object[Maintenance,EmptyWaste]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,
			Target,
			WasteType,
			CheckedWasteBins
		}
	],

	(*Fields that should be filled in after protocol is complete*)
	RequiredWhenCompleted[packet, {FullWasteBins}],

	Test[
		"If there is a true in FullWasteBins, then there should be at least one emptied waste bin:",
		{MemberQ[Lookup[packet, FullWasteBins],True],Lookup[packet, Status],Lookup[packet,EmptiedWasteBins]},
		{True,Completed,{ObjectP[Object[Container]]..}}|{False,Completed,{}}|{_,Except[Completed],_}
	]
};



(* ::Subsection::Closed:: *)
(*validMaintenanceReplaceQTests*)


validMaintenanceReplaceQTests[packet:PacketP[Object[Maintenance,Replace]]]:={

	(* Fields filled in *)
	NotNullFieldTest[
		packet,
		{
			Model,
			Target,
			ReplacementParts
		}
	]
};



(* ::Subsection::Closed:: *)
(*validMaintenanceReplaceBufferCartridgeQTests*)


validMaintenanceReplaceBufferCartridgeQTests[packet:PacketP[Object[Maintenance,Replace,BufferCartridge]]]:={

	(* Fields filled in *)
	NotNullFieldTest[
		packet,
		{
			BufferCartridgeSepta,
			PartsLocations
		}
	]
};


(* ::Subsection::Closed:: *)
(*validMaintenanceReplaceFilterQTests*)


validMaintenanceReplaceFilterQTests[packet:PacketP[Object[Maintenance,Replace,Filter]]]:={

	RequiredTogetherTest[packet,{FilterActivationLiquid, ActivationLiquidContainer}]

};



(* ::Subsection::Closed:: *)
(*validMaintenanceReplaceLampQTests*)


validMaintenanceReplaceLampQTests[packet:PacketP[Object[Maintenance,Replace,Lamp]]]:={

};


(* ::Subsection::Closed:: *)
(*validMaintenanceInstallGasCylinderQTests*)


validMaintenanceInstallGasCylinderQTests[packet:PacketP[Object[Maintenance,InstallGasCylinder]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,
			Target
		}
	],

	(*Fields that should be filled in after protocol is complete*)
	RequiredWhenCompleted[packet, {ReplacementGasSample, GasSamplePlacements}]
};



(* ::Subsection::Closed:: *)
(*validMaintenanceLubricateQTests*)


validMaintenanceLubricateQTests[packet:PacketP[Object[Maintenance,Lubricate]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,
			Target,
			LabArea,
			Lubricant
		}
	]
};


(* ::Subsection::Closed:: *)
(*validMaintenanceRefillReservoirQTests*)


validMaintenanceRefillReservoirQTests[packet:PacketP[Object[Maintenance,RefillReservoir]]]:={

	(* Fields filled in *)
	If[!MatchQ[Lookup[packet,Type], Alternatives@@{Object[Maintenance,RefillReservoir,NMR],Object[Maintenance,RefillReservoir,HPLC],Object[Maintenance,RefillReservoir,pHMeter],Object[Maintenance,RefillReservoir,FPLC]}],
		NotNullFieldTest[packet,
			{
				Model,
				Target,
				FillLiquid,
				FillLiquidContainer,
				ReservoirContainer
			}
		],
		{}
	],

	(* required when completed *)
	If[!MatchQ[Lookup[packet,Type], Alternatives[Object[Maintenance,RefillReservoir,NMR], Object[Maintenance,RefillReservoir,FPLC]]] && !MatchQ[Lookup[packet,RefillRequired], False],
		RequiredWhenCompleted[packet, {LiquidWaste}],
		{}
	]
};


(* ::Subsection::Closed:: *)
(*validMaintenanceRefillReservoirHPLCQTests*)


validMaintenanceRefillReservoirHPLCQTests[packet:PacketP[Object[Maintenance,RefillReservoir, HPLC]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,
			Target,
			Author,
			FillLiquid,
			ReservoirContainer
		}
	],
	
	(* required when completed *)
	RequiredWhenCompleted[packet, 
		{
			FillLiquidContainer,
			BufferPlacements,
			ReservoirDeck
		}
	]
};



(* ::Subsection::Closed:: *)
(*validMaintenanceRefillReservoirNMRQTests*)


validMaintenanceRefillReservoirNMRQTests[packet:PacketP[Object[Maintenance,RefillReservoir, NMR]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,
			Target,
			Author,
			ReservoirContainer,
			HeatGun,
			FaceShield,
			CryoGlove
		}
	],

	(* required when completed *)
	RequiredWhenCompleted[packet,
		{
			FillLiquidContainer,
			FillLiquid,
			HeatSinkExhaustPlacement,
			HeatSinkFillPlacement
		}
	]
};



(* ::Subsection::Closed:: *)
(*validMaintenanceRefillReservoirpHMeterQTests*)


validMaintenanceRefillReservoirpHMeterQTests[packet:PacketP[Object[Maintenance,RefillReservoir, pHMeter]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,
			Target,
			Author,
			ReservoirContainers
		}
	]
};



(* ::Subsection:: *)
(*validMaintenanceRebuildQTests*)


validMaintenanceRebuildQTests[packet:PacketP[Object[Maintenance,Rebuild]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,
			Target
		}
	]

};



(* ::Subsection::Closed:: *)
(*validMaintenanceRebuildPumpQTests*)


validMaintenanceRebuildPumpQTests[packet:PacketP[Object[Maintenance,Rebuild,Pump]]]:={

	(* Fields filled in *)
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
(*validMaintenanceParameterizeContainerQTests*)


validMaintenanceParameterizeContainerQTests[packet:PacketP[Object[Maintenance,ParameterizeContainer]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,
			Containers
		}
	],
	
	Test["If Parameterize Container Maintenance is not aborted, then ParameterizationModels should be uploaded:",
		Lookup[packet, {Status,ParameterizationModels}],
		Alternatives[
			{Aborted,_},
			{Except[Aborted],{ObjectP[{Model[Container, Vessel],Model[Container, Plate]}]..}}
		]
	]

};



(* ::Subsection::Closed:: *)
(*validMaintenanceReceiveInventoryQTests*)


validMaintenanceReceiveInventoryQTests[packet:PacketP[Object[Maintenance, ReceiveInventory]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Orders,
			QuantityReceived,
			SamplesPerItem
		}
	],

	Test[
		"If Containers is not informed, then WeightMeasuredSamples and TransferSamples must also not be informed (unless the protocol was aborted):",
		If[MatchQ[Lookup[packet, Containers], {}] && Not[MatchQ[Lookup[packet, Status], Aborted]],
			If[MemberQ[
					Lookup[packet,{WeightMeasuredSamples,TransferSamples}],
					{ObjectP[]..}
				],
				False,
				True
			],
			True
		],
		True
	],
	(* Fields that should be filled in after a protocol is complete *)
	Test["If maintenance is Completed, then ReceiveInventoryPrograms should be populated if at least one Order/DropShipping transaction was received:",
		If[MatchQ[Lookup[packet, Status], Completed] && MemberQ[Lookup[packet, Orders], ObjectP[{Object[Transaction, Order], Object[Transaction, DropShipping]}]] && MatchQ[Lookup[packet, ReceiveInventoryPrograms], {}],
			False,
			True
		],
		True
	],

	Test[
		"If maintenance is not Canceled or Aborted and at least one Order or DropShipping transaction was received, Items should be informed:",
		If[MatchQ[Lookup[packet, Status], Except[Canceled | Aborted]] && MemberQ[Lookup[packet, Orders], ObjectP[{Object[Transaction, Order], Object[Transaction, DropShipping]}]] && MatchQ[Lookup[packet, Items], {}],
			False,
			True
		],
		True
	]
};



(* ::Subsection:: *)
(*validMaintenanceReceivePackageQTests*)


validMaintenanceReceivePackageQTests[packet:PacketP[Object[Maintenance, ReceivePackage]]]:={
	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Target
		}
	]
};



(* ::Subsection::Closed:: *)
(*validMaintenanceStorageUpdateQTests*)


validMaintenanceStorageUpdateQTests[packet:PacketP[Object[Maintenance,StorageUpdate]]]:={

	
	Test["ScheduledMoves should be uploaded unless protocol is canceled or aborted:",
		Lookup[packet, {Status,ScheduledMoves}],
		Alternatives[
			{(Aborted|Canceled),_},
			{Except[Aborted|Canceled],{ObjectP[]..}}
		]
	],

	(* either model and target or both required or neither *)
	RequiredTogetherTest[packet, {Model, Target}]
};


(* ::Subsection::Closed:: *)
(*validMaintenanceShippingQTests*)


validMaintenanceShippingQTests[packet:PacketP[Object[Maintenance,Shipping]]]:={

(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,Author,Transactions, SamplesIn, ShippingContainers
		}
	],

	Module[{allFields,fieldsToResolve},
		allFields={ShippingContainers, SecondaryContainers, PlateSeals, Ice, PeanutsDispenser, DryIceDispenser};
		fieldsToResolve=PickList[{ShippingContainers, SecondaryContainers, PlateSeals, Ice, PeanutsDispenser, DryIceDispenser}, Lookup[packet, {ShippingContainers, SecondaryContainers, PlateSeals, Ice, PeanutsDispenser, DryIceDispenser}], Except[Null | {}]];
		ResolvedWhenCompleted[packet, fieldsToResolve]

	],

	RequiredWhenCompleted[packet, {SamplePlacements,SamplesOut}],


	Test["If Aliquot is True for any of the transactions and Status is Completed, SamplePreparationProtocols is populated",
		If[MatchQ[Lookup[packet,Status],Completed]&&MemberQ[Download[Lookup[packet,Transactions],Aliquot],True],
			Lookup[packet,SamplePreparationProtocols]
		],
		{ObjectP[Object[Protocol]]..}|Null
	],

	Test["If ColdPacking is DryIce for any of the transactions and Status is Completed, DryIce is populated",
		If[MatchQ[Lookup[packet,Status],Completed]&&MemberQ[Download[Lookup[packet,Transactions],ColdPacking],DryIce],
			Lookup[packet,DryIce]
		],
		{ObjectP[]}|Null
	],

	Test["If ColdPacking is None for any of the transactions and Status is Completed, Padding is populated",
		If[MatchQ[Lookup[packet,Status],Completed]&&MemberQ[Download[Lookup[packet,Transactions],ColdPacking],Null|None],
			Lookup[packet,Padding]
		],
		{ObjectP[]}|Null
	],

	Test["If any of the transactions are shipping samples, SecondaryContainers is populated otherwise it is Null:",
		{MemberQ[Flatten[Download[Lookup[packet, Transactions], SamplesIn[Object]]], NonSelfContainedSampleP], Lookup[packet,SecondaryContainers]},
		{False,{}}|{True,{ObjectP[{Object[Container,Bag],Model[Container,Bag]}]...}}
	],

	Test["If ColdPacking is Ice for any of the transactions, Ice is populated otherwise it is Null:",
		{MemberQ[Download[Lookup[packet,Transactions],ColdPacking],Ice], Lookup[packet,Ice]},
		{False,{}}|{True,{ObjectP[]...}}
	],

	Test["If ColdPacking is DryIce for any of the transactions, DryIceDispenser is populated otherwise it is Null:",
		{MemberQ[Download[Lookup[packet,Transactions],ColdPacking],DryIce], Lookup[packet,DryIceDispenser]},
		{False,Null}|{True,ObjectP[{Object[Instrument],Model[Instrument]}]}
	],

	Test["If ColdPacking is None for any of the transactions, PeanutsDispenser is populated otherwise it is Null:",
		{MemberQ[Download[Lookup[packet,Transactions],ColdPacking],Null|None], Lookup[packet,PeanutsDispenser]},
		{False,Null}|{True,ObjectP[{Object[Instrument],Model[Instrument]}]}
	]


};



(* ::Subsection::Closed:: *)
(*validMaintenanceReplaceVacuumPumpQTests*)


validMaintenanceReplaceVacuumPumpQTests[packet:PacketP[Object[Maintenance,Replace,VacuumPump]]]:={
	NotNullFieldTest[packet,{
		Target,
		HPLCStackTool,
		HPLCStackToolBit,
		HPLCDegasserTool,
		HPLCVacuumPumpTool
	}]
};

(* ::Subsection::Closed:: *)
(*validMaintenanceReplaceWasteContainerQTests*)


validMaintenanceReplaceWasteContainerQTests[packet : PacketP[Object[Maintenance, Replace, WasteContainer]]] := {
	NotNullFieldTest[packet, {
		Target,
		CheckedWasteContainers,
		PercentFull,
		WasteType,
		ReplacementContainerModel,
		WasteLabel,
		WasteModel,
		WasteContainerModel,
		MaxWasteAccumulationTime,
		LongAccumulatedWaste,
		EmptiedContainerCabinet,
		FullContainerCabinets,
		Funnel,
		HazardousWasteLabel,
		Printer,
		WasteRoomSuppliesCabinet,
		RinsateWasteContainer
	}],
	RequiredWhenCompleted[packet, ReplaceWasteContainersQ],
	If[
		MemberQ[Lookup[packet, ReplaceWasteContainersQ], True],
		NotNullFieldTest[packet, {
			ReplacedWasteContainers,
			PickedSamplePlacements,
			AccumulationStartDate,
			WasteLabelFilePaths
		}],
		Nothing
	]
};


(* ::Subsection::Closed:: *)
(*validMaintenanceReplaceGasFilterQTests*)


validMaintenanceReplaceGasFilterQTests[packet:PacketP[Object[Maintenance,Replace,GasFilter]]]:={
	NotNullFieldTest[packet,{
		Target,
		GasFilter
	}]
};


(* ::Subsection::Closed:: *)
(*validMaintenanceReplaceSensorQTests*)


validMaintenanceReplaceSensorQTests[packet:PacketP[Object[Maintenance,Replace,Sensor]]]:={
	NotNullFieldTest[packet,{
		Target,
		FeedPressureSensor,
		RetentatePressureSensor,
		PermeatePressureSensor,
		RetentateConductivitySensor,
		PermeateConductivitySensor
	}]
};



(* ::Subsection::Closed:: *)
(*validMaintenanceCalibrateLLDQTests*)


validMaintenanceCalibrateLLDQTests[packet:PacketP[Object[Maintenance,CalibrateLLD]]]:={
	NotNullFieldTest[packet,{
		Target,
		Distances
	}]
};



(* ::Subsection::Closed:: *)
(*validMaintenanceCalibrateMeltingPointApparatusQTests*)


validMaintenanceCalibrateMeltingPointApparatusQTests[packet:PacketP[Object[Maintenance,CalibrateMeltingPointApparatus]]]:={
	NotNullFieldTest[packet,{
		Target,
		MeltingPointStandards,
		AdjustmentMethod,
		Desiccate,
		Grind
	}],

	Test[
		"DesiccationMethod is Null if Desiccate is False; or DesiccationMethod is informed if Desiccate is True.",
		Which[
			MatchQ[Lookup[packet, Desiccate], False],
				NullQ[Lookup[packet, DesiccationMethod]],
			MatchQ[Lookup[packet, Desiccate], True],
				!NullQ[Lookup[packet, DesiccationMethod]],
			True,
				False
		],
		True
	]
};



(* ::Subsection::Closed:: *)
(*validMaintenanceRefillReservoirFPLCQTests*)


validMaintenanceRefillReservoirFPLCQTests[packet:PacketP[Object[Maintenance,RefillReservoir, FPLC]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,
			Target,
			Author,
			FillLiquid,
			ReservoirContainers,
			FillVolumes,
			PumpSealWashContainers,
			PurgeSyringe,
			PurgeWasteContainer
		}
	]
};

(* ::Subsection::Closed:: *)
(*validMaintenanceUpdateLiquidHandlerDeckAccuracyQTests*)


validMaintenanceUpdateLiquidHandlerDeckAccuracyQTests[packet:PacketP[Object[Maintenance,UpdateLiquidHandlerDeckAccuracy]]]:={
	NotNullFieldTest[packet,{
		Target,
		Model,
		Qualification
	}]
};




(* ::Subsection::Closed:: *)
(*validMaintenanceCalibrateDNASynthesizerQTests*)


validMaintenanceCalibrateDNASynthesizerQTests[packet:PacketP[Object[Maintenance,CalibrateDNASynthesizer]]]:={

	(*Fields that should be filled in after protocol is complete*)
	RequiredWhenCompleted[packet, {Dispenses, CalibrationWeightData, CalibrationScriptPath, CalibrationFilePath, RSquaredValues, Intercepts, Slopes, TaredWeights}],

	Test[
		"Dispenses does not contain duplicates:",
		DuplicateFreeQ[Lookup[packet,Dispenses]],
		True
	],

	(* RSquaredValues, Intercepts, Slopes are same length as Valves *)


	Test["The length of RSquaredValues matches the length of Valves:",
		If[!MatchQ[Lookup[packet,RSquaredValues], {}],
			Length[Lookup[packet,RSquaredValues]] == Length[Lookup[packet,Model][Valves]],
			True
		],
		True
	],
	Test["The length of Intercepts matches the length of Valves:",
		If[!MatchQ[Lookup[packet,Intercepts], {}],
			Length[Lookup[packet,Intercepts]] == Length[Lookup[packet,Model][Valves]],
			True
		],
		True
	],
	Test["The length of Slopes matches the length of Valves:",
		If[!MatchQ[Lookup[packet,Slopes], {}],
			Length[Lookup[packet,Slopes]] == Length[Lookup[packet,Model][Valves]],
			True
		],
		True
	]
};

(* ::Subsection:: *)
(*validMaintenanceAuditGasCylindersQTests*)


validMaintenanceAuditGasCylindersQTests[packet:PacketP[Object[Maintenance, AuditGasCylinders]]]:={
	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Target,
			Positions,
			EmptyTankPosition
		}
	],
	RequiredTogetherTest[packet,
		{
			AmbiguousTanks,
			AmbiguousTankPositions
		}
	],
	If[!NullQ[AmbiguousTanks],
		RequiredWhenCompleted[ClarifiedTankPositions]
	]
};



(* ::Subsection:: *)
(*Test Registration *)


registerValidQTestFunction[Object[Maintenance], validMaintenanceQTests];
registerValidQTestFunction[Object[Maintenance,AlignLiquidHandlerDevicePrecision],validMaintenanceAlignLiquidHandlerDevicePrecisionQTests];
registerValidQTestFunction[Object[Maintenance, Autoclave], validMaintenanceAutoclaveQTests];
registerValidQTestFunction[Object[Maintenance, CalibrateApertureTube], validMaintenanceCalibrateApertureTubeQTests];
registerValidQTestFunction[Object[Maintenance, CalibrateAutosampler], validMaintenanceCalibrateAutosamplerQTests];
registerValidQTestFunction[Object[Maintenance, CalibrateCarbonDioxide], validMaintenanceCalibrateCarbonDioxideQTests];
registerValidQTestFunction[Object[Maintenance, CalibrateBalance], validMaintenanceCalibrateBalanceQTests];
registerValidQTestFunction[Object[Maintenance, CalibrateConductivity], validMaintenanceCalibrateConductivityQTests];
registerValidQTestFunction[Object[Maintenance, CalibrateDNASynthesizer],validMaintenanceCalibrateDNASynthesizerQTests];
registerValidQTestFunction[Object[Maintenance, CalibrateElectrochemicalReactor], validMaintenanceCalibrateElectrochemicalReactorQTests];
registerValidQTestFunction[Object[Maintenance, CalibrateGasSensor], validMaintenanceCalibrateGasSensorQTests];
registerValidQTestFunction[Object[Maintenance, CalibrateLevel], validMaintenanceCalibrateLevelQTests];
registerValidQTestFunction[Object[Maintenance, CalibrateLightScattering], validMaintenanceCalibrateLightScatteringQTests];
registerValidQTestFunction[Object[Maintenance, CalibrateLLD], validMaintenanceCalibrateLLDQTests];
registerValidQTestFunction[Object[Maintenance, CalibrateMeltingPointApparatus], validMaintenanceCalibrateMeltingPointApparatusQTests];
registerValidQTestFunction[Object[Maintenance, CalibrateNMRShim], validMaintenanceCalibrateNMRShimQTests];
registerValidQTestFunction[Object[Maintenance, CalibrateMicroscope], validMaintenanceCalibrateMicroscopeQTests];
registerValidQTestFunction[Object[Maintenance, CalibratePathLength], validMaintenanceCalibratePathLengthQTests];
registerValidQTestFunction[Object[Maintenance, CalibratepH], validMaintenanceCalibratepHQTests];
registerValidQTestFunction[Object[Maintenance, CalibratePressure], validMaintenanceCalibratePressureQTests];
registerValidQTestFunction[Object[Maintenance, CalibrateRelativeHumidity], validMaintenanceCalibrateRelativeHumidityQTests];
registerValidQTestFunction[Object[Maintenance, CalibrateTemperature], validMaintenanceCalibrateTemperatureQTests];
registerValidQTestFunction[Object[Maintenance, CalibrateVolume], validMaintenanceCalibrateVolumeQTests];
registerValidQTestFunction[Object[Maintenance, CalibrateWeight], validMaintenanceCalibrateWeightQTests];
registerValidQTestFunction[Object[Maintenance, Clean], validMaintenanceCleanQTests];
registerValidQTestFunction[Object[Maintenance, Clean,Viscometer], validMaintenanceCleanViscometerQTests];
registerValidQTestFunction[Object[Maintenance, Clean, DifferentialScanningCalorimeter],validMaintenanceCleanDSCQTests];
registerValidQTestFunction[Object[Maintenance, Clean, Dispenser],validMaintenanceCleanDispenserQTests];
registerValidQTestFunction[Object[Maintenance, Clean, ESISource],validMaintenanceCleanESISourceQTests];
registerValidQTestFunction[Object[Maintenance, Clean, Freezer],validMaintenanceCleanFreezerQTests];
registerValidQTestFunction[Object[Maintenance, Clean,OperatorCart],validMaintenanceCleanOperatorCartQTests];
registerValidQTestFunction[Object[Maintenance, Clean,PeptideSynthesizer], validMaintenanceCleanPeptideSynthesizerQTests];
registerValidQTestFunction[Object[Maintenance, Clean,pHDetector], validMaintenanceCleanpHDetectorQTests];
registerValidQTestFunction[Object[Maintenance, Clean,PlateWasher], validMaintenanceCleanPlateWasherQTests];
registerValidQTestFunction[Object[Maintenance, Decontaminate], validMaintenanceDecontaminateQTests];
registerValidQTestFunction[Object[Maintenance, Decontaminate,Incubator], validMaintenanceDecontaminateIncubatorQTests];
registerValidQTestFunction[Object[Maintenance, Decontaminate,LiquidHandler], validMaintenanceDecontaminateLiquidHandlerQTests];
registerValidQTestFunction[Object[Maintenance, Defrost], validMaintenanceDefrostQTests];
registerValidQTestFunction[Object[Maintenance, Dishwash], validMaintenanceDishwashQTests];
registerValidQTestFunction[Object[Maintenance, Flush], validMaintenanceFlushQTests];
registerValidQTestFunction[Object[Maintenance, EmptyWaste], validMaintenanceEmptyWasteQTests];
registerValidQTestFunction[Object[Maintenance, Handwash], validMaintenanceHandwashQTests];
registerValidQTestFunction[Object[Maintenance, ParameterizeContainer],validMaintenanceParameterizeContainerQTests];
registerValidQTestFunction[Object[Maintenance, InstallGasCylinder], validMaintenanceInstallGasCylinderQTests];
registerValidQTestFunction[Object[Maintenance, Lubricate], validMaintenanceLubricateQTests];
registerValidQTestFunction[Object[Maintenance, ReceiveInventory], validMaintenanceReceiveInventoryQTests];
registerValidQTestFunction[Object[Maintenance, ReceivePackage], validMaintenanceReceivePackageQTests];
registerValidQTestFunction[Object[Maintenance, RefillReservoir],validMaintenanceRefillReservoirQTests];
registerValidQTestFunction[Object[Maintenance, RefillReservoir, FPLC],validMaintenanceRefillReservoirFPLCQTests];
registerValidQTestFunction[Object[Maintenance, RefillReservoir, HPLC],validMaintenanceRefillReservoirHPLCQTests];
registerValidQTestFunction[Object[Maintenance, RefillReservoir, NMR],validMaintenanceRefillReservoirNMRQTests];
registerValidQTestFunction[Object[Maintenance, RefillReservoir, pHMeter],validMaintenanceRefillReservoirpHMeterQTests];
registerValidQTestFunction[Object[Maintenance, Rebuild],validMaintenanceRebuildQTests];
registerValidQTestFunction[Object[Maintenance, Rebuild, Pump],validMaintenanceRebuildPumpQTests];
registerValidQTestFunction[Object[Maintenance, Replace],validMaintenanceReplaceQTests];
registerValidQTestFunction[Object[Maintenance, Replace, BufferCartridge],validMaintenanceReplaceBufferCartridgeQTests];
registerValidQTestFunction[Object[Maintenance, Replace, Filter],validMaintenanceReplaceFilterQTests];
registerValidQTestFunction[Object[Maintenance, Replace, Lamp],validMaintenanceReplaceLampQTests];
registerValidQTestFunction[Object[Maintenance, Replace, GasFilter],validMaintenanceReplaceGasFilterQTests];
registerValidQTestFunction[Object[Maintenance, Replace, Sensor],validMaintenanceReplaceSensorQTests];
registerValidQTestFunction[Object[Maintenance, Replace, VacuumPump],validMaintenanceReplaceVacuumPumpQTests];
registerValidQTestFunction[Object[Maintenance, Replace, WasteContainer],validMaintenanceReplaceWasteContainerQTests];
registerValidQTestFunction[Object[Maintenance, StorageUpdate],validMaintenanceStorageUpdateQTests];
registerValidQTestFunction[Object[Maintenance, Shipping],validMaintenanceShippingQTests];
registerValidQTestFunction[Object[Maintenance, TrainInternalRobotArm], validMaintenanceTrainInternalRobotArmPositionQTests];
registerValidQTestFunction[Object[Maintenance, TreatWaste],validMaintenanceTreatWasteQTests];
registerValidQTestFunction[Object[Maintenance, UpdateLiquidHandlerDeckAccuracy],validMaintenanceUpdateLiquidHandlerDeckAccuracyQTests];

(*End*)
(* End Private Context *)
