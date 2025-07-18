(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(*Source Code*)


(* ::Subsection::Closed:: *)
(*validQualificationQTests*)


validQualificationQTests[packet:PacketP[Object[Qualification]]]:= Module[
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
		NotNullFieldTest[packet,{Status,Target,Model}],

	(* Linked objects *)
		ObjectTypeTest[packet, Model],

	(* qualification doesn't use InCart *)
		Test[
			"Status is not InCart:",
			Lookup[packet, Status],
			Except[InCart]
		],

	(* DATES *)
		Test["DateConfirmed should be entered when the qualification has been confirmed to run in the lab but has not yet entered the processing queue:",
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

		Test["DateEnqueued should be entered when the qualification has been confirmed to run in the lab and has entered the processing queue:",
			Flatten[{Lookup[packet, Status], ContainsAny[Lookup[packet, StatusLog][[All, 2]], {OperatorStart}], Lookup[packet,{OperationStatus,DateEnqueued}]}],
			Alternatives[
				{InCart,_,_,Null},
				(* if protocol is Backlogged and has been started (i.e., it was sent into ShippingMaterials and then sent back), DateEnqueued can still be populated *)
				{Backlogged,True,_, _},
				(* if protocol is Backlogged and has not been started, DateEnqueued should not be populated *)
				{Backlogged,False,_, Null},
				(* If the protocol was canceled from Processing, the only status in its log can be InCart/OperatorStart/Backlogged/ShippingMaterials *)
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

		Test["DateStarted should be entered when the qualification has been started in the lab:",
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

		Test["DateCanceled should be entered when a qualification has been canceled:",
			Lookup[packet, {Status,DateCanceled}],
			Alternatives[
				{Canceled,Except[Null]},
				{Except[Canceled],Null}
			]
		],

		Test["DateCompleted should be entered when a qualification has finished running or been aborted:",
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
			"If the qualification is Status->ScientificSupport, its parent protocol must be Status->ScientificSupport as well:",
			{Lookup[packet, ParentProtocol], parentProtocolOperationStatus, Lookup[packet, OperationStatus]},
			{ObjectP[], ScientificSupport, ScientificSupport} | {NullP, NullP, ScientificSupport} | {_, _, Except[ScientificSupport]}
		],

		Test[
			"If the qualification has a ParentProtocol and the ParentProtocol is finished (Status-> Canceled, Completed, or Aborted), this qualification must also be finished (Status-> Canceled, Completed, or Aborted):",
			{parentProtocolStatus, Lookup[packet, Status]},
			{Canceled | Completed | Aborted, Canceled | Completed | Aborted} | {Except[Canceled | Completed | Aborted], _}
		],

		Test[
			"If the qualification has a ParentProtocol and the ParentProtocol is not started (Status-> InCart), this qualification must also be not started (Status-> InCart or Canceled):",
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
			"If the qualification has not been started, the following fields must be Null: Data, Figures, and ScientificSupport Reports:",
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
			"If the qualification Status is Processing, then OperationStatus is OperatorProcessing, InstrumentProcessing, ScientificSupport, or OperatorReady. If the qualification Status is not running, OperationStatus must be Null or None:",
			Lookup[packet,{Status,OperationStatus}],
			Alternatives[
				{Processing,OperatorStart|OperatorProcessing|InstrumentProcessing|OperatorReady|ScientificSupport},
				{Except[Processing],NullP|None}
			]
		],

	(* ScientificSupport *)
	Test["ScientificSupport fields are not populated if a qualification is not currently executing or it has been started but is ShippingMaterials:",
		(* If the protocol is Processing or has started and is ShippingMaterials, it may have CartResources populated,
		otherwise it should be empty *)
		If[
			Or[
				MatchQ[Lookup[packet,Status],Processing],
				And[
					MemberQ[Lookup[packet, StatusLog][[All, 2]], OperatorStart],
					MatchQ[Lookup[packet,Status],ShippingMaterials]
				]
			],
			True,
			MatchQ[Lookup[packet,{CartResources,CartInstruments}],{{},{}}]
		],
		True
	],

	(* INSTRUMENTS *)
		Test[
			"If the qualification has not been started, Resources, and CurrentInstruments must be Null:",
			Lookup[packet, {Status, Resources, CurrentInstruments}],
			Alternatives[
				{Alternatives[InCart, Canceled], {}, {}},
				{Except[Alternatives[InCart, Canceled]], ___, ___}
			]
		],

		Test["If the qualification has been completed Resources and CurrentInstruments must be empty:",
			Lookup[packet, {Status,Resources,CurrentInstruments}],
			Alternatives[
				{Alternatives[Completed,Aborted],{},{}},
				{Except[Alternatives[Completed,Aborted]],___}
			]
		],

	(* QUEUED SAMPLES *)
		Test["If the qualification has not been started, sample queue fields must be empty:",
			Lookup[packet,{Status,VolumeMeasurementSamples,ImagingSamples,WeightMeasurementSamples}],
			Alternatives[
				{Alternatives[InCart,Canceled],{},{},{}},
				{Except[Alternatives[InCart,Canceled]],___}
			]
		],

		Test["If the qualification has been completed, sample queue fields must be empty:",
			Lookup[packet,{Status,VolumeMeasurementSamples,ImagingSamples,WeightMeasurementSamples}],
			Alternatives[
				{Alternatives[Completed,Aborted],{},{},{}},
				{Except[Alternatives[Completed,Aborted]],___}
			]
		]
	}

];


(* ::Subsection::Closed:: *)
(*validQualificationAcousticLiquidHandlerQTests*)


validQualificationAcousticLiquidHandlerQTests[packet:PacketP[Object[Qualification,AcousticLiquidHandler]]]:= {

};


(* ::Subsection::Closed:: *)
(*validQualificationAutoclaveQTests*)


validQualificationAutoclaveQTests[packet:PacketP[Object[Qualification,Autoclave]]]:={
	(* Fields filled in all the time from moment of creation*)
	NotNullFieldTest[packet,
		{
			AutoclaveProgram,
			IndicatorReader,
			Vortex,
			BioHazardBag,
			Indicator,
			ControlIndicator,
			AutoclaveTape,
			IncubationTime
		}
	],

	(* results should be informed when qualification is done *)
	RequiredWhenCompleted[packet, {IndicatorStripColorChange, IndicatorFluorescence, ControlFluorescence, IndicatorPlacements, ControlPlacements }]

};


(* ::Subsection::Closed:: *)
(*validQualificationBiosafetyCabinetQTests*)


validQualificationBiosafetyCabinetQTests[packet:PacketP[Object[Qualification,BiosafetyCabinet]]]:={
	(* required fields *)
	NotNullFieldTest[
		packet,
		{TestLight, TestUVLight, TestAlarm, RecordFlowSpeed, RecordLaminarFlowSpeed, ImageCertification}
	],

	Test["At least one test must be performed:",
		Lookup[packet,{TestLight, TestUVLight, TestAlarm, RecordFlowSpeed, RecordLaminarFlowSpeed, ImageCertification}],
		{___, True, ___}
	]
};


(* ::Subsection::Closed:: *)
(*validQualificationFlashChromatographyQTests*)


validQualificationFlashChromatographyQTests[packet:PacketP[Object[Qualification,FlashChromatography]]]:={
	(* required fields *)
	NotNullFieldTest[
		packet,
		{Target, Author, Model, Checkpoints}
	],

	RequiredWhenCompleted[
		packet,
		{QualificationProtocols}
	]
};


(* ::Subsection::Closed:: *)
(*validQualificationBottleRollerQTests*)


validQualificationBottleRollerQTests[packet:PacketP[Object[Qualification,BottleRoller]]]:= {

};


(* ::Subsection::Closed:: *)
(*validQualificationBalanceQTests*)


validQualificationBalanceQTests[packet:PacketP[Object[Qualification,Balance]]]:= {

	(* Fields filled in all the time from moment of creation*)
	NotNullFieldTest[packet,
		{
			QualificationSamples,
			WeightHandles
		}
	]

};


(* ::Subsection::Closed:: *)
(*validQualificationCapillaryELISAQTests*)


validQualificationCapillaryELISAQTests[packet:PacketP[Object[Qualification, CapillaryELISA]]]:= {
	RequiredWhenCompleted[packet,{TestCartridge,VerificationDataFilePath,VerificationDataFileName,VerificationDataFile}]
};


(* ::Subsection::Closed:: *)
(*validQualificationELISAQTests*)


validQualificationELISAQTests[packet:PacketP[Object[Qualification, ELISA]]]:= {

	If[Lookup[packet,Status]=!=Aborted,
		NotNullFieldTest[packet,{
			WashingBuffer,
			Tips,
			AbsorbanceQualificationPlate,
			LiquidHandlingQualificationVessels,
			ShakerIncubatorQualificationPlate,
			SecondaryShakerIncubatorQualificationPlate,
			WasherQualificationPlate,
			Balance

		}]
	],

	RequiredWhenCompleted[packet,{
		MethodFilePath,
		MethodFile,
		AbsorbanceQualificationDataFilePath,
		AbsorbanceQualificationDataFileNames,
		AbsorbanceQualificationDataFiles,
		AbsorbanceQualificationData,
		SamplePreparationPrimitives,
		SamplePreparationProtocol,
		FullyDissolved,
		ELISALiquidHandlingLog,
		ELISALiquidHandlingLogPath,
		ELISAPrimitives,
		WasherQualificationPlatePreWashWeight,
		WasherQualificationPlatePostWashWeight,
		FullyWashed,
		DeckPlacements,
		VesselRackPlacements,
		BufferContainerPlacements
	}]
};



(* ::Subsection::Closed:: *)
(*validQualificationCentrifugeQTests*)


validQualificationCentrifugeQTests[packet:PacketP[Object[Qualification,Centrifuge]]]:= {

};

(* ::Subsection::Closed:: *)
(*validQualificationColonyHandlerQTests*)


validQualificationColonyHandlerQTests[packet:PacketP[Object[Qualification, ColonyHandler]]] := {
	RequiredWhenCompleted[packet, {QualificationSamples, ImagingSample, ImagingProtocol}]
};


(* ::Subsection::Closed:: *)
(*validQualificationConductivityMeterQTests*)


validQualificationConductivityMeterQTests[packet:PacketP[Object[Qualification, ConductivityMeter]]]:= {

};

(* ::Subsection::Closed:: *)
(*validQualificationControlledRateFreezerQTests*)


validQualificationControlledRateFreezerQTests[packet:PacketP[Object[Qualification, ControlledRateFreezer]]]:= {

};


(* ::Subsection::Closed:: *)
(*validQualificationCoulterCounterQTests*)


validQualificationCoulterCounterQTests[packet:PacketP[Object[Qualification, CoulterCounter]]] := {

};



(* ::Subsection::Closed:: *)
(*validQualificationCrossFlowFiltrationQTests*)


validQualificationCrossFlowFiltrationQTests[packet:PacketP[Object[Qualification,CrossFlowFiltration]]]:={

	RequiredWhenCompleted[packet,{
		SamplePreparationProtocol,
		CrossFlowFiltrationSample,
		CrossFlowFiltrationControl,
		CrossFlowFiltrationProtocol,
		MeasureConductivityProtocol,
		AbsorbanceIntensityProtocol
	}],

	(* Fields filled in all the time from moment of creation*)
	NotNullFieldTest[packet,{
		CalibrationWeights,
		WeightHandles,
		FolderPath
	}]
};


(* ::Subsection::Closed:: *)
(*validQualificationCryogenicFreezerQTests*)


validQualificationCryogenicFreezerQTests[packet:PacketP[Object[Qualification,CryogenicFreezer]]]:={

	NotNullFieldTest[packet,{
		TimePeriod,
		SamplingRate
	}]

};


(* ::Subsection::Closed:: *)
(*validQualificationCrystalIncubatorQTests*)


validQualificationCrystalIncubatorQTests[packet:PacketP[Object[Qualification,CrystalIncubator]]]:={
	NotNullFieldTest[packet,{PreparatoryUnitOperations,CrystallizationCover,MaxCrystallizationTime,VerificationDataFileName,VerificationDataFilePath}],
	RequiredWhenCompleted[packet,{QualificationSamples,QualificationProtocols,VerificationDataFile}]
};

(* ::Subsection::Closed:: *)
(* validQualificationDesiccatorQTests *)


validQualificationDesiccatorQTests[packet : PacketP[Object[Qualification, Desiccator]]] := {
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

	RequiredWhenCompleted[packet, DesiccationImages],

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

(* ::Subsection:: *)
(*validQualificationDewarQTests*)


validQualificationDewarQTests[packet:PacketP[Object[Qualification, Dewar]]]:= {

	NotNullFieldTest[packet,{MaxFreezingTime}],
	RequiredWhenCompleted[packet,{SamplePreparationProtocol}]
};



(* ::Subsection:: *)
(*validQualificationDialyzerQTests*)


validQualificationDialyzerQTests[packet:PacketP[Object[Qualification, Dialyzer]]]:= {

};

(* ::Subsection::Closed:: *)
(*validQualificationDifferentialScanningCalorimeterQTests*)


validQualificationDifferentialScanningCalorimeterQTests[packet:PacketP[Object[Qualification,DifferentialScanningCalorimeter]]]:= {


};


(* ::Subsection::Closed:: *)
(*validQualificationDiffractometerQTests*)


validQualificationDiffractometerQTests[packet:PacketP[Object[Qualification,Diffractometer]]]:={
	(* Fields filled in all the time from moment of creation*)
	NotNullFieldTest[packet,
		{
			LinePositionTestSample,
			BlankSample,
			QualificationSamples
		}
	],

	(* results should be informed when qualification is done *)
	RequiredWhenCompleted[packet,
		{
			QualificationNotebook,
			SampleLinePositions,
			SampleLinePositionDistributions,
			BlankLinePositions,
			SampleLinePositionAccuracyResult,
			SampleLinePositionPrecisionResult,
			BlankLinePositionPrecisionResult,
			XRayDiffractionData,
			QualificationProtocols,
			CrystallizationPlate
		}
	]
};


(* ::Subsection::Closed:: *)
(*validQualificationDisruptorQTests*)


validQualificationDisruptorQTests[packet:PacketP[Object[Qualification,Disruptor]]]:= {

	(*required when completed*)
	RequiredWhenCompleted[packet,{FullyMixed}]
};


(* ::Subsection::Closed:: *)
(*validQualificationDissolvedOxygenMeterQTests*)


validQualificationDissolvedOxygenMeterQTests[packet:PacketP[Object[Qualification,DissolvedOxygenMeter]]]:={

};


(* ::Subsection::Closed:: *)
(*validQualificationDNASynthesizerQTests*)


validQualificationDNASynthesizerQTests[packet:PacketP[Object[Qualification,DNASynthesizer]]]:= {

};


(* ::Subsection:: *)
(*validQualificationDynamicFoamAnalyzerQTests*)


validQualificationDynamicFoamAnalyzerQTests[packet:PacketP[Object[Qualification, DynamicFoamAnalyzer]]]:= {
	RequiredWhenCompleted[packet,{SamplePreparationProtocol}]
};



(* ::Subsection::Closed:: *)
(*validQualificationElectrochemicalReactorQTests*)


validQualificationElectrochemicalReactorQTests[packet:PacketP[Object[Qualification,ElectrochemicalReactor]]]:= {

};


(* ::Subsection::Closed:: *)
(*validQualificationElectrophoresisQTests*)


validQualificationElectrophoresisQTests[packet:PacketP[Object[Qualification,Electrophoresis]]]:= {

};

(* ::Subsection:: *)
(*validQualificationFragmentAnalyzerQTests*)


validQualificationFragmentAnalyzerQTests[packet:PacketP[Object[Qualification, FragmentAnalyzer]]]:= {
	RequiredWhenCompleted[packet,{SamplePreparationProtocol}]
};


(* ::Subsection::Closed:: *)
(*validQualificationEngineBenchmarkQTests*)


validQualificationEngineBenchmarkQTests[packet:PacketP[Object[Qualification,EngineBenchmark]]]:=Join[
	{
		(* -- Type Specific Tests -- *)
		NotNullFieldTest[packet,{Condenser}],

		RequiredTogetherTest[packet,{PDUPoweredInstrument,PDUTime}],
		RequiredTogetherTest[packet,{Deck,DeckPlacements}],
		RequiredTogetherTest[packet,{RecordedSensorData,SelectedSensorData}],

		RequiredWhenCompleted[packet, {
			MultipleChoiceAnswer,
			OperatingSystem,
			SamplePreparationProtocols,
			PostProcessingProtocols
		}],

		ResolvedWhenCompleted[packet,{
			SelectedInstruments,
			Parts,
			WaterSamples,
			FluidSamples,
			SelfContainedSamples,
			Containers,
			Tips,
			PDUPoweredInstrument
		}],

		(* TwinCat software used by sensornet doesn't support Macs, so qualification skips sensor tasks *)
		Test["Sensor data should be recorded when the qualification is run on Windows:",
			If[
				And[
					MatchQ[packet[OperatingSystem],Alternatives[Windows7 | Windows10 | WindowsXP]],
					MatchQ[packet[Status],Completed]
				],
				MatchQ[packet[RecordedSensorData],ObjectP[Object[Data]]],
				True
			],
			True
		]
	},
	qualificationAndModelEngineBenchmarkSyncTests[packet]
];


(* Tests to ensure fields in the model were used appropriately in the qualification *)
qualificationAndModelEngineBenchmarkSyncTests[qualificationPacket:PacketP[Object[Qualification,EngineBenchmark]]]:=Module[
	{modelQualificationPacket},

	modelQualificationPacket = Download[
		qualificationPacket[Model]
	];

	(* If there's no model for the qualification we cannot do any sync tests *)
	(* VOQ will still fail since model is required*)
	If[Not[MatchQ[modelQualificationPacket,PacketP[]]],
		Return[{}]
	];

	(* Verify each field specified in the model qualification was used to populate the appropriate field in the qualification *)
	{
		modelQualificationSyncTest[WaterSamples,WaterModels,qualificationPacket,modelQualificationPacket],
		modelQualificationSyncTest[Sensor,SensorModel,qualificationPacket,modelQualificationPacket]
	}
];

modelQualificationSyncTest[objectField_Symbol,modelField_Symbol,qualificationPacket:PacketP[Object[Qualification,EngineBenchmark]],modelPacket:PacketP[Model[Qualification,EngineBenchmark]]]:=With[
	{},

	Test[
		"The field, "<>ToString[modelField]<>", in the qualification model and the field, "<>ToString[objectField]<>", in the qualification are both informed or both Null",
		MatchQ[
			{
				Lookup[qualificationPacket,objectField],
				Lookup[modelPacket,modelField]
			},
			Alternatives[
				{Null|{},Null|{}},
				{Except[Null|{}],Except[Null|{}]}
			]
		],
		True
	]
];




(* ::Subsection:: *)
(*validQualificationEvaporatorQTests*)


validQualificationEvaporatorQTests[packet:PacketP[Object[Qualification,Evaporator]]]:= {

};


(* ::Subsection::Closed:: *)
(*validQualificationFilterBlockQTests*)


validQualificationFilterBlockQTests[packet:PacketP[Object[Qualification,FilterBlock]]]:= {};




(* ::Subsection::Closed:: *)
(*validQualificationFilterHousingQTests*)


validQualificationFilterHousingQTests[packet:PacketP[Object[Qualification,FilterHousing]]]:= {

};



(* ::Subsection:: *)
(*validQualificationFreezePumpThawApparatusQTests*)


validQualificationFreezePumpThawApparatusQTests[packet:PacketP[Object[Qualification,FreezePumpThawApparatus]]]:= {
	NotNullFieldTest[packet,
		{DissolvedOxygenMeter}
	],
	RequiredWhenCompleted[packet,{SamplePreparationProtocol,InitialDissolvedOxygenConcentration,FinalDissolvedOxygenConcentration}]
};

(* ::Subsection::Closed:: *)
(*validQualificationWaterPurifierQTests*)


validQualificationWaterPurifierQTests[packet:PacketP[Object[Qualification,WaterPurifier]]]:={
	(* required fields *)
	NotNullFieldTest[
		packet,
		{Target, Model}
	],

	RequiredWhenCompleted[
		packet,
		{Alarm, WaterDispensed, QualityReportImage, Resistivity, TotalOrganicCarbon, Temperature}
	]
};


(* ::Subsection::Closed:: *)
(*validQualificationFumeHoodQTests*)


validQualificationFumeHoodQTests[packet:PacketP[Object[Qualification,FumeHood]]]:={
	(* required fields *)
	NotNullFieldTest[
		packet,
		{TestLight, TestAlarm, RecordFlowSpeed, ImageCertification}
	],

	Test["At least one test must be performed:",
		Lookup[packet,{TestLight, TestAlarm, RecordFlowSpeed, ImageCertification}],
		{___, True, ___}
	]
};



(* ::Subsection::Closed:: *)
(*validQualificationGasChromatographyQTests*)


validQualificationGasChromatographyQTests[packet:PacketP[Object[Qualification,GasChromatography]]]:= {

};

(* ::Subsection::Closed:: *)
(* validQualificationGrinderQTests *)


validQualificationGrinderQTests[packet : PacketP[Object[Qualification, Grinder]]] := {
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
	],

	RequiredWhenCompleted[packet, {CoarsePowderImage, FinePowderImage}]
};



(* ::Subsection::Closed:: *)
(*validQualificationHeatBlockQTests*)


validQualificationHeatBlockQTests[packet:PacketP[Object[Qualification,HeatBlock]]]:= {

};


(* ::Subsection::Closed:: *)
(*validQualificationHomogenizerQTests*)


validQualificationHomogenizerQTests[packet:PacketP[Object[Qualification,Homogenizer]]]:= {

	RequiredWhenCompleted[packet,{FullyDissolved}]
};


(* ::Subsection::Closed:: *)
(*validQualificationHPLCQTests*)


validQualificationHPLCQTests[packet:PacketP[Object[Qualification,HPLC]]]:=Module[{status,modelPacket,completed,result},

	{status,modelPacket,result}=Download[packet,{Status,Model[All],Result}];

	completed=MatchQ[status,Completed];

{
	(* Fields filled in from moment of creation*)
	NotNullFieldTest[packet,
		{InjectionVolumes,GradientMethods,Wavelengths,SamplePreparationPrimitives}
	],

	(* Tests that must pass regardless of the status of the qualification *)
	Test[
		"If testing fraction collection then FractionCollectionMethods and FractionCollectionTests must exist:",
		{
			NullQ[Lookup[modelPacket,FractionCollectionTestSample]],
			MemberQ[Lookup[packet,FractionCollectionMethods],ObjectP[Object[Method,FractionCollection]]],
			MatchQ[Lookup[packet,FractionCollectionTests],{}]
		},
		Alternatives[
			{True,False,True},
			{False,True,False}
		]
	],

	Test[
		"If testing flow linearity then FlowLinearityTests must exist:",
		{
			NullQ[Lookup[modelPacket,FlowLinearityTestSample]],
			MatchQ[Lookup[packet,FlowLinearityTests],{}]
		},
		Alternatives[
			{True,True},
			{False,False}
		]
	],

	Test[
		"If testing wavelength accuracy WavelengthAccuracyTests must exist:",
		{
			NullQ[Lookup[modelPacket,WavelengthAccuracyTestSample]],
			MatchQ[Lookup[packet,WavelengthAccuracyTests],{}]
		},
		Alternatives[
			{True,True},
			{False,False}
		]
	],

	Test[
		"If testing flow linearity then FlowLinearityTests must exist:",
		{
			NullQ[Lookup[modelPacket,FlowLinearityTestSample]],
			MatchQ[Lookup[packet,FlowLinearityTests],{}]
		},
		Alternatives[
			{True,True},
			{False,False}
		]
	],

	Test[
		"If testing the autosampler then AutosamplerTests must exist:",
		{
			NullQ[Lookup[modelPacket,AutosamplerTestSample]],
			MatchQ[Lookup[packet,AutosamplerTests],{}]
		},
		Alternatives[
			{True,True},
			{False,False}
		]
	],

	Test[
		"If testing detector linearity then DetectorLinearityTests must exist:",
		{
			NullQ[Lookup[modelPacket,DetectorLinearityTestSample]],
			MatchQ[Lookup[packet,DetectorLinearityTests],{}]
		},
		Alternatives[
			{True,True},
			{False,False}
		]
	],

	Test[
		"If testing gradient proportioning then GradientProportioningTests must exist:",
		{
			NullQ[Lookup[modelPacket,GradientProportioningTestSample]],
			MatchQ[Lookup[packet,GradientProportioningTests],{}]
		},
		Alternatives[
			{True,True},
			{False,False}
		]
	],

	(* Tests that must pass when the qualification is complete *)
	Test[
		"If testing fraction collection then FractionAbsorbanceProtocol, MinAbsorbance, and FractionCollectionTestResults should be informed upon completion:",
		{
			TrueQ[completed]&&MatchQ[result,True]&&!NullQ[Lookup[modelPacket,FractionCollectionTestSample]],
			MatchQ[
				Lookup[packet,{MinAbsorbance,FractionAbsorbanceProtocol,FractionCollectionTestResults}],
				{Except[Null],Except[Null],Except[{}]}
			]
		},
		Alternatives[
			{True,True},
			{False,_}
		]
	],

	Test[
		"If testing flow linearity then FlowRatePrecisionPeaksAnalyses, MaxFlowPrecisionRetentionRSD, FlowRatePrecisionPassing, FlowLinearityPeaksAnalyses, FlowLinearityTestResults, and FlowRateAccuracyTestResults must exist upon completion:",
		{
			TrueQ[completed]&&!NullQ[Lookup[modelPacket,FlowLinearityTestSample]],
			MatchQ[
				Lookup[modelPacket,{FlowRatePrecisionPeaksAnalyses,MaxFlowPrecisionRetentionRSD,FlowRatePrecisionPassing,FlowLinearityPeaksAnalyses,FlowLinearityTestResults,FlowRateAccuracyTestResults}],
				{Except[{}],Except[Null],Except[Null],Except[{}],Except[{}],Except[{}]}
			]
		},
		Alternatives[
			{True,True},
			{False,_}
		]
	],

	Test[
		"If testing wavelength accuracy then WavelengthAccuracyPeaksAnalyses and WavelengthAccuracyTestResults must exist upon completion:",
		{
			TrueQ[completed]&&!NullQ[Lookup[modelPacket,WavelengthAccuracyTestSample]],
			MatchQ[
				Lookup[modelPacket,{WavelengthAccuracyPeaksAnalyses,WavelengthAccuracyTestResults}],
				{Except[{}],Except[{}]}
			]
		},
		Alternatives[
			{True,True},
			{False,_}
		]
	],

	Test[
		"If testing the autosampler then InjectionPrecisionPeaksAnalyses, MaxInjectionPrecisionPeakAreaRSD, InjectionPrecisionPassing, FlowRatePrecisionPassing, and FlowRatePrecisionPeaksAnalyses must exist upon completion:",
		{
			TrueQ[completed]&&!NullQ[Lookup[modelPacket,FlowLinearityTestSample]],
			MatchQ[
				Lookup[modelPacket,{InjectionPrecisionPeaksAnalyses,MaxInjectionPrecisionPeakAreaRSD,InjectionPrecisionPassing,FlowRatePrecisionPassing,FlowRatePrecisionPeaksAnalyses}],
				{Except[{}],Except[Null],Except[Null],Except[Null],Except[{}]}
			]
		},
		Alternatives[
			{True,True},
			{False,_}
		]
	],

	Test[
		"If testing detector linearity then DetectorResponsePeaksAnalyses, DetectorResponseFactorResults and DetectorLinearityResults must exist upon completion:",
		{
			TrueQ[completed]&&!NullQ[Lookup[modelPacket,DetectorLinearityTestSample]],
			MatchQ[
				Lookup[modelPacket,{DetectorResponsePeaksAnalyses,DetectorResponseFactorResults,DetectorLinearityResults}],
				{Except[{}],Except[{}],Except[{}]}
			]
		},
		Alternatives[
			{True,True},
			{False,_}
		]
	],

	Test[
		"If testing wavelength accuracy then WavelengthAccuracyTestResults and WavelengthAccuracyPeaksAnalyses must exist upon completion:",
		{
			TrueQ[completed]&&!NullQ[Lookup[modelPacket,WavelengthAccuracyTestSample]],
			MatchQ[
				Lookup[modelPacket,{WavelengthAccuracyTestResults,WavelengthAccuracyPeaksAnalyses}],
				{Except[{}],Except[{}]}
			]
		},
		Alternatives[
			{True,True},
			{False,_}
		]
	],

	(* results should be informed when qualification is done *)
	RequiredWhenCompleted[packet, {TransitionedGradientMethods, QualificationNotebook}]
}
];

(* ::Subsection::Closed:: *)
(*validQualificationIncubatorQTests*)


validQualificationIncubatorQTests[packet:PacketP[Object[Qualification,Incubator]]]:={

	(* results should be informed when qualification is done *)
	RequiredWhenCompleted[packet,
		{
			QualificationNotebook,
			FullyDissolved,
			EnvironmentalData
		}
	]
};

(* ::Subsection::Closed:: *)
(*validQualificationLCMSQTests*)


validQualificationLCMSQTests[packet:PacketP[Object[Qualification,LCMS]]]:=Module[{status,modelPacket,completed},

	{status,modelPacket}=Download[packet,{Status,Model[All]}];

	completed=MatchQ[status,Completed];

	{
		(* Fields filled in from moment of creation*)
		NotNullFieldTest[packet,
			{InjectionVolumes,GradientMethods,Wavelengths,SamplePreparationPrimitives}
		],

		(* Tests that must pass regardless of the status of the qualification *)

		Test[
			"If testing flow linearity then FlowLinearityTests must exist:",
			{
				NullQ[Lookup[modelPacket,FlowLinearityTestSample]],
				MatchQ[Lookup[packet,FlowLinearityTests],{}]
			},
			Alternatives[
				{True,True},
				{False,False}
			]
		],

		Test[
			"If testing wavelength accuracy WavelengthAccuracyTests must exist:",
			{
				NullQ[Lookup[modelPacket,WavelengthAccuracyTestSample]],
				MatchQ[Lookup[packet,WavelengthAccuracyTests],{}]
			},
			Alternatives[
				{True,True},
				{False,False}
			]
		],

		Test[
			"If testing mass accuracy MassAccuracyTests must exist:",
			{
				NullQ[Lookup[modelPacket,MassAccuracyTestSample]],
				MatchQ[Lookup[packet,MassAccuracyTests],{}]
			},
			Alternatives[
				{True,True},
				{False,False}
			]
		],

		Test[
			"If testing flow linearity then FlowLinearityTests must exist:",
			{
				NullQ[Lookup[modelPacket,FlowLinearityTestSample]],
				MatchQ[Lookup[packet,FlowLinearityTests],{}]
			},
			Alternatives[
				{True,True},
				{False,False}
			]
		],

		Test[
			"If testing the autosampler then AutosamplerTests must exist:",
			{
				NullQ[Lookup[modelPacket,AutosamplerTestSample]],
				MatchQ[Lookup[packet,AutosamplerTests],{}]
			},
			Alternatives[
				{True,True},
				{False,False}
			]
		],

		Test[
			"If testing detector linearity then DetectorLinearityTests must exist:",
			{
				NullQ[Lookup[modelPacket,DetectorLinearityTestSample]],
				MatchQ[Lookup[packet,DetectorLinearityTests],{}]
			},
			Alternatives[
				{True,True},
				{False,False}
			]
		],

		Test[
			"If testing gradient proportioning then GradientProportioningTests must exist:",
			{
				NullQ[Lookup[modelPacket,GradientProportioningTestSample]],
				MatchQ[Lookup[packet,GradientProportioningTests],{}]
			},
			Alternatives[
				{True,True},
				{False,False}
			]
		],

		(* Tests that must pass when the qualification is complete *)
		Test[
			"If testing fraction collection then FractionAbsorbanceProtocol, MinAbsorbance, and FractionCollectionTestResults should be informed upon completion:",
			{
				TrueQ[completed]&&!NullQ[Lookup[modelPacket,FractionCollectionTestSample,Null]],
				MatchQ[
					Lookup[packet,{MinAbsorbance,FractionAbsorbanceProtocol,FractionCollectionTestResults}],
					{Except[Null],Except[Null],Except[{}]}
				]
			},
			Alternatives[
				{True,True},
				{False,_}
			]
		],

		Test[
			"If testing flow linearity then FlowLinearityPeaksAnalyses, FlowLinearityTestResults, and FlowRateAccuracyTestResults must exist upon completion:",
			{
				TrueQ[completed]&&!NullQ[Lookup[modelPacket,FlowLinearityTestSample]],
				MatchQ[
					Lookup[modelPacket,{FlowLinearityPeaksAnalyses,FlowLinearityTestResults,FlowRateAccuracyTestResults}],
					ConstantArray[Except[{}|Null],3]
				]
			},
			Alternatives[
				{True,True},
				{False,_}
			]
		],

		Test[
			"If testing wavelength accuracy then WavelengthAccuracyPeaksAnalyses and WavelengthAccuracyTestResults must exist upon completion:",
			{
				TrueQ[completed]&&!NullQ[Lookup[modelPacket,WavelengthAccuracyTestSample]],
				MatchQ[
					Lookup[modelPacket,{WavelengthAccuracyPeaksAnalyses,WavelengthAccuracyTestResults}],
					{Except[{}],Except[{}]}
				]
			},
			Alternatives[
				{True,True},
				{False,_}
			]
		],

		Test[
			"If testing the autosampler then InjectionPrecisionPeaksAnalyses, MaxInjectionPrecisionPeakAreaRSD, InjectionPrecisionPassing, FlowRatePrecisionPassing, and FlowRatePrecisionPeaksAnalyses must exist upon completion:",
			{
				TrueQ[completed]&&!NullQ[Lookup[modelPacket,DetectorLinearityTestSample]],
				MatchQ[
					Lookup[modelPacket,{InjectionPrecisionPeaksAnalyses,MaxInjectionPrecisionPeakAreaRSD,InjectionPrecisionPassing,FlowRatePrecisionPassing,FlowRatePrecisionPeaksAnalyses}],
					{Except[{}],Except[Null],Except[Null],Except[Null],Except[{}]}
				]
			},
			Alternatives[
				{True,True},
				{False,_}
			]
		],

		Test[
			"If testing detector linearity then DetectorResponsePeaksAnalyses, DetectorResponseFactorResults and DetectorLinearityResults must exist upon completion:",
			{
				TrueQ[completed]&&!NullQ[Lookup[modelPacket,DetectorLinearityTestSample]],
				MatchQ[
					Lookup[modelPacket,{DetectorResponsePeaksAnalyses,DetectorResponseFactorResults,DetectorLinearityResults}],
					{Except[{}],Except[{}],Except[{}]}
				]
			},
			Alternatives[
				{True,True},
				{False,_}
			]
		],

		Test[
			"If testing wavelength accuracy then WavelengthAccuracyTestResults and WavelengthAccuracyPeaksAnalyses must exist upon completion:",
			{
				TrueQ[completed]&&!NullQ[Lookup[modelPacket,WavelengthAccuracyTestSample]],
				MatchQ[
					Lookup[modelPacket,{WavelengthAccuracyTestResults,WavelengthAccuracyPeaksAnalyses}],
					{Except[{}],Except[{}]}
				]
			},
			Alternatives[
				{True,True},
				{False,_}
			]
		],

		Test[
			"If testing mass accuracy then MassAccuracyTestResults and MassAccuracyPeaksAnalyses must exist upon completion:",
			{
				TrueQ[completed]&&!NullQ[Lookup[modelPacket,MassAccuracyTestSample]],
				MatchQ[
					Lookup[modelPacket,{MassAccuracyTestResults,MassAccuracyPeaksAnalyses}],
					{Except[{}],Except[{}]}
				]
			},
			Alternatives[
				{True,True},
				{False,_}
			]
		],

		(* results should be informed when qualification is done *)
		RequiredWhenCompleted[packet, {QualificationNotebook}]
	}
];

(* ::Subsection::Closed:: *)
(*validQualificationIonChromatographyQTests*)


validQualificationIonChromatographyQTests[packet:PacketP[Object[Qualification,IonChromatography]]]:=Module[{status,modelPacket,completed},

	{status,modelPacket}=Download[packet,{Status,Model[All]}];

	completed=MatchQ[status,Completed];

	{
		NotNullFieldTest[packet,
			{SamplePreparationPrimitives,AnalysisChannels}
		],

		(* Fields filled in from moment of creation*)
		Which[

			!MatchQ[Lookup[packet,AnionQualificationSamples],{}]&&!MatchQ[Lookup[packet,CationQualificationSamples],{}],
			NotNullFieldTest[packet,
				{AnionInjectionVolumes,AnionGradientMethods,CationInjectionVolumes,CationGradientMethods}
			],

			!MatchQ[Lookup[packet,AnionQualificationSamples],{}],
			NotNullFieldTest[packet,
				{AnionInjectionVolumes,AnionGradientMethods}
			],

			!MatchQ[Lookup[packet,CationQualificationSamples],{}],
			NotNullFieldTest[packet,
				{CationInjectionVolumes,CationGradientMethods}
			],

			True,
			NotNullFieldTest[packet,
				{InjectionVolumes,GradientMethods}
			]
		],

		(* Tests that must pass regardless of the status of the qualification *)

		Test[
			"If testing anion flow linearity then AnionFlowLinearityTests must exist:",
			{
				NullQ[Lookup[modelPacket,AnionFlowLinearityTestSample]],
				MatchQ[Lookup[packet,AnionFlowLinearityTests],{}]
			},
			Alternatives[
				{True,True},
				{False,False}
			]
		],

		Test[
			"If testing cation flow linearity then CationFlowLinearityTests must exist:",
			{
				NullQ[Lookup[modelPacket,CationFlowLinearityTestSample]],
				MatchQ[Lookup[packet,CationFlowLinearityTests],{}]
			},
			Alternatives[
				{True,True},
				{False,False}
			]
		],

		Test[
			"If testing flow linearity then FlowLinearityTests must exist:",
			{
				NullQ[Lookup[modelPacket,FlowLinearityTestSample]],
				MatchQ[Lookup[packet,FlowLinearityTests],{}]
			},
			Alternatives[
				{True,True},
				{False,False}
			]
		],

		Test[
			"If testing flow linearity then FlowLinearityTests must exist:",
			{
				NullQ[Lookup[modelPacket,FlowLinearityTestSample]],
				MatchQ[Lookup[packet,FlowLinearityTests],{}]
			},
			Alternatives[
				{True,True},
				{False,False}
			]
		],

		Test[
			"If testing the anion autosampler then AnionAutosamplerTests must exist:",
			{
				NullQ[Lookup[modelPacket,AnionAutosamplerTestSample]],
				MatchQ[Lookup[packet,AnionAutosamplerTests],{}]
			},
			Alternatives[
				{True,True},
				{False,False}
			]
		],

		Test[
			"If testing the cation autosampler then CationAutosamplerTests must exist:",
			{
				NullQ[Lookup[modelPacket,CationAutosamplerTestSample]],
				MatchQ[Lookup[packet,CationAutosamplerTests],{}]
			},
			Alternatives[
				{True,True},
				{False,False}
			]
		],

		Test[
			"If testing the autosampler then AutosamplerTests must exist:",
			{
				NullQ[Lookup[modelPacket,AutosamplerTestSample]],
				MatchQ[Lookup[packet,AutosamplerTests],{}]
			},
			Alternatives[
				{True,True},
				{False,False}
			]
		],

		Test[
			"If testing the anion detector linearity then AnionDetectorLinearityTestSample must exist:",
			{
				NullQ[Lookup[modelPacket,AnionDetectorLinearityTestSample]],
				MatchQ[Lookup[packet,AnionDetectorLinearityTests],{}]
			},
			Alternatives[
				{True,True},
				{False,False}
			]
		],

		Test[
			"If testing the cation detector linearity then CationDetectorLinearityTestSample must exist:",
			{
				NullQ[Lookup[modelPacket,CationDetectorLinearityTestSample]],
				MatchQ[Lookup[packet,CationDetectorLinearityTests],{}]
			},
			Alternatives[
				{True,True},
				{False,False}
			]
		],

		Test[
			"If testing the electrochemical detector linearity then ElectrochemicalDetectorLinearityTestSample must exist:",
			{
				NullQ[Lookup[modelPacket,ElectrochemicalDetectorLinearityTestSample]],
				MatchQ[Lookup[packet,ElectrochemicalDetectorLinearityTests],{}]
			},
			Alternatives[
				{True,True},
				{False,False}
			]
		],

		Test[
			"If testing the absorbance detector linearity then DetectorLinearityTestSample must exist:",
			{
				NullQ[Lookup[modelPacket,DetectorLinearityTestSample]],
				MatchQ[Lookup[packet,DetectorLinearityTests],{}]
			},
			Alternatives[
				{True,True},
				{False,False}
			]
		],

		Test[
			"If testing gradient proportioning then GradientProportioningTests must exist:",
			{
				NullQ[Lookup[modelPacket,GradientProportioningTestSample]],
				MatchQ[Lookup[packet,GradientProportioningTests],{}]
			},
			Alternatives[
				{True,True},
				{False,False}
			]
		],

		Test[
			"If testing the eluent generator cartridge concentration then EluentConcentrationTestSample must exist:",
			{
				NullQ[Lookup[modelPacket,EluentConcentrationTestSample]],
				MatchQ[Lookup[packet,EluentConcentrationTests],{}]
			},
			Alternatives[
				{True,True},
				{False,False}
			]
		],

		(* Tests that must pass when the qualification is complete *)
		Test[
			"If testing anion flow linearity then AnionFlowRatePrecisionPeaksAnalyses,MaxAnionFlowPrecisionRetentionRSD,AnionFlowRatePrecisionPassing,AnionFlowLinearityPeaksAnalyses,AnionFlowLinearityTestResults,and AnionFlowRateAccuracyTestResults must exist upon completion:",
			{
				TrueQ[completed]&&!NullQ[Lookup[modelPacket,AnionFlowLinearityTestSample]],
				MatchQ[
					Lookup[packet,{AnionFlowRatePrecisionPeaksAnalyses,MaxAnionFlowPrecisionRetentionRSD,AnionFlowRatePrecisionPassing,AnionFlowLinearityPeaksAnalyses,AnionFlowLinearityTestResults,AnionFlowRateAccuracyTestResults}],
					{Except[{}],Except[Null],Except[Null],Except[{}],Except[{}],Except[{}]}
				]
			},
			Alternatives[
				{True,True},
				{False,_}
			]
		],

		Test[
			"If testing cation flow linearity then CationFlowRatePrecisionPeaksAnalyses,MaxCationFlowPrecisionRetentionRSD,CationFlowRatePrecisionPassing,CationFlowLinearityPeaksAnalyses,CationFlowLinearityTestResults, and CationFlowRateAccuracyTestResults must exist upon completion:",
			{
				TrueQ[completed]&&!NullQ[Lookup[modelPacket,CationFlowLinearityTestSample]],
				MatchQ[
					Lookup[packet,{CationFlowRatePrecisionPeaksAnalyses,MaxCationFlowPrecisionRetentionRSD,CationFlowRatePrecisionPassing,CationFlowLinearityPeaksAnalyses,CationFlowLinearityTestResults,CationFlowRateAccuracyTestResults}],
					{Except[{}],Except[Null],Except[Null],Except[{}],Except[{}],Except[{}]}
				]
			},
			Alternatives[
				{True,True},
				{False,_}
			]
		],

		Test[
			"If testing flow linearity then FlowRatePrecisionPeaksAnalyses,MaxFlowPrecisionRetentionRSD,FlowRatePrecisionPassing,FlowLinearityPeaksAnalyses,FlowLinearityTestResults, and FlowRateAccuracyTestResults must exist upon completion:",
			{
				TrueQ[completed]&&!NullQ[Lookup[modelPacket,FlowLinearityTestSample]],
				MatchQ[
					Lookup[packet,{FlowRatePrecisionPeaksAnalyses,MaxFlowPrecisionRetentionRSD,FlowRatePrecisionPassing,FlowLinearityPeaksAnalyses,FlowLinearityTestResults,FlowRateAccuracyTestResults}],
					{Except[{}],Except[Null],Except[Null],Except[{}],Except[{}],Except[{}]}
				]
			},
			Alternatives[
				{True,True},
				{False,_}
			]
		],

		Test[
			"If testing the anion autosampler then AnionInjectionPrecisionPeaksAnalyses,MaxAnionInjectionPrecisionPeakAreaRSD,and AnionInjectionPrecisionPassing must exist upon completion:",
			{
				TrueQ[completed]&&!NullQ[Lookup[modelPacket,AnionAutosamplerTestSample]],
				MatchQ[
					Lookup[packet,{AnionInjectionPrecisionPeaksAnalyses,MaxAnionInjectionPrecisionPeakAreaRSD,AnionInjectionPrecisionPassing}],
					{Except[{}],Except[Null],Except[Null]}
				]
			},
			Alternatives[
				{True,True},
				{False,_}
			]
		],

		Test[
			"If testing the cation autosampler then CationInjectionPrecisionPeaksAnalyses,MaxCationInjectionPrecisionPeakAreaRSD,and CationInjectionPrecisionPassing must exist upon completion:",
			{
				TrueQ[completed]&&!NullQ[Lookup[modelPacket,CationAutosamplerTestSample]],
				MatchQ[
					Lookup[packet,{CationInjectionPrecisionPeaksAnalyses,MaxCationInjectionPrecisionPeakAreaRSD,CationInjectionPrecisionPassing}],
					{Except[{}],Except[Null],Except[Null]}
				]
			},
			Alternatives[
				{True,True},
				{False,_}
			]
		],

		Test[
			"If testing the autosampler then InjectionPrecisionPeaksAnalyses,MaxInjectionPrecisionPeakAreaRSD,and InjectionPrecisionPassing must exist upon completion:",
			{
				TrueQ[completed]&&!NullQ[Lookup[modelPacket,AutosamplerTestSample]],
				MatchQ[
					Lookup[packet,{InjectionPrecisionPeaksAnalyses,MaxInjectionPrecisionPeakAreaRSD,InjectionPrecisionPassing}],
					{Except[{}],Except[Null],Except[Null]}
				]
			},
			Alternatives[
				{True,True},
				{False,_}
			]
		],

		Test[
			"If testing anion detector linearity then AnionDetectorResponsePeaksAnalyses,AnionDetectorResponseFactorResults, and AnionDetectorLinearityResults must exist upon completion:",
			{
				TrueQ[completed]&&!NullQ[Lookup[modelPacket,AnionDetectorLinearityTestSample]],
				MatchQ[
					Lookup[packet,{AnionDetectorResponsePeaksAnalyses,AnionDetectorResponseFactorResults,AnionDetectorLinearityResults}],
					{Except[{}],Except[{}],Except[{}]}
				]
			},
			Alternatives[
				{True,True},
				{False,_}
			]
		],

		Test[
			"If testing cation detector linearity then CationDetectorResponsePeaksAnalyses,CationDetectorResponseFactorResults, and CationDetectorLinearityResults must exist upon completion:",
			{
				TrueQ[completed]&&!NullQ[Lookup[modelPacket,CationDetectorLinearityTestSample]],
				MatchQ[
					Lookup[packet,{CationDetectorResponsePeaksAnalyses,CationDetectorResponseFactorResults,CationDetectorLinearityResults}],
					{Except[{}],Except[{}],Except[{}]}
				]
			},
			Alternatives[
				{True,True},
				{False,_}
			]
		],

		Test[
			"If testing electrochemical detector linearity then ElectrochemicalDetectorResponsePeaksAnalyses,ElectrochemicalDetectorResponseFactorResults, and ElectrochemicalDetectorLinearityResults must exist upon completion:",
			{
				TrueQ[completed]&&!NullQ[Lookup[modelPacket,ElectrochemicalDetectorLinearityTestSample]],
				MatchQ[
					Lookup[packet,{ElectrochemicalDetectorResponsePeaksAnalyses,ElectrochemicalDetectorResponseFactorResults,ElectrochemicalDetectorLinearityResults}],
					{Except[{}],Except[{}],Except[{}]}
				]
			},
			Alternatives[
				{True,True},
				{False,_}
			]
		],

		Test[
			"If testing absorbance detector linearity then DetectorResponsePeaksAnalyses,DetectorResponseFactorResults, and DetectorLinearityResults must exist upon completion:",
			{
				TrueQ[completed]&&!NullQ[Lookup[modelPacket,DetectorLinearityTestSample]],
				MatchQ[
					Lookup[packet,{DetectorResponsePeaksAnalyses,DetectorResponseFactorResults,DetectorLinearityResults}],
					{Except[{}],Except[{}],Except[{}]}
				]
			},
			Alternatives[
				{True,True},
				{False,_}
			]
		],

		Test[
			"If testing gradient proportioning then GradientProportioningPeaksAnalyses and GradientProportioningTestResults must exist upon completion:",
			{
				TrueQ[completed]&&!NullQ[Lookup[modelPacket,GradientProportioningTestSample]],
				MatchQ[
					Lookup[packet,{GradientProportioningPeaksAnalyses,GradientProportioningTestResults}],
					{Except[{}],Except[Null]}
				]
			},
			Alternatives[
				{True,True},
				{False,_}
			]
		],

		Test[
			"If testing eluent generator cartridge concentration then EluentConcentrationAnalyses, EluentGeneratorResponseFactorResults, and EluentConcentrationTestResults must exist upon completion:",
			{
				TrueQ[completed]&&!NullQ[Lookup[modelPacket,EluentConcentrationTestSample]],
				MatchQ[
					Lookup[packet,{EluentConcentrationAnalyses,EluentConcentrationTestResults,EluentGeneratorResponseFactorResults}],
					{Except[{}],Except[Null]}
				]
			},
			Alternatives[
				{True,True},
				{False,_}
			]
		],

		(* results should be informed when qualification is done *)
		RequiredWhenCompleted[packet, {QualificationNotebook}]
	}
];


(* ::Subsection::Closed:: *)
(*validQualificationLiquidLevelDetectionQTests*)


validQualificationLiquidLevelDetectionQTests[packet:PacketP[Object[Qualification,LiquidLevelDetection]]]:={

	(* If DateCompleted is informed, then these fields should also be informed *)
	RequiredWhenCompleted[packet, {DiagnosticFile, DeckAndWasteCheck, Pipettor1000ulTightnessCheck, Pipettor1000ulCapacitiveLLD}],

	(* Fields filled in all the time from moment of creation*)
	NotNullFieldTest[packet,
		{
			LiquidHandler,
			WashSolution,
			CottonTipApplicators
		}
	],

	(* Field filled in after checkpoint *)
	RequiredAfterCheckpoint[packet, "Cleaning Needles", {CarrierPlacements}]
};


(* ::Subsection::Closed:: *)
(*validQualificationLiquidHandlerQTests*)


validQualificationLiquidHandlerQTests[packet:PacketP[Object[Qualification,LiquidHandler]]]:= {};


(* ::Subsection:: *)
(*validQualificationLyophilizerQTests*)


validQualificationLyophilizerQTests[packet:PacketP[Object[Qualification,Lyophilizer]]]:= {

};


(* ::Subsection::Closed:: *)
(*validQualificationMassSpectrometerQTests*)


validQualificationMassSpectrometerQTests[packet:PacketP[Object[Qualification,MassSpectrometer]]]:={

	RequiredWhenCompleted[packet,
		Which[
			(* The SCIEX QTRAP 6500 direct injection Qualification *)
			MatchQ[Lookup[packet,Model],ObjectP[Model[Qualification, MassSpectrometer, "id:01G6nvw16LxE"]]],
			{
				QualificationNotebook,
				QualificationProtocols
			},
			(* The Waters ESI-QTOF direct injection Qualification *)
			MatchQ[Lookup[packet,Model],ObjectP[Model[Qualification, MassSpectrometer, "id:XnlV5jKXRXGn"]]],
			{
				QualificationNotebook,
				QualificationProtocols
			},
		(* The Bruker MALDI Qualification *)
			MatchQ[Lookup[packet,Model],ObjectP[Model[Qualification, MassSpectrometer, "id:wqW9BP7VwqMR"]]],
			{
				QualificationNotebook,
				MassRangeDistributions,
				CalibrationPeaks,
				(*PeakPositionDistributions,*)
				CrossContaminationPeaks,
				CalibrationTestResult,
				MassRangeTestResult,
				(*PeakPositionTestResult,*)
				CrossContaminationTestResult,
				QualificationProtocols
			},
			(* The Thermo Fisher iCAP RQ ICP-MS *)
			MatchQ[Lookup[packet,Model],ObjectP[Model[Qualification, MassSpectrometer, "Thermo Fisher iCAP RQ ICP-MS Qualification"]]],
			{
				QualificationNotebook,
				QualificationProtocols,
				IntensityDistributions,
				CalibrationCurve,
				TuneReportFile,
				SensitivityTests,
				StabilityTests,
				MassCalibration,
				IntensityTestResult,
				CalibrationCurveTestResult,
				TuneResult
			},
			(* Catch all*)
			True,
			{
				QualificationNotebook,
				QualificationProtocols
			}
		]
	]

};


(* ::Subsection::Closed:: *)
(*validQualificationMeltingPointApparatusQTests*)


validQualificationMeltingPointApparatusQTests[packet:PacketP[Object[Qualification,MeltingPointApparatus]]]:={
	NotNullFieldTest[packet,
		{
			QualificationSamples,
			AdjustmentMethod,
			Desiccate,
			Grind
		}
	]
};


(* ::Subsection::Closed:: *)
(*validQualificationMicroscopeQTests*)


validQualificationMicroscopeQTests[packet:PacketP[Object[Qualification,Microscope]]]:={

	(*required*)
	NotNullFieldTest[packet,
		{
			QualificationMicroscopeSlide
		}
	],

	(*required when completed*)
	RequiredWhenCompleted[packet,{QualificationSamples,AdjustmentSamples}]
};


(* ::Subsection::Closed:: *)
(*validQualificationMultimodeSpectrophotometerQTests*)


validQualificationMultimodeSpectrophotometerQTests[packet:PacketP[Object[Qualification,MultimodeSpectrophotometer]]]:= {

	RequiredWhenCompleted[packet,{ThermalShiftProtocol}]
};


(* ::Subsection::Closed:: *)
(*validQualificationNutatorQTests*)


validQualificationNutatorQTests[packet:PacketP[Object[Qualification,Nutator]]]:= {

	(*required when completed*)
	RequiredWhenCompleted[packet,{FullyMixed}]
};


(* ::Subsection::Closed:: *)
(*validQualificationOsmometerQTests*)


validQualificationOsmometerQTests[packet:PacketP[Object[Qualification,Osmometer]]]:= {

	(*required*)
	NotNullFieldTest[packet,{QualificationSamples}]
};



(* ::Subsection::Closed:: *)
(*validQualificationOverheadStirrerQTests*)


validQualificationOverheadStirrerQTests[packet:PacketP[Object[Qualification,OverheadStirrer]]]:= {

	(*required when completed*)
	RequiredWhenCompleted[packet,{FullyDissolved}]
};


(* ::Subsection::Closed:: *)
(*validQualificationPCRQTests*)


validQualificationPCRQTests[packet:PacketP[Object[Qualification,PCR]]]:={

	RequiredWhenCompleted[packet,
		{
			FluorescenceIntensityProtocol
		}
	]

};


(* ::Subsection::Closed:: *)
(*validQualificationPlateSealerQTests*)


validQualificationPlateSealerQTests[packet:PacketP[Object[Qualification,PlateSealer]]]:={

	RequiredWhenCompleted[packet,
		{
			FullySealed
		}
	]

};


(* ::Subsection::Closed:: *)
(*validQualificationPeristalticPumpQTests*)


validQualificationPeristalticPumpQTests[packet:PacketP[Object[Qualification,PeristalticPump]]]:= {

};


(* ::Subsection::Closed:: *)
(*validQualificationPipettingLinearityQTests*)


validQualificationPipettingLinearityQTests[packet:PacketP[Object[Qualification,PipettingLinearity]]]:={

	(* Fields filled in all the time from moment of creation*)
	NotNullFieldTest[packet,
		{
			LabArea,
			Buffer,
			TotalBufferVolume,
			FluorescentReagent,
			TotalFluorescenceVolume,
			AssayPlates,
			Tips,
			DilutionProgram,
			LiquidHandlerMethodFilePath,
			ExcitationWavelength,
			EmissionWavelength
		}
	],
	Test[
		"Length of BufferVolume and FluorescentVolume should match:",
		MatchQ[Length[Lookup[packet,BufferVolumes]],Length[Lookup[packet,FluorescentVolumes]]],
		True
	],
	Test[
		"Length of BufferVolumes equals to the length of PipettingChannels * NumberOfPlates * Number Of Concentrations:",
		With[
			{
				numberOfReplicates=Lookup[packet,NumberOfReplicates],
				numberOfConcentrations=Lookup[packet,NumberOfConcentrations],
				numberOfChannels=Length[Lookup[packet,PipettingChannels]],
				numberOfVolumes=Length[Lookup[packet,BufferVolumes]]
			},
			MatchQ[(numberOfReplicates*numberOfConcentrations*numberOfChannels),numberOfVolumes]
		],
		True
	],
	(* once complete, these fields should be informed *)
	RequiredWhenCompleted[packet,{LiquidHandlerDeckPlacements, FluorescenceIntensityProtocol}],
	(* once complete, these fields should be resolved *)
	RequiredWhenCompleted[packet,{FluorescentReagent, Buffer, RValues, Results}]
};


(* ::Subsection::Closed:: *)
(*validQualificationPlateImagerQTests*)


validQualificationPlateImagerQTests[packet:PacketP[Object[Qualification,PlateImager]]]:= {

	NotNullFieldTest[
		packet,
		{
			PreparatoryUnitOperations,
			IlluminationDirections
		}
	]

};


(* ::Subsection::Closed:: *)
(*validQualificationPlateReaderQTests*)


validQualificationPlateReaderQTests[packet:PacketP[Object[Qualification,PlateReader]]]:= Module[{status,modelPacket,completed},

	{status,modelPacket}=Download[packet,{Status,Model[All]}];
	completed=MatchQ[status,Completed];

	{
		Test[
			"If testing AlphaScreen accuracy then AlphaScreenAbsorbanceAccuracyResults and AlphaScreenAccuracyAnalyses must exist upon completion:",
			{
				TrueQ[completed]&&!NullQ[Lookup[modelPacket,AlphaScreenAbsorbanceAccuracySamples]],
				MatchQ[
					Lookup[modelPacket,{AlphaScreenAbsorbanceAccuracyResults,AlphaScreenAbsorbanceAccuracyAnalyses}],
					{Except[{}],Except[{}]}
				]
			},
			Alternatives[
				{True,True},
				{False,_}
			]
		],

		Test[
			"If testing AlphaScreen accuracy then AlphaScreenLinearityResults and AlphaScreenLinearityAnalyses must exist upon completion:",
			{
				TrueQ[completed]&&!NullQ[Lookup[modelPacket,AlphaScreenLinearitySamples]],
				MatchQ[
					Lookup[modelPacket,{AlphaScreenLinearityResults,AlphaScreenLinearityAnalyses}],
					{Except[{}],Except[{}]}
				]
			},
			Alternatives[
				{True,True},
				{False,_}
			]
		],

		(* results should be informed when qualification is done *)
		RequiredWhenCompleted[packet, {QualificationNotebook}]
	}

];


(* ::Subsection::Closed:: *)
(*validQualificationDLSPlateReaderQTests*)


validQualificationDLSPlateReaderQTests[packet:PacketP[Object[Qualification,DLSPlateReader]]]:={
	(* the target should be of the right instrument type *)
	Test["The target must be a Object[Instrument,DLSPlateReader]:",
		Lookup[packet,Target],
		LinkP[Object[Instrument,DLSPlateReader]]
	],

	(*required fields*)
	NotNullFieldTest[
		packet,
		{
			LightScatteringValidationSamples,
			LightScatteringIndependentReplicates,
			LightScatteringWellReplicates
		}
	],

	(* required when completed *)
	RequiredWhenCompleted[packet,{LightScatteringQualificationProtocol}],

	(* results should be informed when qualification is done *)
	RequiredWhenCompleted[packet, {QualificationNotebook}]
};


(* ::Subsection::Closed:: *)
(*validQualificationPHMeterQTests*)


validQualificationpHMeterQTests[packet:PacketP[Object[Qualification,pHMeter]]]:= {

	(*required when completed*)
	RequiredWhenCompleted[packet,
		{
		Target, QualificationProtocols, QualificationSamples, MeasurementAccuracy, MeasurementPrecision, Slope, Offset
		}
	]
};

(* ::Subsection::Closed:: *)
(*validQualificationpHTitratorQTests*)


validQualificationpHTitratorQTests[packet:PacketP[Object[Qualification,pHTitrator]]]:= {

	(*required when completed*)
	RequiredWhenCompleted[packet,
		{
			Target, QualificationProtocols, QualificationSamples
		}
	]
};


(* ::Subsection::Closed:: *)
(*validQualificationPressureManifoldQTests*)


validQualificationPressureManifoldQTests[packet:PacketP[Object[Qualification,PressureManifold]]]:= {

};


(* ::Subsection::Closed:: *)
(*validQualificationProteinCapillaryElectrophoresisQTests*)


validQualificationProteinCapillaryElectrophoresisQTests[packet:PacketP[Object[Qualification,ProteinCapillaryElectrophoresis]]]:={

	(*required together*)
	AnyInformedTest[packet,
		{CIEFQualificationSamples,CESDSQualificationSamples}
	],
	RequiredTogetherTest[packet,
		{CESDSSamplePremadeMastermixes,CESDSSamplePremadeMastermixVolumes}
	],
	RequiredTogetherTest[packet,
		{CESDSStandards,CESDSStandardVolumes}
	],
	RequiredTogetherTest[packet,
		{CESDSStandardPremadeMastermixes,CESDSStandardPremadeMastermixVolumes}
	],
	RequiredTogetherTest[packet,
		{CESDSLadders,CESDSLadderVolumes}
	],
	RequiredTogetherTest[packet,
		{CESDSLadderPremadeMastermixes,CESDSLadderPremadeMastermixVolumes}
	]
};


(* ::Subsection::Closed:: *)
(*validQualificationqPCRQTests*)


validQualificationqPCRQTests[packet:PacketP[Object[Qualification,qPCR]]]:= {

	(* required fields *)
	NotNullFieldTest[
		packet,
		{QualificationSamples,QualificationStandards}
	]
};


(* ::Subsection::Closed:: *)
(*validQualificationDigitalPCRQTests*)


validQualificationDigitalPCRQTests[packet:PacketP[Object[Qualification,DigitalPCR]]]:= {

	(* required fields *)
	NotNullFieldTest[
		packet,
		{QualificationSamples,QualificationProbes}
	]
};


(* ::Subsection::Closed:: *)
(*validQualificationRamanSpectrometerQTests*)

validQualificationRamanSpectrometerQTests[packet:PacketP[Object[Qualification,RamanSpectrometer]]]:= {

};

(* ::Subsection::Closed:: *)
(*validQualificationRollerQTests*)


validQualificationRollerQTests[packet:PacketP[Object[Qualification,Roller]]]:= {

	RequiredWhenCompleted[packet,{FullyDissolved}]
};


(* ::Subsection::Closed:: *)
(*validQualificationSampleImagerQTests*)


validQualificationSampleImagerQTests[packet:PacketP[Object[Qualification,SampleImager]]]:= {

};


(* ::Subsection::Closed:: *)
(*validQualificationShakerQTests*)


validQualificationShakerQTests[packet:PacketP[Object[Qualification,Shaker]]]:= {

	(*required when completed*)
	RequiredWhenCompleted[packet,{FullyDissolved}]
};


(* ::Subsection::Closed:: *)
(*validQualificationSonicatorQTests*)


validQualificationSonicatorQTests[packet:PacketP[Object[Qualification,Sonicator]]]:= {

	(*required when completed*)
	RequiredWhenCompleted[packet,{FullyDissolved}]
};


(* ::Subsection:: *)
(*validQualificationSpargingApparatusQTests*)


validQualificationSpargingApparatusQTests[packet:PacketP[Object[Qualification,SpargingApparatus]]]:= {
	NotNullFieldTest[packet,
		{DissolvedOxygenMeter}
	],
	RequiredWhenCompleted[packet,{SamplePreparationProtocol,InitialDissolvedOxygenConcentration,FinalDissolvedOxygenConcentration}]
};



(* ::Subsection::Closed:: *)
(*validQualificationSpectrophotometerQTests*)


validQualificationSpectrophotometerQTests[packet:PacketP[Object[Qualification,Spectrophotometer]]]:= {

};


(* ::Subsection::Closed:: *)
(*validQualificationSFCQTests*)


validQualificationSFCQTests[packet:PacketP[Object[Qualification,SupercriticalFluidChromatography]]]:=Module[{status,modelPacket,completed},

	{status,modelPacket}=Download[packet,{Status,Model[All]}];

	completed=MatchQ[status,Completed];

	{
		(* Fields filled in from moment of creation*)
		NotNullFieldTest[packet,
			{InjectionVolumes,GradientMethods,Wavelengths,SamplePreparationPrimitives}
		],

		(* Tests that must pass regardless of the status of the qualification *)
		Test[
			"If testing fraction collection then FractionCollectionMethods and FractionCollectionTests must exist:",
			{
				NullQ[Lookup[modelPacket,FractionCollectionTestSample]],
				MemberQ[Lookup[packet,FractionCollectionMethods],ObjectP[Object[Method,FractionCollection]]],
				MatchQ[Lookup[packet,FractionCollectionTests],{}]
			},
			Alternatives[
				{True,False,True},
				{False,True,False}
			]
		],

		Test[
			"If testing flow linearity then FlowLinearityTests must exist:",
			{
				NullQ[Lookup[modelPacket,FlowLinearityTestSample]],
				MatchQ[Lookup[packet,FlowLinearityTests],{}]
			},
			Alternatives[
				{True,True},
				{False,False}
			]
		],

		Test[
			"If testing wavelength accuracy WavelengthAccuracyTests must exist:",
			{
				NullQ[Lookup[modelPacket,WavelengthAccuracyTestSample]],
				MatchQ[Lookup[packet,WavelengthAccuracyTests],{}]
			},
			Alternatives[
				{True,True},
				{False,False}
			]
		],

		Test[
			"If testing mass accuracy MassAccuracyTests must exist:",
			{
				NullQ[Lookup[modelPacket,MassAccuracyTestSample]],
				MatchQ[Lookup[packet,MassAccuracyTests],{}]
			},
			Alternatives[
				{True,True},
				{False,False}
			]
		],

		Test[
			"If testing flow linearity then FlowLinearityTests must exist:",
			{
				NullQ[Lookup[modelPacket,FlowLinearityTestSample]],
				MatchQ[Lookup[packet,FlowLinearityTests],{}]
			},
			Alternatives[
				{True,True},
				{False,False}
			]
		],

		Test[
			"If testing the autosampler then AutosamplerTests must exist:",
			{
				NullQ[Lookup[modelPacket,AutosamplerTestSample]],
				MatchQ[Lookup[packet,AutosamplerTests],{}]
			},
			Alternatives[
				{True,True},
				{False,False}
			]
		],

		Test[
			"If testing detector linearity then DetectorLinearityTests must exist:",
			{
				NullQ[Lookup[modelPacket,DetectorLinearityTestSample]],
				MatchQ[Lookup[packet,DetectorLinearityTests],{}]
			},
			Alternatives[
				{True,True},
				{False,False}
			]
		],

		Test[
			"If testing gradient proportioning then GradientProportioningTests must exist:",
			{
				NullQ[Lookup[modelPacket,GradientProportioningTestSample]],
				MatchQ[Lookup[packet,GradientProportioningTests],{}]
			},
			Alternatives[
				{True,True},
				{False,False}
			]
		],

		(* Tests that must pass when the qualification is complete *)
		Test[
			"If testing fraction collection then FractionAbsorbanceProtocol, MinAbsorbance, and FractionCollectionTestResults should be informed upon completion:",
			{
				TrueQ[completed]&&!NullQ[Lookup[modelPacket,FractionCollectionTestSample]],
				MatchQ[
					Lookup[packet,{MinAbsorbance,FractionAbsorbanceProtocol,FractionCollectionTestResults}],
					{Except[Null],Except[Null],Except[{}]}
				]
			},
			Alternatives[
				{True,True},
				{False,_}
			]
		],

		Test[
			"If testing flow linearity then FlowLinearityPeaksAnalyses, FlowLinearityTestResults, and FlowRateAccuracyTestResults must exist upon completion:",
			{
				TrueQ[completed]&&!NullQ[Lookup[modelPacket,FlowLinearityTestSample]],
				MatchQ[
					Lookup[modelPacket,{FlowLinearityPeaksAnalyses,FlowLinearityTestResults,FlowRateAccuracyTestResults}],
					ConstantArray[Except[{}|Null],3]
				]
			},
			Alternatives[
				{True,True},
				{False,_}
			]
		],

		Test[
			"If testing wavelength accuracy then WavelengthAccuracyPeaksAnalyses and WavelengthAccuracyTestResults must exist upon completion:",
			{
				TrueQ[completed]&&!NullQ[Lookup[modelPacket,WavelengthAccuracyTestSample]],
				MatchQ[
					Lookup[modelPacket,{WavelengthAccuracyPeaksAnalyses,WavelengthAccuracyTestResults}],
					{Except[{}],Except[{}]}
				]
			},
			Alternatives[
				{True,True},
				{False,_}
			]
		],

		Test[
			"If testing the autosampler then InjectionPrecisionPeaksAnalyses, MaxInjectionPrecisionPeakAreaRSD, InjectionPrecisionPassing, FlowRatePrecisionPassing, and FlowRatePrecisionPeaksAnalyses must exist upon completion:",
			{
				TrueQ[completed]&&!NullQ[Lookup[modelPacket,DetectorLinearityTestSample]],
				MatchQ[
					Lookup[modelPacket,{InjectionPrecisionPeaksAnalyses,MaxInjectionPrecisionPeakAreaRSD,InjectionPrecisionPassing,FlowRatePrecisionPassing,FlowRatePrecisionPeaksAnalyses}],
					{Except[{}],Except[Null],Except[Null],Except[Null],Except[{}]}
				]
			},
			Alternatives[
				{True,True},
				{False,_}
			]
		],

		Test[
			"If testing detector linearity then DetectorResponsePeaksAnalyses, DetectorResponseFactorResults and DetectorLinearityResults must exist upon completion:",
			{
				TrueQ[completed]&&!NullQ[Lookup[modelPacket,DetectorLinearityTestSample]],
				MatchQ[
					Lookup[modelPacket,{DetectorResponsePeaksAnalyses,DetectorResponseFactorResults,DetectorLinearityResults}],
					{Except[{}],Except[{}],Except[{}]}
				]
			},
			Alternatives[
				{True,True},
				{False,_}
			]
		],

		Test[
			"If testing wavelength accuracy then WavelengthAccuracyTestResults and WavelengthAccuracyPeaksAnalyses must exist upon completion:",
			{
				TrueQ[completed]&&!NullQ[Lookup[modelPacket,WavelengthAccuracyTestSample]],
				MatchQ[
					Lookup[modelPacket,{WavelengthAccuracyTestResults,WavelengthAccuracyPeaksAnalyses}],
					{Except[{}],Except[{}]}
				]
			},
			Alternatives[
				{True,True},
				{False,_}
			]
		],

		Test[
			"If testing mass accuracy then MassAccuracyTestResults and MassAccuracyPeaksAnalyses must exist upon completion:",
			{
				TrueQ[completed]&&!NullQ[Lookup[modelPacket,MassAccuracyTestSample]],
				MatchQ[
					Lookup[modelPacket,{MassAccuracyTestResults,MassAccuracyPeaksAnalyses}],
					{Except[{}],Except[{}]}
				]
			},
			Alternatives[
				{True,True},
				{False,_}
			]
		],

		(* results should be informed when qualification is done *)
		RequiredWhenCompleted[packet, {QualificationNotebook}]
	}
];



(* ::Subsection::Closed:: *)
(*validQualificationVacuumCentrifugeQTests*)


validQualificationVacuumCentrifugeQTests[packet:PacketP[Object[Qualification,VacuumCentrifuge]]]:= {

};

(* ::Subsection::Closed:: *)
(*validQualificationVacuumDegasserQTests*)


validQualificationVacuumDegasserQTests[packet:PacketP[Object[Qualification,VacuumDegasser]]]:= {

};


(* ::Subsection:: *)
(*validQualificationVacuumDegasserQTests*)


validQualificationVacuumDegasserQTests[packet:PacketP[Object[Qualification,VacuumDegasser]]]:= {
	NotNullFieldTest[packet,
		{DissolvedOxygenMeter}
	],
	RequiredWhenCompleted[packet,{SamplePreparationProtocol,InitialDissolvedOxygenConcentration,FinalDissolvedOxygenConcentration}]
};



(* ::Subsection::Closed:: *)
(*validQualificationViscometerQTests*)


validQualificationViscometerQTests[packet:PacketP[Object[Qualification,Viscometer]]]:= {

};


(* ::Subsection::Closed:: *)
(*validQualificationVortexQTests*)


validQualificationVortexQTests[packet:PacketP[Object[Qualification,Vortex]]]:= {

	(*required when completed*)
	RequiredWhenCompleted[packet,{FullyDissolved}]
};


(* ::Subsection::Closed:: *)
(*validQualificationWesternQTests*)


validQualificationWesternQTests[packet:PacketP[Object[Qualification,Western]]]:= {

	RequiredWhenCompleted[packet,{SamplePreparationProtocol,WesternQualificationProtocol}]
};



(* ::Subsection:: *)
(*validQualificationTensiometerQTests*)


validQualificationTensiometerQTests[packet:PacketP[Object[Qualification, Tensiometer]]]:= {
	RequiredTogetherTest[packet,{MinCriticalMicelleConcentration,MaxCriticalMicelleConcentration}],
	RequiredTogetherTest[packet,{NumberOfCycles,WettedLengthTolerance,MinRSquared}]
};

(* ::Subsection:: *)
(*ValidQualificationRefractometerQTests*)


validQualificationRefractometerQTests[packet:PacketP[Object[Qualification, Refractometer]]]:= {

};


(* ::Subsection::Closed:: *)
(*validQualificationBioLayerInterferometerQTests*)


validQualificationBioLayerInterferometerQTests[packet:PacketP[Object[Qualification, BioLayerInterferometer]]]:= {

};


(* ::Subsection::Closed:: *)
(*validQualificationCapillaryELISAQTests*)


validQualificationCapillaryELISAQTests[packet:PacketP[Object[Qualification, CapillaryELISA]]]:= {
	RequiredWhenCompleted[packet,{TestCartridge,VerificationDataFilePath,VerificationDataFileName,VerificationDataFile}]
};


(* ::Subsection:: *)
(*validQualificationVentilationQTests*)


validQualificationVentilationQTests[packet:PacketP[Object[Qualification,Ventilation]]]:={
	(* required fields *)
	NotNullFieldTest[
		packet,
		{Anemometer, QualifiedParts}
	],
	RequiredWhenCompleted[
		packet,
		{VentilationAirVelocity}
	]
};

(* ::Subsection::Closed:: *)
(*validQualificationMeasureLiquidHandlerDeckAccuracyQTests*)


validQualificationMeasureLiquidHandlerDeckAccuracyQTests[packet:PacketP[Object[Qualification,MeasureLiquidHandlerDeckAccuracy]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,Target,Author,NumberOfPositions,SBSCalibrationTool,PlatePlacements,NumberOfWells
		}
	]
};



(* ::Subsection::Closed:: *)
(*validQualificationMeasureLiquidHandlerDevicePrecisionQTests*)

validQualificationMeasureLiquidHandlerDevicePrecisionQTests[packet:PacketP[Object[Qualification,MeasureLiquidHandlerDevicePrecision]]]:={

	(* Fields filled in *)
	NotNullFieldTest[packet,
		{
			Model,
			Target,
			Author,
			ChannelCalibrationTool,
			ManualAlignmentFilePath
		}
	],

	RequiredWhenCompleted[
		packet,
		{
			ChannelAccuracyFile,
			ChannelAccuracies,
			TraceFile,
			FinalSettingsFile,
			InitialSettingsFile
		}
	]
};



(* ::Subsection:: *)
(*validQualificationVerifyHamiltonLabwareQTests*)


validQualificationVerifyHamiltonLabwareQTests[packet:PacketP[Object[Qualification, VerifyHamiltonLabware]]]:= {
	(* required fields *)
	NotNullFieldTest[
		packet,
		{Containers,Solvent,Tips,Lid,Align}
	],
	RequiredWhenCompleted[
		packet,
		{VerificationModels,VerifiedLiquidHandler,VerificationResult}
	]
};
(* ::Subsection::Closed:: *)
(*validQualificationInteractiveTrainingQTests*)

validQualificationInteractiveTrainingQTests[packet:PacketP[Object[Qualification,InteractiveTraining]]]:={

	(* Shared fields not null *)
	NotNullFieldTest[packet,{
		Target,
		TrainingTasks,
		Operator
	}],

	(* Shared fields to be Null - a lot as we're not running an experiment in the lab *)
	NullFieldTest[packet,{
		Aliquot,
		AliquotAmounts,
		AliquotContainers,
		AliquotLiquidHandlingScale,
		AliquotMasses,
		AliquotProtocols,
		AliquotSamplePreparation,
		AliquotSamples,
		AliquotSamplesPrices,
		AliquotStorage,
		AliquotVolumes,
		ArgonPressureLog,
		AssayBuffer,
		AssayBuffers,
		AssayVolumes,
		BufferDiluent,
		BufferDiluents,
		BufferDilutionFactor,
		BufferDilutionFactors,
		Centrifuge,
		CentrifugeSamplePreparation,
		CO2PressureLog,
		ConcentratedBuffer,
		ConcentratedBuffers,
		ConsolidateAliquots,
		ContainersIn,
		ContainersOut,
		CurrentInstruments,
		Data,
		DispenserContainers,
		EnvironmentalData,
		FilteredSamples,
		FilterSamplePreparation,
		GasSources,
		HazardousWaste,
		ImageSample,
		ImagingSamples,
		IncubateSamplePreparation,
		InitialArgonPressure,
		InitialCO2Pressure,
		InitialNitrogenPressure,
		LiquidHandlingLogs,
		LiquidHandlingLogPaths,
		Measure,
		MeasureVolume,
		MeasureWeight,
		NitrogenPressureLog,
		NestedIndexMatchingCentrifugeSamplePreparation,
		NestedIndexMatchingIncubateSamplePreparation,
		PooledSamplesIn,
		PostProcessingProtocols,
		PreparatoryUnitOperations,
		PreparedSamples,
		PurchasedItems,
		PurchasedItemsPrices,
		SamplePreparationProtocols,
		SamplesIn,
		SamplesInStorage,
		SamplesOut,
		SamplesOutPrices,
		SamplesOutStorage,
		SaveAliquots,
		SecondaryWasteWeight,
		SecondaryWasteWeightTare,
		ShippingMaterials,
		Storage,
		StoragePrice,
		StoragePrices,
		StoredObjects,
		TargetConcentrations,
		TargetContainer,
		TargetSampleGroupings,
		TransportChilledDevice,
		TransportChilledTemperature,
		TransportWarmedDevice,
		TransportWarmedTemperature,
		VolumeCheckSamplePrep,
		VolumeMeasurementSamples,
		WasteGenerated,
		WasteWeight,
		WasteWeightTare,
		WeightMeasurementSamples,
		WorkingContainers,
		WorkingSamples
	}],

	(* Data required when the protocol is finished *)
	RequiredWhenCompleted[packet,{
		Responses
	}],

	(* Duplicate questions are not currently supported because of grading *)
	Test["There are no duplicate questions in the training tasks:",
		DuplicateFreeQ[Cases[Lookup[packet,TrainingTasks],ObjectP[Model[Question]]],MatchQ[#1,ObjectP[#2]]&],
		True
	]
};



(* ::Subsection:: *)
(*Test Registration *)


registerValidQTestFunction[Object[Qualification],validQualificationQTests];
registerValidQTestFunction[Object[Qualification, AcousticLiquidHandler],validQualificationAcousticLiquidHandlerQTests];
registerValidQTestFunction[Object[Qualification, MeasureLiquidHandlerDevicePrecision], validQualificationMeasureLiquidHandlerDevicePrecisionQTests];
registerValidQTestFunction[Object[Qualification, Autoclave],validQualificationAutoclaveQTests];
registerValidQTestFunction[Object[Qualification, BiosafetyCabinet],validQualificationBiosafetyCabinetQTests];
registerValidQTestFunction[Object[Qualification, FlashChromatography],validQualificationFlashChromatographyQTests];
registerValidQTestFunction[Object[Qualification, BottleRoller],validQualificationBottleRollerQTests];
registerValidQTestFunction[Object[Qualification, Balance],validQualificationBalanceQTests];
registerValidQTestFunction[Object[Qualification, CapillaryELISA],validQualificationCapillaryELISAQTests];
registerValidQTestFunction[Object[Qualification, Centrifuge],validQualificationCentrifugeQTests];
registerValidQTestFunction[Object[Qualification, ColonyHandler],validQualificationColonyHandlerQTests];
registerValidQTestFunction[Object[Qualification, ConductivityMeter],validQualificationConductivityMeterQTests];
registerValidQTestFunction[Object[Qualification, ControlledRateFreezer],validQualificationControlledRateFreezerQTests];
registerValidQTestFunction[Object[Qualification, CoulterCounter],validQualificationCoulterCounterQTests];
registerValidQTestFunction[Object[Qualification, CrossFlowFiltration],validQualificationCrossFlowFiltrationQTests];
registerValidQTestFunction[Object[Qualification, CryogenicFreezer],validQualificationCryogenicFreezerQTests];
registerValidQTestFunction[Object[Qualification, CrystalIncubator],validQualificationCrystalIncubatorQTests];
registerValidQTestFunction[Object[Qualification, Desiccator],validQualificationDesiccatorQTests];
registerValidQTestFunction[Object[Qualification, Dewar],validQualificationDewarQTests];
registerValidQTestFunction[Object[Qualification, Dialyzer],validQualificationDialyzerQTests];
registerValidQTestFunction[Object[Qualification, DifferentialScanningCalorimeter],validQualificationDifferentialScanningCalorimeterQTests];
registerValidQTestFunction[Object[Qualification, Diffractometer],validQualificationDiffractometerQTests];
registerValidQTestFunction[Object[Qualification, Disruptor],validQualificationDisruptorQTests];
registerValidQTestFunction[Object[Qualification, DissolvedOxygenMeter],validQualificationDissolvedOxygenMeterQTests];
registerValidQTestFunction[Object[Qualification, DNASynthesizer],validQualificationDNASynthesizerQTests];
registerValidQTestFunction[Object[Qualification, DynamicFoamAnalyzer],validQualificationDynamicFoamAnalyzerQTests];
registerValidQTestFunction[Object[Qualification, ElectrochemicalReactor],validQualificationElectrochemicalReactorQTests];
registerValidQTestFunction[Object[Qualification, FragmentAnalyzer],validQualificationFragmentAnalyzerQTests];
registerValidQTestFunction[Object[Qualification, Electrophoresis],validQualificationElectrophoresisQTests];
registerValidQTestFunction[Object[Qualification, EngineBenchmark],validQualificationEngineBenchmarkQTests];
registerValidQTestFunction[Object[Qualification, Evaporator],validQualificationEvaporatorQTests];
registerValidQTestFunction[Object[Qualification, FilterBlock],validQualificationFilterBlockQTests];
registerValidQTestFunction[Object[Qualification, FilterHousing],validQualificationFilterHousingQTests];
registerValidQTestFunction[Object[Qualification, FreezePumpThawApparatus],validQualificationFreezePumpThawApparatusQTests];
registerValidQTestFunction[Object[Qualification, FumeHood],validQualificationFumeHoodQTests];
registerValidQTestFunction[Object[Qualification, GasChromatography],validQualificationGasChromatographyQTests];
registerValidQTestFunction[Object[Qualification, Grinder],validQualificationGrinderQTests];
registerValidQTestFunction[Object[Qualification, HeatBlock],validQualificationHeatBlockQTests];
registerValidQTestFunction[Object[Qualification, Homogenizer],validQualificationHomogenizerQTests];
registerValidQTestFunction[Object[Qualification, HPLC],validQualificationHPLCQTests];
registerValidQTestFunction[Object[Qualification, Incubator],validQualificationIncubatorQTests];
registerValidQTestFunction[Object[Qualification, IonChromatography],validQualificationIonChromatographyQTests];
registerValidQTestFunction[Object[Qualification, LCMS],validQualificationLCMSQTests];
registerValidQTestFunction[Object[Qualification, LiquidHandler],validQualificationLiquidHandlerQTests];
registerValidQTestFunction[Object[Qualification, LiquidLevelDetection],validQualificationLiquidLevelDetectionQTests];
registerValidQTestFunction[Object[Qualification, Lyophilizer],validQualificationLyophilizerQTests];
registerValidQTestFunction[Object[Qualification, MassSpectrometer],validQualificationMassSpectrometerQTests];
registerValidQTestFunction[Object[Qualification, MeltingPointApparatus],validQualificationMeltingPointApparatusQTests];
registerValidQTestFunction[Object[Qualification, Microscope],validQualificationMicroscopeQTests];
registerValidQTestFunction[Object[Qualification, MultimodeSpectrophotometer],validQualificationMultimodeSpectrophotometerQTests];
registerValidQTestFunction[Object[Qualification, OverheadStirrer],validQualificationOverheadStirrerQTests];
registerValidQTestFunction[Object[Qualification, Nutator],validQualificationNutatorQTests];
registerValidQTestFunction[Object[Qualification, Osmometer],validQualificationOsmometerQTests];
registerValidQTestFunction[Object[Qualification, PCR],validQualificationPCRQTests];
registerValidQTestFunction[Object[Qualification, PeristalticPump],validQualificationPeristalticPumpQTests];
registerValidQTestFunction[Object[Qualification, pHMeter],validQualificationpHMeterQTests];
registerValidQTestFunction[Object[Qualification, pHTitrator],validQualificationpHTitratorQTests];
registerValidQTestFunction[Object[Qualification, PipettingLinearity],validQualificationPipettingLinearityQTests];
registerValidQTestFunction[Object[Qualification, PlateImager],validQualificationPlateImagerQTests];
registerValidQTestFunction[Object[Qualification, PlateReader],validQualificationPlateReaderQTests];
registerValidQTestFunction[Object[Qualification, DLSPlateReader], validQualificationDLSPlateReaderQTests];
registerValidQTestFunction[Object[Qualification, PlateSealer],validQualificationPlateSealerQTests];
registerValidQTestFunction[Object[Qualification, PressureManifold],validQualificationPressureManifoldQTests];
registerValidQTestFunction[Object[Qualification, ProteinCapillaryElectrophoresis],validQualificationProteinCapillaryElectrophoresisQTests];
registerValidQTestFunction[Object[Qualification, qPCR],validQualificationqPCRQTests];
registerValidQTestFunction[Object[Qualification, DigitalPCR],validQualificationDigitalPCRQTests];
registerValidQTestFunction[Object[Qualification, RamanSpectrometer], validQualificationRamanSpectrometerQTests];
registerValidQTestFunction[Object[Qualification, Roller],validQualificationRollerQTests];
registerValidQTestFunction[Object[Qualification, SampleImager],validQualificationSampleImagerQTests];
registerValidQTestFunction[Object[Qualification, Shaker],validQualificationShakerQTests];
registerValidQTestFunction[Object[Qualification, Sonicator],validQualificationSonicatorQTests];
registerValidQTestFunction[Object[Qualification, SpargingApparatus],validQualificationSpargingApparatusQTests];
registerValidQTestFunction[Object[Qualification, Spectrophotometer],validQualificationSpectrophotometerQTests];
registerValidQTestFunction[Object[Qualification, SupercriticalFluidChromatography],validQualificationSFCQTests];
registerValidQTestFunction[Object[Qualification, VacuumCentrifuge],validQualificationVacuumCentrifugeQTests];
registerValidQTestFunction[Object[Qualification, VacuumDegasser],validQualificationVacuumDegasserQTests];
registerValidQTestFunction[Object[Qualification, Ventilation],validQualificationVentilationQTests];
registerValidQTestFunction[Object[Qualification, Viscometer],validQualificationViscometerQTests];
registerValidQTestFunction[Object[Qualification, Vortex],validQualificationVortexQTests];
registerValidQTestFunction[Object[Qualification, WaterPurifier],validQualificationWaterPurifierQTests];
registerValidQTestFunction[Object[Qualification, Western],validQualificationWesternQTests];
registerValidQTestFunction[Object[Qualification, Tensiometer], validQualificationTensiometerQTests];
registerValidQTestFunction[Object[Qualification, BioLayerInterferometer],validQualificationBioLayerInterferometerQTests];
registerValidQTestFunction[Object[Qualification, CapillaryELISA],validQualificationCapillaryELISAQTests];
registerValidQTestFunction[Object[Qualification, ELISA],validQualificationELISAQTests];
registerValidQTestFunction[Object[Qualification, Refractometer], validQualificationRefractometerQTests];
registerValidQTestFunction[Object[Qualification, MeasureLiquidHandlerDeckAccuracy],validQualificationMeasureLiquidHandlerDeckAccuracyQTests];
registerValidQTestFunction[Object[Qualification, VerifyHamiltonLabware],validQualificationVerifyHamiltonLabwareQTests];
registerValidQTestFunction[Object[Qualification, InteractiveTraining],validQualificationInteractiveTrainingQTests];

