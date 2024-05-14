(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*validProtocolQTests*)


validProtocolQTests[packet:ObjectP[Object[Protocol]]]:={


	(* SOURCE *)
	UniquelyInformedTest[packet,{
		Author,
		ParentProtocol
	}],

	NotNullFieldTest[packet,{
	(* GENERAL *)
		Status,
		ResolvedOptions,
	(* DATES *)
		DateCreated
	}],

	(* SITE *)
	RequiredWhenCompleted[packet, {Site}],


	(* DATES *)
	Test["DateConfirmed should be entered when the protocol has been confirmed to run in the lab but has not yet entered the processing queue:",
		Flatten[{Lookup[packet, Status], ContainsOnly[Lookup[packet, StatusLog][[All, 2]], {InCart,Canceled}], Lookup[packet,{OperationStatus,DateConfirmed}]}],
		Alternatives[
			{InCart,_,_,Null},
			(* need to confirm a protocol for it to be in the backlog or awaiting materials*)
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

	Test["DateEnqueued should be entered when the protocol has been confirmed to run in the lab and has entered the processing queue:",
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

	Test["DateStarted should be entered when the protocol has been started in the lab:",
		Lookup[packet, {Status,OperationStatus,DateStarted}],
		Alternatives[
			{InCart,_,_},
			{Canceled,_,_},
			{Processing, Alternatives[OperatorProcessing, InstrumentProcessing, OperatorReady, Troubleshooting], Except[Null]},
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

	Test["DateStarted should not be populated when the protocol has not been started in the lab:",
		Lookup[packet, {Status,OperationStatus,DateStarted}],
		Alternatives[
			{InCart,_,Null},
			{Canceled,_,Null},
			{Except[InCart|Canceled],_,_}
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

	Test["If not Null, DateCreated <= DateConfirmed <= DateEnqueued <= DateStarted <= DateCompleted:",
		LessEqual@@DeleteCases[Lookup[packet,{DateCreated,DateConfirmed,DateEnqueued,DateStarted,DateCompleted}],Null],
		True
	],

	(* Note DateCanceled can be before or after DateStarted... so cannot be in the same test *)
	Test["If not Null DateConfirmed <= DateEnqueued <= DateCanceled <= DateCompleted:",
		LessEqual@@DeleteCases[Lookup[packet,{DateConfirmed,DateEnqueued,DateCanceled,DateCompleted}],Null],
		True
	],

	(* CHILD/PARENT PROTOCOLS - TESTED FROM CHILD POV *)
	Test["If the protocol is OperationStatus->Troubleshooting, its parent protocol must be OperationStatus->Troubleshooting as well:",
		{Lookup[packet, ParentProtocol], Download[Lookup[packet, ParentProtocol], OperationStatus], Lookup[packet, OperationStatus]},
		Alternatives[
			{ObjectP[], Troubleshooting ,Troubleshooting},
			{Null, _ ,Troubleshooting},
			{_, _, Except[Troubleshooting]}
		]
	],

	Test["If the protocol has a ParentProtocol and the ParentProtocol is finished (Status-> Canceled, Completed, or Aborted), this protocol must also be finished (Status-> Canceled, Completed, or Aborted):",
		{Download[Lookup[packet, ParentProtocol], Status], Lookup[packet, Status]},
		Alternatives[
			{Canceled|Completed|Aborted,Canceled|Completed|Aborted},
			{Except[Canceled|Completed|Aborted],_}
		]
	],

	Test["If the protocol has a ParentProtocol and the ParentProtocol is not started (Status-> InCart), this protocol must also be not started (Status-> InCart, or Canceled):",
		{Download[Lookup[packet, ParentProtocol], Status],Lookup[packet, Status]},
		Alternatives[
			{InCart,InCart|Canceled},
			{Except[InCart],_}
		]
	],


	(* REPLACEMENT PROTOCOL*)
	Test[
		"A replacement protocol may only be specified if the status of this protocol is Aborted:",
		Lookup[packet, {Status, ReplacementProtocol}],
		{Except[Aborted], NullP} | {Aborted, _}
	],

	(* EXECUTION FIELDS *)
	Test["If the protocol has not been started, the following fields must be Null: Data, EnvironmentalData, and Figures:",
		Lookup[packet, {Status,Data, EnvironmentalData}],
		Alternatives[
			{Alternatives[InCart,Canceled],{},{}},
			{Except[Alternatives[InCart,Canceled]],_,_}
		]
	],

	Test["ActiveCart is not informed if Status is Completed or Aborted:",
		Lookup[packet,{Status,ActiveCart}],
		{Completed|Aborted,NullP}|{Except[Completed|Aborted],_}
	],

	Test["CurrentOperator is not informed if Status is Completed or Aborted:",
		Lookup[packet,{Status,CurrentOperator}],
		{Completed|Aborted,NullP}|{Except[Completed|Aborted],_}
	],

	Test[
		"CurrentOperator is not informed if Status is InCart:",
		Lookup[packet, {Status, CurrentOperator}],
		{InCart, NullP} | {Except[InCart], _}
	],

	(* OPERATION STATUS *)
	Test["If the protocol Status is Processing, then OperationStatus is OperatorProcessing, InstrumentProcessing, OperatorReady, Troubleshooting. If the protocol Status is not running, OperationStatus must be Null or None:",
		Lookup[packet,{Status,OperationStatus}],
		Alternatives[
			{Processing,OperatorStart|OperatorProcessing|InstrumentProcessing|OperatorReady|Troubleshooting},
			{Except[Processing],NullP|None}
		]
	],

	(* TROUBLESHOOTING *)
	Test["Troubleshooting fields are not populated if a protocol is not currently executing or it has been started but is ShippingMaterials:",
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

	(* INSTRUMENTS & RESOURCES *)
	Test["If the protocol has not been started, Resources and CurrentInstruments must be empty:",
		Lookup[packet, {Status,Resources,CurrentInstruments}],
		Alternatives[
			{Alternatives[InCart,Canceled],{},{}},
			{Except[Alternatives[InCart,Canceled]],___}
		]
	],

	Test["If the protocol has been completed Resources and CurrentInstruments must be empty:",
		Lookup[packet, {Status,Resources,CurrentInstruments}],
		Alternatives[
			{Alternatives[Completed,Aborted],{},{}},
			{Except[Alternatives[Completed,Aborted]],___}
		]
	],

	(* QUEUED SAMPLES *)
	Test["If the protocol has not been started, sample queue fields (VolumeMeasurementSamples, ImagingSamples, WeightMeasurementSamples) must be empty:",
		Lookup[packet,{Status,VolumeMeasurementSamples,ImagingSamples,WeightMeasurementSamples}],
		Alternatives[
			{Alternatives[InCart,Canceled],{},{},{}},
			{Except[Alternatives[InCart,Canceled]],___}
		]
	],

	Test["If the protocol has been completed, sample queue fields (VolumeMeasurementSamples, ImagingSamples, WeightMeasurementSamples) must be empty:",
		Lookup[packet,{Status,VolumeMeasurementSamples,ImagingSamples,WeightMeasurementSamples}],
		Alternatives[
			{Alternatives[Completed,Aborted],{},{},{}},
			{Except[Alternatives[Completed,Aborted]],___}
		]
	],

	(* ENVIRONMENTAL DATA *)
	RequiredWhenCompleted[packet,{EnvironmentalData}],

	(* OWNERSHIP *)

	(* we don't allow for any public SamplesOut if the protocol is linked to a Notebook *)
	(* we exclude MeasureWeight protocols from this since these have SamplesOut whenever there was a transfer container, however the samples should stay public since identical to SampelsIn *)
	Test["If the protocol has SamplesOut and has a notebook, all SamplesOut that have a Product that is not marked as NotForSale must have a notebook as well:",
		If[!NullQ[Lookup[packet, Notebook]]&&MatchQ[Lookup[packet, SamplesOut],{ObjectP[]..}]&&!MatchQ[Lookup[packet,Type],Object[Protocol,MeasureWeight]],
			MatchQ[PickList[Download[Lookup[packet, SamplesOut], Notebook[Object]], Download[Lookup[packet, SamplesOut], Product[NotForSale]], Except[True]],{ObjectP[Object[LaboratoryNotebook]]...}],
			True
		],
		True
	],

	(* Notebook of the SamplesOut has to be identical to the notebook of the protocol *)
	Test["If the protocol has SamplesOut, then the notebook of all SamplesOut that have a Product that is not marked as NotForSale matches the notebook of the protocol:",
		If[MatchQ[Lookup[packet, SamplesOut],{ObjectP[]..}]&&!NullQ[Lookup[packet, Notebook]]&&!MatchQ[Lookup[packet,Type],Object[Protocol,MeasureWeight]],
			MatchQ[DeleteDuplicates[Download[PickList[Download[Download[Lookup[packet, SamplesOut], Notebook], Object], Download[Lookup[packet, SamplesOut], {Product, Product[NotForSale]}], {ObjectP[], Except[True]}],Object]],{Download[Lookup[packet,Notebook],Object]}|{}],
			True
		],
		True
	],

	(* STORAGE CONDITIONS *)

	(* SamplesInStorage field, if populated, needs to be index matching with PooledSamplesIn if that is populated; otherwise, index matching with SamplesIn *)
	Test["If SamplesInStorage and PooledSamplesIn are populated, they are the same length as each other; if SamplesInStorage is populated but PooledSamplesIn is not, it is the same length as SamplesIn:",
		With[{storage = Lookup[packet, SamplesInStorage], pooledSamplesIn = Lookup[packet, PooledSamplesIn], samplesIn = Lookup[packet, SamplesIn]},
			Which[
				MatchQ[storage, {(SampleStorageTypeP|Disposal|Null)..}] && MatchQ[pooledSamplesIn, {{ObjectP[]..}..}], Length[storage] == Length[pooledSamplesIn],
				MatchQ[storage, {(SampleStorageTypeP|Disposal|Null)..}], Length[storage] == Length[samplesIn],
				True, True
			]
		],
		True
	]


};


(* ::Subsection::Closed:: *)
(*validProtocolAbsorbanceIntensityQTests*)


validProtocolAbsorbanceIntensityQTests[packet:PacketP[Object[Protocol,AbsorbanceIntensity]]]:={

	NullFieldTest[packet,{
		SamplesOut,
		ContainersOut,
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	(* shared fields not null *)
	RequiredWhenCompleted[packet,{Data,SamplesIn}],

	(* unique fields not null *)
	NotNullFieldTest[packet,{
		ContainersIn,
		Instrument
	}],

	ResolvedWhenCompleted[packet,{
		Instrument
	}],

	Test[
		"Unless the protocol is doing preparatory primitives, Samples In should be Informed if the Protocol is not Canceled or Aborted:",
		Lookup[packet,{SamplesIn,PreparatoryUnitOperations,Status}],
		{{ObjectP[Object[Sample]]..},_,_}|{{(ObjectP[{Model[Sample],Object[Sample]}]|Null)..},{Except[Null]..},_}|{_,_,Canceled|Aborted}
	]
};


validProtocolAbsorbanceKineticsQTests[packet:PacketP[Object[Protocol,AbsorbanceKinetics]]]:={

	NullFieldTest[packet,{
		SamplesOut,
		ContainersOut,
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	(* shared fields not null *)
	RequiredWhenCompleted[packet,{Data,MethodFilePath,SamplesIn}],

	(* unique fields not null *)
	NotNullFieldTest[packet,{
		ContainersIn,
		Instrument,
		RunTime,
		ReadOrder,
		NumberOfReadings,
		ReadDirection
	}],

	(* MinWavelength < MaxWavelength *)
	FieldComparisonTest[packet,{MinWavelength,MaxWavelength},Less],

	(* Either a range is fully specified or a set of discrete wavelengths is provided *)
	RequiredTogetherTest[packet,{MinWavelength,MaxWavelength}],
	UniquelyInformedTest[packet,{MinWavelength,Wavelengths}],

	(* Check groups of fields are all set or all null. Check field groups for temperature, mixing, moat and injections *)
	RequiredTogetherTest[packet,{PlateReaderMixRate,PlateReaderMixTime,PlateReaderMixSchedule,PlateReaderMixMode}],
	RequiredTogetherTest[packet,{MoatSize,MoatBuffer,MoatVolume}],
	RequiredTogetherTest[packet,{PrimaryInjections,PrimaryInjectionFlowRate,InjectionSample,SolventWasteContainer,PrimaryPreppingSolvent,SecondaryPreppingSolvent,PrimaryFlushingSolvent,SecondaryFlushingSolvent}],

	(* Instrument will be fulfilled after protocol has completed *)
	ResolvedWhenCompleted[packet,{Instrument}],

	Test["If the protocol is completed, the length of Data should be equal to the length of SamplesIn:",
		{Status,Length[DeleteCases[Lookup[packet,Data],Null]]},
		{Completed,Length[DeleteCases[Lookup[packet,SamplesIn],Null]]}|{Except[Completed],_}
	],

	Test[
		"Unless the protocol is doing preparatory primitives, Samples In should be Informed if the Protocol is not Canceled or Aborted:",
		Lookup[packet,{SamplesIn,PreparatoryUnitOperations,Status}],
		{{ObjectP[Object[Sample]]..},_,_}|{{(ObjectP[{Model[Sample],Object[Sample]}]|Null)..},{Except[Null]..},_}|{_,_,Canceled|Aborted}
	]
};


(* ::Subsection::Closed:: *)
(*validProtocolAbsorbanceSpectroscopyQTests*)


validProtocolAbsorbanceSpectroscopyQTests[packet:PacketP[Object[Protocol,AbsorbanceSpectroscopy]]]:={

	NullFieldTest[packet,{
		SamplesOut,
		ContainersOut,
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

(* shared fields not null *)
	RequiredWhenCompleted[packet,{Data,SamplesIn}],

	(* unique fields not null *)
	NotNullFieldTest[packet,{
		ContainersIn,
		Instrument
	}],

	ResolvedWhenCompleted[packet,{
		Instrument
	}]
};


(* ::Subsection::Closed:: *)
(*validProtocolAdjustpHQTests*)


validProtocolAdjustpHQTests[packet:PacketP[Object[Protocol,AdjustpH]]]:={

	(* shared fields not null *)
	NotNullFieldTest[
		packet,
		{
			ContainersIn,
			ContainersOut,
			MinpH,
			MaxpH,
			pHMeter,
			MaxAdditionVolume,
			MaxNumberOfCycles
		}
	],

	NullFieldTest[
		packet,
		{
			NitrogenPressureLog,
			CO2PressureLog,
			ArgonPressureLog,
			InitialNitrogenPressure,
			InitialArgonPressure,
			InitialCO2Pressure
		}
	],

	(* UPON COMPLETION *)
	RequiredWhenCompleted[
		packet,
		{
			Data
		}
	]

};


(* ::Subsection::Closed:: *)
(*validProtocolUVMeltingQTests*)


validProtocolUVMeltingQTests[packet:PacketP[Object[Protocol,UVMelting]]]:={

	NullFieldTest[packet,{
		CO2PressureLog,
		ArgonPressureLog,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	NotNullFieldTest[packet,{
		(*shared*)
		ContainersIn,
		(*specific*)
		PooledSamplesIn,
		Cuvettes,
		Instrument,
		EquilibrationTime,
		NumberOfCycles,
		MinTemperature,
		MaxTemperature,
		TemperatureResolution,
		TemperatureRampOrder,
		TemperatureMonitor,
		CuvetteRack,
		BlankMeasurement,
		ThermocyclingTime (* TODO only there in funtopia,
		BlowGun,
		NestedIndexMatchingMixSamplePreparation,
		NestedIndexMatchingIncubateSamplePreparation *)
	}],

	(* If BlankMeasurement -> True, BlankManipulation is filled in after compile *)
	If[
		TrueQ[Lookup[packet,BlankMeasurement]],
		RequiredAfterCheckpoint[packet,"Preparing Samples",{BlankManipulation}],
		{}
	],

	(* Temperature settings *)
	FieldComparisonTest[packet,{MinTemperature,MaxTemperature},LessEqual],

	(* Either Wavelength or MinWavelength and MaxWavelength are informed *)
	RequiredTogetherTest[packet,{MinWavelength,MaxWavelength}],
	UniquelyInformedTest[packet,{Wavelength,MinWavelength}],
	UniquelyInformedTest[packet,{Wavelength,MaxWavelength}],

	(* Fields that get filled in during procedure *)
	RequiredAfterCheckpoint[packet,"Preparing Samples",
		{
			DataFileName,
			DataFilePath,
			MethodFilePath,
			PoolingManipulation,
			ContainerPlacements
		}
	],

	(* Cuvette-index-matched fields are the same length *)
	Test["PooledSamplesIn matches Cuvettes in length:",
		Length[Lookup[packet,PooledSamplesIn]],
		Length[Lookup[packet,Cuvettes]]
	],
	Test["If populated, AssayBufferVolumes matches Cuvettes in length:",
		Length[DeleteCases[Lookup[packet,AssayBufferVolumes],Null]],
		Length[Lookup[packet,Cuvettes]] | 0
	],
	Test["If populated, ConcentratedBufferVolumes matches Cuvettes in length:",
		Length[DeleteCases[Lookup[packet,ConcentratedBufferVolumes],Null]],
		Length[Lookup[packet,Cuvettes]] | 0
	],
	Test["If populated, BufferDiluentVolumes matches Cuvettes in length:",
		Length[DeleteCases[Lookup[packet,BufferDiluentVolumes],Null]],
		Length[Lookup[packet,Cuvettes]] | 0
	],

	(* UPON COMPLETION *)
	RequiredWhenCompleted[packet,{Data,SamplesIn}],
	RequiredWhenCompleted[packet,{DataFile}],
	RequiredWhenCompleted[packet,{InitialNitrogenPressure,NitrogenPressureLog}],
	ResolvedWhenCompleted[packet,{Instrument}],

	(* AbsorbanceData needs to be informed if the protocol is completed after the day this field got introduced *)
	Test[
		"AbsorbanceData must be informed upon completion of the protocol:",
		If[MatchQ[Lookup[packet,Status],Completed],
			If[Lookup[packet,DateCompleted]>DateObject[{2019,5,17},"Day","Gregorian",-7.`],
				!NullQ[Lookup[packet, AbsorbanceData]],
				True
			],
			True
		],
		True
	],

	Test[
		"Unless the protocol is doing preparatory primitives, Samples In should be Informed if the Protocol is not Canceled or Aborted:",
		Lookup[packet,{SamplesIn,PreparatoryUnitOperations,Status}],
		{{ObjectP[Object[Sample]]..},_,_}|{{(ObjectP[{Model[Sample],Object[Sample]}]|Null)..},{Except[Null]..},_}|{_,_,Canceled|Aborted}
	]

};


(* ::Subsection::Closed:: *)
(*validProtocolAbsorbanceQuantificationQTests*)


validProtocolAbsorbanceQuantificationQTests[packet:PacketP[Object[Protocol,AbsorbanceQuantification]]]:={

	NullFieldTest[packet,{
		SamplesOut,
		ContainersOut,
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],


	(* Unique fields that should never be Null *)
	NotNullFieldTest[packet,{SamplesIn,ContainersIn,Annealing}],

	(* --- The following fields are informed only when Aliquot ->Null or True--- *)
	Test["AbsorbanceQuantificationProgram is informed when Aliquot -> True:",
		If[!MatchQ[Lookup[packet,Aliquot],False],
			MatchQ[Lookup[packet,AbsorbanceQuantificationProgram],Except[NullP|{}]],
			True
		],
		True
	],

	Test["LiquidHandler is informed when Aliquot -> True:",
		If[!MatchQ[Lookup[packet,Aliquot],False],
			MatchQ[Lookup[packet,LiquidHandler],Except[NullP|{}]],
			True
		],
		True
	],

	Test["Buffer is informed when Aliquot -> True:",
		If[!MatchQ[Lookup[packet,Aliquot],False],
			MatchQ[Lookup[packet,Buffer],Except[NullP|{}]],
			True
		],
		True
	],

	Test["BufferDiluent is informed when Aliquot -> True:",
		If[!MatchQ[Lookup[packet,Aliquot],False],
			MatchQ[Lookup[packet,BufferDiluent],Except[NullP|{}]],
			True
		],
		True
	],

	Test["BufferVolume is informed when Aliquot -> True:",
		If[!MatchQ[Lookup[packet,Aliquot],False],
			MatchQ[Lookup[packet,BufferVolume],Except[NullP|{}]],
			True
		],
		True
	],

	Test["TotalVolume is informed when Aliquot -> True:",
		If[!MatchQ[Lookup[packet,Aliquot],False],
			MatchQ[Lookup[packet,TotalVolume],Except[NullP|{}]],
			True
		],
		True
	],

	Test["QuantificationPrepMixVolume is informed when Aliquot -> True:",
		If[!MatchQ[Lookup[packet,Aliquot],False],
			MatchQ[Lookup[packet,QuantificationPrepMixVolume],Except[NullP|{}]],
			True
		],
		True
	],

	Test["MixSourceVolume is informed when Aliquot -> True:",
		If[!MatchQ[Lookup[packet,Aliquot],False],
			MatchQ[Lookup[packet,MixSourceVolume],Except[NullP|{}]],
			True
		],
		True
	],

	Test["QuantificationPrepNumberOfMixes is informed when Aliquot -> True:",
		If[!MatchQ[Lookup[packet,Aliquot],False],
			MatchQ[Lookup[packet,QuantificationPrepNumberOfMixes],Except[NullP|{}]],
			True
		],
		True
	],

	(* --- ResolvedAfterCheckpoint --- *)
	(* Instruments must be resolved after Resource Picking is complete *)
	ResolvedAfterCheckpoint[packet,"Preparing Samples",{PlateReader,QuantificationPlates}],

	Test["LiquidHandler, Buffer, BufferDiluent should be resolved to a sample, instrument, container or part after \"Preparing Samples\" if Aliquot ->True:",
		If[!MatchQ[Lookup[packet,Aliquot],False],
			Module[{progress,fieldsValues,checkpointsCompleted},

				progress=Lookup[packet,CheckpointProgress];
				fieldsValues=Lookup[packet,{LiquidHandler, Buffer, BufferDiluent}];

				(* Extract only checkpoints which have a completion time *)
				checkpointsCompleted = extractCompletedCheckpoints[progress];

				MatchQ[{MemberQ[checkpointsCompleted, "Preparing Samples"], Flatten[fieldsValues]},
					Alternatives[

						(* If the checkpoint hasn't been completed, test passes on any value *)
						{False, _},

						(* If the checkpoint has been completed, all input fields must be populated with Object(s) *)
						{True, {ObjectP[{Object[Sample], Object[Instrument], Object[Container], Object[Part], Object[Item]}]..}}
					]
				]
			],
			True
		],
		True
	],


	(* --- RequiredAfterCheckpoint --- *)
	(* placements must be resolved / informed after Preparing Samples is complete *)
	Test["QuantificationPlacements should be informed after \"Preparing Samples\" if Aliquot ->True:",
		If[!MatchQ[Lookup[packet,Aliquot],False],
			Module[{fieldsValues,progress,checkpointsCompleted},

				(* Look up the values of the provided fields *)
				fieldsValues = Lookup[packet, QuantificationPlacements];

				(* Look up a list of checkpoints that have started and/or completed so far*)
				progress = Lookup[packet, CheckpointProgress];

				(* Extract only checkpoints which have a completion time *)
				checkpointsCompleted = extractCompletedCheckpoints[progress];

				MatchQ[{MemberQ[checkpointsCompleted,"Preparing Samples"],fieldsValues},
					Alternatives[

						(* If the checkpoint hasn't been completed, test passes on any value *)
						{False, _},

						(* If the checkpoint has been completed, all input fields must not be Null or {} *)
						{True, Except[NullP|{}]}
					]
				]
			],
			True
		],
		True
	],

	(* If Dilution is happening, check that DilutionPlates and DilutionSamples are informed *)
	If[MatchQ[Lookup[packet,Dilution],NumericP],
		RequiredWhenCompleted[packet,{DilutionPlates,DilutionSamples}],
		Nothing
	],

	(* New protocols require VolumeData. Old protocols require Volume data only if VolumeAnalysis -> True in Resolved Options *)
	Test["VolumeData must be informed when completed, unless VolumeAnalysis options exists in ResovledOptions and is set to False:",
		{(VolumeAnalysis /.Lookup[packet,ResolvedOptions]), Lookup[packet,VolumeData], Lookup[packet,Status]},
		Alternatives[
			{Except[BooleanP], Except[NullP], Completed },
			{Except[BooleanP], _, Except[Completed] },
			{True, Except[NullP], Completed},
			{True, _, Except[Completed]},
			{False, NullP, _}
		]
	],

	(* --- RequiredWhenCompleted ---*)
	RequiredWhenCompleted[packet,{Data}]

	(* Uncomment when Pressure check is added *)
	(*RequiredWhenCompleted[packet, {InitialNitrogenPressure,NitrogenPressureLog}]*)
};


(* ::Subsection::Closed:: *)
(*validProtocolAcousticLiquidHandlingQTests*)


validProtocolAcousticLiquidHandlingQTests[packet:PacketP[Object[Protocol,AcousticLiquidHandling]]]:={
	(* shared null *)
	NullFieldTest[packet,{
		CO2PressureLog,
		ArgonPressureLog,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	NotNullFieldTest[packet,{
		(* shared *)
		SamplesIn,
		ContainersIn,

		(* specific *)
		Manipulations,
		ResolvedManipulations,
		RequiredObjects,
		LiquidHandler,
		FluidTypeCalibration,
		InWellSeparation
	}],

	RequiredWhenCompleted[packet,{
		WorkingSamples,
		WorkingContainers,
		MethodFilePath,
		MethodFileName,
		LabwareDefinitionFilePath,
		LabwareDefinitionFileName,
		DestinationPlateTypes,
		SourcePlateFormats,
		EchoDataFileReferenceID,
		InitialSourcePlacement,
		InitialDestinationPlacement,
		FinalSource,
		FinalDestination,
		SamplesOut,
		ContainersOut,
		Data
	}]
};



(* ::Subsection::Closed:: *)
(*validProtocolAgaroseGelElectrophoresisQTests*)


validProtocolAgaroseGelElectrophoresisQTests[packet:PacketP[Object[Protocol,AgaroseGelElectrophoresis]]]:={
	(*shared Null*)
	NullFieldTest[packet,{

		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	NotNullFieldTest[packet,{
		(* Shared fields shaping *)
		ContainersIn,

		(* Required specific fields *)
		Scale,
		SampleVolumes,
		Instrument,
		Gels,
		GelModel,

		NumberOfGels,
		NumberOfLanes,

		SampleLoadingVolume,
		SeparationTime,
		Voltage,
		DutyCycle,
		CycleDuration,
		PrimaryLoadingDyes,
		SecondaryLoadingDyes,
		LoadingDyeVolumes
	}],

	(* INDEX MATCHING FIELDS *)
	Test["The length of Gels matches the length of SamplesIn:",
		Length[Lookup[packet,SamplesIn]],
		Length[Lookup[packet,Gels]]
	],

	(* UPON COMPLETION  *)
	ResolvedWhenCompleted[packet,{
		Instrument,
		LoadingPlate,
		Gels
	}],

	RequiredWhenCompleted[packet,{
		SamplesIn,
		MethodFilePath,
		DataFilePath,
		Data,
		LoadingPlateManipulation,
		LoadingPlateMix,
		DataFile
	}],

	Test["If the protocol is completed, the length of Data should be equal to the length of SamplesIn",
		{Lookup[packet, Status], Length[DeleteCases[Lookup[packet,Data],Null]]},
		Alternatives[
			{Completed,Length[DeleteCases[Lookup[packet,SamplesIn],Null]]},
			{Except[Completed],_}
		]
	],

	Test["Any entries in in the Data field have DataType->Analyte",
		Download[DeleteCases[Lookup[packet,Data],Null], DataType],
		DataType|{}|{Analyte..}
	],

	Test["Any entries in in the LadderData field have DataType->Standard",
		Download[DeleteCases[Lookup[packet,LadderData],Null], DataType],
		DataType|{}|{Standard..}
	],

	Test[
		"Unless the protocol is doing preparatory primitives, Samples In should be Informed if the Protocol is not Canceled or Aborted:",
		Lookup[packet,{SamplesIn,PreparatoryUnitOperations,Status}],
		{{ObjectP[Object[Sample]]..},_,_}|{{(ObjectP[{Model[Sample],Object[Sample]}]|Null)..},{Except[Null]..},_}|{_,_,Canceled|Aborted}
	]
};


(* ::Subsection::Closed:: *)
(*validProtocolAutoclaveQTests*)


validProtocolAutoclaveQTests[packet:PacketP[Object[Protocol,Autoclave]]]:={
	(* shared fields shaping *)
	AnyInformedTest[packet,{
		SamplesIn,
		ContainersIn
	}],

	NullFieldTest[packet, {
		Data
	}],

	(* specific to object *)
	NotNullFieldTest[packet, {
		Instrument,
		AutoclaveProgram,
		SteamIntegrator,
		SterilizationTime,
		SterilizationTemperature
	}],

	(* UPON COMPLETION *)
	RequiredWhenCompleted[packet,{
		SteamIntegratorResult,
		AluminumFoil,
		AutoclaveTape
	}]
};

(* ::Subsection::Closed:: *)
(*validProtocolBioconjugationQTests*)


validProtocolBioconjugationQTests[packet:PacketP[Object[Protocol,Bioconjugation]]]:={
	(* shared fields shaping *)
	NullFieldTest[packet, {
		Data
	}],

	(* specific to bioconjugation *)
	NotNullFieldTest[packet, {
		ConjugationReactionVolumes,
		ConjugationSampleConcentrations,
		ConjugationSampleVolumes,
		ConjugationParameters,
		ReactionVessels
	}],

	(* upon completion *)
	RequiredWhenCompleted[packet,{
		ConjugationReactionPrimitives,
		SamplesOut,
		ContainersOut
	}],

	(*Required Togehter*)
	RequiredTogether[packet,{
		PreWashBuffers,PreWashBufferVolumes
	}],
	RequiredTogether[packet,{
		PreWashResuspensionDiluents,PreWashResuspensionDiluentVolumes
	}],
	RequiredTogether[packet,{
		ActivationReagents,ActivationReagentVolumes
	}],
	RequiredTogether[packet,{
		ActivationDiluents,ActivationDiluentVolumes
	}],
	RequiredTogether[packet,{
		PostActivationWashBuffers,PostActivationWashBufferVolumes
	}],
	RequiredTogether[packet,{
		PostActivationResuspensionDiluents,PostActivationResuspensionDiluentVolumes
	}],
	RequiredTogether[packet,{
		ActivationSamplesOut,ActivationSamplesOutStorageCondition
	}],
	RequiredTogether[packet,{
		ConjugationReactionBuffers,ConjugationReactionBufferVolumes
	}],
	RequiredTogether[packet,{
		QuenchReagents,QuenchReagentVolumes
	}],
	RequiredTogether[packet,{
		PostConjugationWorkupBuffers,PostConjugationWorkupBufferVolumes
	}],
	RequiredTogether[packet,{
		PostConjugationResuspensionDiluents,PostConjugationResuspensionDiluentVolumes
	}],

	(*Conditional tests*)
	If[MatchQ[Lookup[packet,PreWashMethod],Except[Null]],
		RequiredWhenCompleted[packet,{
			PreWashPrimitives,
			PreWashSampleManipulation
		}],
		Nothing
	],

	If[MatchQ[Lookup[packet,ActivationReagents],Except[Null]],
		RequiredWhenCompleted[packet,{
			ActivationPrimitives,
			ActivationSampleManipulation
		}],
		Nothing
	],

	If[MatchQ[Lookup[packet,PostActivationWashMethod],Except[Null]],
		RequiredWhenCompleted[packet,{
			PostActivationWashPrimitives,
			PostActivationWashSampleManipulation
		}],
		Nothing
	],

	If[MatchQ[Lookup[packet,QuenchReagents],Except[Null]],
		RequiredWhenCompleted[packet,{
			QuenchPrimitives,
			QuenchSampleManipulation
		}],
		Nothing
	],

	If[MatchQ[Lookup[packet,PostConjugationWorkupMethod],Except[Null]],
		RequiredWhenCompleted[packet,{
			PostConjugationPrimitives,
			PostConjugationSampleManipulation
		}],
		Nothing
	]

};



(* ::Subsection::Closed:: *)
(*validProtocolBioLayerInterferometryQTests*)


validProtocolBioLayerInterferometryQTests[packet:PacketP[Object[Protocol,BioLayerInterferometry]]]:= {

	(*Shared fields*)

	NotNullFieldTest[packet,
		{
			SamplesIn
		}
	],

	NullFieldTest[packet,
		{
			InitialNitrogenPressure,
			NitrogenPressureLog,
			InitialCO2Pressure,
			CO2PressureLog,
			InitialArgonPressure,
			ArgonPressureLog
		}
	],

	(*Individual fields*)

	NotNullFieldTest[packet,
		{
			Instrument,
			InstrumentRunTime,
			ProbesUsed,
			ExperimentType,
			BioProbes,
			AcquisitionRate,
			RecoupSample,
			AssayPlate,
			PlateLayout,
			AssayOverview,
			AssayPrimitives
		}
	],

	(*required together tests*)

	RequiredTogetherTest[packet,
		{
			StartDelay,
			StartDelayShake
		}
	],
	RequiredTogetherTest[packet,
		{
			ProbeRackEquilibrationTime,
			ProbeRackEquilibrationBuffer
		}
	],

	(*other tests*)

	(* Make sure fields that are supposed to be index-matched with SamplesIn all have the same length, if they are informed*)
	Test[
		"All informed fields that are index matched have the same length as SamplesIn:",
		Length/@(Lookup[packet,ToList/@DeleteCases[{SamplesIn,FixedSampleDilutions,SerialSampleDilutions,PreMixSolutions},Null]]),
		{samplesInLength_Integer..}
	]

};



(* ::Subsection::Closed:: *)
(*validProtocolcDNAPrepQTests*)


validProtocolcDNAPrepQTests[packet:PacketP[Object[Protocol,cDNAPrep]]]:={

(* Shared Fields which should NOT be null *)
	NotNullFieldTest[packet, {
		SamplesIn,
		ContainersIn
	}],

	NullFieldTest[packet,{
		cDNAPrepProgram,
		Data,

		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

(* Indiviudal Fields Tests *)

	NotNullFieldTest[packet,{
	(* General *)
		MediaVolume,
		ReactionVolume,
		RNALysateVolumes,
		ReverseTranscriptase,
	(* PBS Wash *)
		WashBuffer,
		WashVolume,
		NumberOfWashes,
	(* Begin Cell Lysis *)
		LysisSolution,
		LysisSolutionVolume,
		LysisTime,
		NumberOfLysisMixes,
		DNase,
		DNaseVolume,

	(* Stop Cell Lysis *)
		StopSolution,
		StopSolutionVolume,
		StopTime,
		NumberOfStopMixes,
		StopMixVolume,

	(* cDNA Reaction *)
		ExtensionTemperature,
		ExtensionTime,
		InactivationTemperature,
		InactivationTime,
		RampRate
	}],


(* cDNA master mix *)
	RequiredTogetherTest[packet,{
		ReverseTranscriptaseBuffer,
		ReverseTranscriptaseEnzyme,
		RTEnzymeVolume
	}],

	RequiredWhenCompleted[packet,{
		SamplesOut,
		ContainersOut
	}],

(* Make sure fields that are supposed to be index-matched with SamplesIn all have the same length *)
	Test[
		"All fields that correspond to Sample Options match the length of SamplesIn:",
		Length/@(Lookup[packet,{SamplesIn,RNALysateVolumes,ReverseTranscriptase}]),
		{samplesInLength_Integer..}
	]
};


(* ::Subsection::Closed:: *)
(*validProtocolCellFreezeQTests*)


validProtocolCellFreezeQTests[packet:PacketP[Object[Protocol,CellFreeze]]]:={
(* shared null *)
	NullFieldTest[packet,{
		Data,
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	NotNullFieldTest[packet, {
	(* shared informed *)
		SamplesIn,
		ContainersIn,

	(* object specific *)
		CryoTubes,
		WashVolume,
		MediaVolume,
		FreezingMediaVolume,
		Consolidation,
		NumberOfTubes
	}],

	ResolvedWhenCompleted[packet, {
		CryoTubes
	}],

	RequiredWhenCompleted[packet, {
		SamplesOut,
		ContainersOut,
		DateFrozen,
		DateStored
	}]

};


(* ::Subsection::Closed:: *)
(*validProtocolCellMediaChangeQTests*)


validProtocolCellMediaChangeQTests[packet:PacketP[Object[Protocol,CellMediaChange]]]:={

(* Shared Fields which should be null *)
	NullFieldTest[packet,{
		Data,
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	NotNullFieldTest[packet,{
	(* Shared Fields which should NOT be null *)
		SamplesIn,
		SamplesOut,
		ContainersIn,
		ContainersOut,
		CellMediaChangeProgram,
	(* Indiviudal Fields Tests *)
		Media,
		TotalVolume
	}]

};

(* ::Subsection::Closed:: *)
(*validProtocolCellMediaChangeQTests*)


validProtocolIncubateCellsQTests[packet:PacketP[Object[Protocol,IncubateCells]]]:={
	(*TODO: Check all of these*)
	(* Shared Fields which should be null *)
	NullFieldTest[packet,{
		NitrogenPressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure
	}],

	NotNullFieldTest[packet,{
		(* Shared Fields which should NOT be null *)
		SamplesIn,
		ContainersIn,
		(* Individual Fields Tests *)
		IncubationTimes,
		MaxIncubationTimes,
		CellTypes,
		CultureAdhesions,
		InvertContainers,
		Shake
	}]

};


(* ::Subsection::Closed:: *)
(*validProtocolCellSplitQTests*)


validProtocolCellSplitQTests[packet:PacketP[Object[Protocol,CellSplit]]]:={
	NullFieldTest[packet,{
	(* shared fields null *)
		Data,
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	NotNullFieldTest[packet,{
	(* shared fields not null *)
		SamplesIn,
		ContainersIn,
	(* unique fields not null *)
		Media,
		InactivationVolume,
		TotalVolume,
		NumberOfWashes,
		SplitVolumes,
		MediaVolumes,
		PlateModels,
		CellSplitProgram
	}],

(* Shared fields required when protocol has Status\[Rule]Completed *)
	RequiredWhenCompleted[packet,{
		SamplesOut,
		ContainersOut
	}]

};


(* ::Subsection::Closed:: *)
(*validProtocolCentrifugeQTests*)


validProtocolCentrifugeQTests[packet:PacketP[Object[Protocol,Centrifuge]]]:={

(* Shared fields -- Null*)
	NullFieldTest[packet,{
		Data,
		SamplesOut,
		ContainersOut,
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	NotNullFieldTest[packet, {
	(* Shared fields -- Not Null *)
		SamplesIn,
		ContainersIn,
	(* Unique fields *)
		Sterile,
		Balance,
		Centrifuges,
		Rotors,
		Speeds,
		Forces,
		Times,
		Temperatures
	}],

	RequiredAfterCheckpoint[packet,"Balancing Centrifuge",{ContainerWeights}],
	ResolvedAfterCheckpoint[packet,"Balancing Centrifuge",{Balance}],

	ResolvedAfterCheckpoint[packet,"Centrifuging Samples",{Centrifuges,Rotors}]

};


(* Helper to check whether all contents of ContainersIn are present in SamplesIn *)
samplesMatchContainersQ[packet:PacketP[Object[Protocol,Centrifuge]]] := Module[
	{sampsIn,ctrsIn,contents},

	sampsIn = DeleteCases[
		Lookup[packet,SamplesIn],
		Null
	];

	ctrsIn = Lookup[packet,ContainersIn];

	contents = DeleteCases[
		Flatten[Lookup[Download[ctrsIn],Contents][[All,All,2]]],
		Null
	];

	ContainsExactly[
		sampsIn,
		contents
	]

];


(* ::Subsection:: *)
(*validProtocolCoulterCountQTests*)

(* ::Subsubsection:: *)
(*validProtocolCoulterCountQTests*)



validProtocolCoulterCountQTests[packet:PacketP[Object[Protocol,CoulterCount]]]:={

	NotNullFieldTest[packet,{
		(* Shared fields *)
		SamplesIn,
		ContainersIn,
		(* Unique fields *)
		Instrument,
		ApertureTube,
		ApertureDiameter,
		ElectrolyteSolution,
		ElectrolyteSolutionVolume,
		ElectrolyteSolutionFlushVolume,
		FlushFlowRate,
		FlushTime,
		SampleAmounts,
		ElectrolyteSampleDilutionVolumes,
		ElectrolytePercentages,
		MeasurementContainers,
		NumberOfReadings,
		FlowRates,
		MinParticleSizes,
		EquilibrationTimes,
		StopConditions,
		ElectrolyteSolutionOutStorage
	}],

	(* fields that should be null *)
	NullFieldTest[packet,{
		(* no sample out *)
		SamplesOut,
		ContainersOut,
		(* no sample prep filter *)
		FilterSamplePreparation,
		(* no incubate/mix *)
		IncubateSamplePreparation,
		PooledIncubateSamplePreparation,
		NestedIndexMatchingIncubateSamplePreparation,
		(* no centrifuge *)
		CentrifugeSamplePreparation,
		PooledCentrifugeSamplePreparation,
		NestedIndexMatchingCentrifugeSamplePreparation
	}],

	(* Upon completion *)
	RequiredWhenCompleted[packet,{
		Data
	}],

	(* if we are doing system suitability check, the corresponding index matched options should be populated; if no suitability check, the corresponding index matched fields should all be Null *)
	indexMatchingRequiredTogetherTest[packet,{
		SystemSuitabilityTolerance,
		SuitabilitySizeStandards,
		SuitabilityParticleSizes,
		SuitabilityTargetConcentrations,
		SuitabilitySampleAmounts,
		SuitabilityElectrolyteSampleDilutionVolumes,
		SuitabilityMeasurementContainers,
		NumberOfSuitabilityReadings,
		SuitabilityFlowRates,
		MinSuitabilityParticleSizes,
		SuitabilityEquilibrationTimes,
		SuitabilityStopConditions,
		AbortOnSystemSuitabilityCheck,
		SystemSuitabilityError
	}],

	(* TODO: make a MapThread version of RequiredTogetherTest for checking multiple fields - indexMatchingRequiredTogetherTest happen*)

	(* if we are diluting for any samplesIn, the corresponding index matched Dilution options should be populated; if no dilution, the corresponding index matched fields should all be Null *)
	indexMatchingRequiredTogetherTest[packet,{
		DilutionTypes,
		DilutionStrategies,
		NumberOfDilutions,
		TargetAnalytes,
		CumulativeDilutionFactors,
		TargetAnalyteConcentrations,
		TransferVolumes,
		TotalDilutionVolumes,
		FinalVolumes
	}],

	(* if incubating during dilution, the corresponding index matched incubate options should be populated; if no incubation, the corresponding index matched options should all be Null *)
	indexMatchingRequiredTogetherTest[packet,{
		DilutionIncubationTimes,
		DilutionIncubationInstruments,
		DilutionIncubationTemperatures,
		DilutionMixTypes
	}]
};


(* ::Subsection::Closed:: *)
(*validProtocolCOVID19TestQTests*)


validProtocolCOVID19TestQTests[packet:PacketP[Object[Protocol,COVID19Test]]]:={
	NotNullFieldTest[packet,{
		(*Shared fields not Null*)
		ContainersIn,

		(*Specific fields not Null*)
		(*===Reagent Preparation===*)
		Disinfectant,
		(*===RNA Extraction===*)
		BiosafetyCabinet,
		AliquotVessels,
		CellLysisBuffer,
		ViralLysisBuffer,
		RNAExtractionColumns,
		PrimaryCollectionVessels,
		SecondaryCollectionVessels,
		PrimaryWashSolution,
		SecondaryWashSolution,
		ElutionVessels,
		ElutionSolution,
		(*===RT-qPCR===*)
		ReactionVolume,
		NoTemplateControl,
		ViralRNAControl,
		TestContainers,
		SampleVolume,
		ForwardPrimers,
		ForwardPrimerVolume,
		ReversePrimers,
		ReversePrimerVolume,
		Probes,
		ProbeVolume,
		ProbeExcitationWavelength,
		ProbeExcitationWavelength,
		MasterMix,
		MasterMixVolume,
		ReactionBuffer,
		ReactionBufferVolume,
		Thermocycler,
		ReverseTranscriptionRampRate,
		ReverseTranscriptionTemperature,
		ReverseTranscriptionTime,
		ActivationRampRate,
		ActivationTemperature,
		ActivationTime,
		DenaturationRampRate,
		DenaturationTemperature,
		DenaturationTime,
		ExtensionRampRate,
		ExtensionTemperature,
		ExtensionTime,
		NumberOfCycles
	}],


	(*Shared fields Null*)
	NullFieldTest[packet,{
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialCO2Pressure,
		InitialArgonPressure
	}],


	(*Required together*)
	RequiredTogetherTest[packet,{
		ReagentPreparationPrimitives,
		ReagentPreparationManipulation
	}],


	(*Required when completed*)
	RequiredWhenCompleted[packet,{
		RNAExtractionPrimitives,
		RNAExtractionManipulation,
		TestSamples,
		AnalysisNotebook
	}],


	(*SamplesIn test*)
	Test[
		"Unless the protocol is doing preparatory primitives, Samples In should be Informed if the Protocol is not Canceled or Aborted:",
		Lookup[packet,{SamplesIn,PreparatoryUnitOperations,Status}],
		{{ObjectP[Object[Sample]]..},_,_}|{{(ObjectP[{Model[Sample],Object[Sample]}]|Null)..},{Except[Null]..},_}|{_,_,Canceled|Aborted}
	]
};


(* ::Subsection::Closed:: *)
(*validProtocolMitochondrialIntegrityAssayQTests*)


validProtocolMitochondrialIntegrityAssayQTests[packet:PacketP[Object[Protocol,MitochondrialIntegrityAssay]]]:={

(* shared field shaping *)
	AnyInformedTest[packet,{
		SamplesIn,
		ContainersIn
	}],

	NullFieldTest[packet,{
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	NotNullFieldTest[packet,{
	(* shared field shaping *)
	(* Unique fields that should never be Null *)
		AnalysisMethod,
		MitochondrialDetectorDye,
		MitochondrialDetectorVolume,
		FinalVolume,
		StainingTime,
		StainingTemperature,
		NumberOfReactionWashes,
		ReactionBuffer,
		WashVolume,
		MitochondrialIntegrityAssayProgram
	}],

	RequiredTogetherTest[packet,{
		WashVolume,
		NumberOfReactionWashes
	}],

	RequiredTogetherTest[packet,{
		BufferVolume,
		NumberOfBufferWashes
	}],

(* should be filled in if FlowCytometry method is chosen *)
	Test["If the AnalysisMethod is FlowCytometry, then {MediaSample, PBSSample, PBSVolume, ResuspensionVolume, FilterVolume, NumberOfBufferWashes, NumberOfFilterings} should be informed:",
		If[
			MatchQ[Lookup[packet,AnalysisMethod], FlowCytometry],
			And[
				!NullQ[Lookup[packet,Media]],
				!NullQ[Lookup[packet,NumberOfBufferWashes]],
				!NullQ[Lookup[packet,NumberOfFilterings]],
				!NullQ[Lookup[packet,Buffer]],
				!NullQ[Lookup[packet,BufferVolume]],
				!NullQ[Lookup[packet,ResuspensionVolume]],
				!NullQ[Lookup[packet,FilterVolume]]
			],
			True
		],
		True
	],

(* Sensible Volume Transfers *)
	FieldComparisonTest[packet,{TrypsinizedVolume,FilterVolume},GreaterEqual],
	FieldComparisonTest[packet,{FilterVolume,ResuspensionVolume}, GreaterEqual],

(* When Completed *)
	RequiredWhenCompleted[packet, {AnalysisProtocol}]
};

(* ::Subsection::Closed:: *)
(*validProtocolDialysisQTests*)

validProtocolDialysisQTests[packet:PacketP[Object[Protocol,Dialysis]]]:={

	(* shared fields not null *)
	NotNullFieldTest[
		packet,
		{
			ContainersIn,
			SamplesIn,
			(* specific to object *)
			DialysisMembranes,
			Dialysates
		}
	],

	NullFieldTest[
		packet,
		{
			NitrogenPressureLog,
			CO2PressureLog,
			ArgonPressureLog,
			InitialNitrogenPressure,
			InitialArgonPressure,
			InitialCO2Pressure
		}
	]

};


(* ::Subsection::Closed:: *)
(*validProtocolCrossFlowFiltrationQTests*)


validProtocolCrossFlowFiltrationQTests[packet:PacketP[Object[Protocol,CrossFlowFiltration]]]:={
	
	(*RetentateStorageConditions
PrimaryPumpFlowRate
TransmembranePressureTargets*)

	NotNullFieldTest[packet,{
		ContainersIn,
		CrossFlowFilters,
		PermeateContainerOuts,
		PermeateStorageConditions,
		RetentateContainerOuts,
		Instrument,
		FilterStorageConditions,
		SystemFlushBuffer,
		SampleInVolumes,
		Sterile,
		FiltrationModes,
		TubingType
	}],
	With[{instrument = Lookup[packet,Instrument]},
		If[
			MatchQ[instrument, ObjectP[Model[Instrument]]],
			If[
				MatchQ[instrument,ObjectP[Model[Instrument, CrossFlowFiltration, "KrosFlo KR2i"]]],
				NotNullFieldTest[packet,{
					RetentateStorageConditions,PrimaryPumpFlowRates,TransmembranePressureTargets
				}],
				NotNullFieldTest[packet,{DeadVolumeRecoveryModes}]
			],
			If[
				MatchQ[instrument[Model],ObjectP[Model[Instrument, CrossFlowFiltration, "KrosFlo KR2i"]]],
				NotNullFieldTest[packet,{
					RetentateStorageConditions,PrimaryPumpFlowRates,TransmembranePressureTargets
				}],
				NotNullFieldTest[packet,{DeadVolumeRecoveryModes}]
			]
		]
	],


	(*Shared fields Null*)
	NullFieldTest[packet,{
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialCO2Pressure,
		InitialArgonPressure
	}]
};


(* ::Subsection::Closed:: *)
(*validProtocolCyclicVoltammetryQTests*)


validProtocolCyclicVoltammetryQTests[packet:PacketP[Object[Protocol,CyclicVoltammetry]]]:={

	NotNullFieldTest[packet,{
		(* Shared Fields: *)
		SamplesIn,
		ContainersIn,
		UnresolvedOptions,

		(* Non-Shared Fields: *)
		Instrument,
		WorkingElectrode,
		CounterElectrode,
		ReferenceElectrodes,
		ElectrodeCap,
		ReactionVessels,
		RefreshReferenceElectrodes,
		ReferenceElectrodeSoakTimes,
		Solvents,
		Electrolytes,
		LoadingSampleVolumes,
		PrimaryCyclicVoltammetryPotentials,
		NumberOfCycles,
		SampleDilutions,
		RequireSchlenkLines
	}],

	RequiredTogetherTest[packet, {
		ProtocolPath,
		SamplesInPathPrefixes,
		CyclicVoltammetryDataPaths
	}],
	RequiredTogetherTest[packet, {
		UniquePolishingSolutions,
		UniquePolishingSolutionVolumes,
		UniquePolishingPads,
		UniquePolishingPlates
	}],
	RequiredTogetherTest[packet,{
		WorkingElectrodeSonicationContainer,
		WorkingElectrodeSonicationSolvent,
		WorkingElectrodeSonicationSolventVolume
	}],
	RequiredTogetherTest[packet,{
		WorkingElectrodeWashingSolutions,
		WorkingElectrodeWashingCycles
	}],
	RequiredTogetherTest[packet,{
		CounterElectrodeWashingSolutions,
		DryCounterElectrode
	}],
	RequiredTogetherTest[packet,{
		UniqueElectrodeWashingSolutions,
		UniqueElectrodeWashingSolutionVolumes,
		WashingSolutionsCollectionContainers,
		WashingWaterCollectionContainer,
		WashingMethanolCollectionContainer
	}],
	RequiredTogetherTest[packet,{
		PretreatmentReactionVessels,
		PretreatmentPrimaryPotentials,
		PretreatmentNumberOfCycles
	}],
	RequiredTogetherTest[packet,{
		PretreatmentSpargingGases,
		PretreatmentSpargingTimes,
		PretreatmentSpargingPressures
	}],
	RequiredTogetherTest[packet,{
		PretreatmentSpargingPreBubblers,
		PretreatmentSpargingPreBubblerSolvents,
		PretreatmentSpargingPreBubblerSolventVolumes,
		InstallPretreatmentSpargingPreBubblers
	}],
	RequiredTogetherTest[packet,{
		InternalStandards,
		InternalStandardAdditionOrders
	}],
	RequiredTogetherTest[packet,{
		SpargingGases,
		SpargingTimes,
		SpargingPressures
	}],
	RequiredTogetherTest[packet,{
		SpargingPreBubblers,
		SpargingPreBubblerSolvents,
		SpargingPreBubblerSolventVolumes,
		InstallSpargingPreBubblers
	}],
	RequiredTogetherTest[packet,{
		UniquePreBubblers,
		UniquePreBubblerSolvents,
		UniquePreBubblerSolventLoadingVolumes
	}],

	RequiredWhenCompleted[packet, {
		LoadingSamples,
		LoadingSamplePreparationPrimitives,
		LoadingSamplePreparationManipulations,
		CyclicVoltammetryData,
		WorkingElectrodeRustCheck,
		CounterElectrodeRustCheck,
		ReferenceElectrodeRustChecks
	}]
};


(* ::Subsection::Closed:: *)
(*validProtocolDifferentialScanningCalorimetryQTests*)


validProtocolDifferentialScanningCalorimetryQTests[packet:PacketP[Object[Protocol, DifferentialScanningCalorimetry]]]:={
	(* shared null *)
	NullFieldTest[packet, {CO2PressureLog, ArgonPressureLog, InitialArgonPressure, InitialCO2Pressure}],

	(* specifc *)
	NotNullFieldTest[packet, {
		SamplesIn,
		Instrument,
		ContainersIn,
		InjectionVolume,
		InjectionRate,
		StartTemperatures,
		EndTemperatures,
		TemperatureRampRates,
		NumberOfScans
	}],

	RequiredWhenCompleted[packet,{
		Data,
		NitrogenPressureLog,
		InitialNitrogenPressure
	}]

};



(* ::Subsection::Closed:: *)
(*validProtocolDNASynthesisQTests*)


validProtocolDNASynthesisQTests[packet:PacketP[Object[Protocol,DNASynthesis]]]:={

	(* shared fields, null *)
	NullFieldTest[packet,{
		Data,
		NitrogenPressureLog,
		CO2PressureLog,
		InitialNitrogenPressure,
		InitialCO2Pressure
	}],

(* shared fields, not-null *)
	RequiredWhenCompleted[packet, {
		SamplesOut,
		ContainersOut
	}],

(* DNASynthesis-specific fields *)
	NotNullFieldTest[packet, {
		StrandModels,
		Scale,
		ActivatorSolution,
		OxidationSolution,
		CapASolution,
		CapBSolution,
		Cleavage,
		WashSolution,
		DeprotectionSolution,
		Columns,
		FinalDeprotection,
		EvaporationInstruments
	}],

	RequiredWhenCompleted[packet, {
		Instrument,
		CycleFilePath,
		SequenceFilePath,
		SynSequenceFilePath,
		SynthesizerWashSolution,
		CleaningPrepManipulation,
		WasteWeightTare,
		WasteWeight,
		DeblockSolutionWeightData,
		InitialPurgePressure
	}],

	ResolvedWhenCompleted[packet, {
		Instrument,
		ActivatorSolution,
		OxidationSolution,
		CapASolution,
		CapBSolution,
		WashSolution,
		DeprotectionSolution,
		Columns,
		SynthesizerWashSolution
	}],

	Test["If Cleavage is false for all strands, no cleavage-related fields should be informed:",
		If[MatchQ[Cases[(Lookup[packet,Cleavage]),True],{}],
			AllTrue[
				Lookup[packet, {Filters, CleavageMethods, CleavageSolutions, CleavageTimes,
					CleavageTemperatures, CleavageSolutionVolumes, CleavageSolutionManipulation, FilterTransferManipulation,
					FilterWashManipulation, CleavageEvaporationProtocol,CleavageWashVolumes,CleavageWashSolutions}], MatchQ[#, {Null ...}] &],
			True
		],
		True
	],

	Test["If at least one strand will be cleaved, cleavage-related fields must be populated:",
		If[Not[MatchQ[Cases[(Lookup[packet,Cleavage]),True],{}]],
			NoneTrue[
				Lookup[packet, {Filters, CleavageMethods, CleavageSolutions, CleavageTimes,
					CleavageTemperatures, CleavageSolutionVolumes, CleavageWashVolumes,CleavageWashSolutions}], MatchQ[#, {Null ...}] &],
			True
		],
		True
	],
	Test["If at least one strand will be cleaved and the protocol is complete, cleavage-related protocols must be populated:",
		If[MatchQ[Lookup[packet,Status],Completed]&&Not[MatchQ[Cases[(Lookup[packet,Cleavage]),True],{}]],
			NoneTrue[
				Lookup[packet, {CleavageSolutionManipulation, FilterTransferManipulation,
					FilterWashManipulation, CleavageEvaporationProtocol}], MatchQ[#, {Null ...}] &],
			True
		],
		True
	],
	RequiredTogetherTest[packet, {ActivatorSolution, ActivatorVolume, ActivatorSolutionDesiccants}],
	RequiredTogetherTest[packet, {OxidationSolution, OxidationVolume, OxidationTime, NumberOfOxidations}],
	RequiredTogetherTest[packet, {DeprotectionSolution, DeprotectionVolume, DeprotectionTime, NumberOfDeprotections}],
	RequiredTogetherTest[packet, {CapASolution, CapBSolution, CapAVolume, CapBVolume, CapTime, NumberOfCappings}],
	RequiredTogetherTest[packet, {WashSolution, InitialWashTime, InitialWashVolume,NumberOfInitialWashes, OxidationWashTime, OxidationWashVolume,
		NumberOfOxidationWashes, DeprotectionWashTime, NumberOfDeprotectionWashes, DeprotectionWashVolume, NumberOfFinalWashes, FinalWashTime, FinalWashVolume}]
};

(* ::Subsection::Closed:: *)
(*validProtocolRNASynthesisQTests*)


validProtocolRNASynthesisQTests[packet:PacketP[Object[Protocol,RNASynthesis]]]:={

	(* shared fields, null *)
	NullFieldTest[packet,{
		Data,
		NitrogenPressureLog,
		CO2PressureLog,
		InitialNitrogenPressure,
		InitialCO2Pressure
	}],

	(* shared fields, not-null *)
	RequiredWhenCompleted[packet, {
		SamplesOut,
		ContainersOut
	}],

	(* RNASynthesis-specific fields *)
	NotNullFieldTest[packet, {
		StrandModels,
		Scale,
		ActivatorSolution,
		OxidationSolution,
		CapASolution,
		CapBSolution,
		Cleavage,
		WashSolution,
		DeprotectionSolution,
		Columns,
		FinalDeprotection,
		RNADeprotection,
		PostCLeavageDesalting,
		PostCleavageEvaporation,
		PostRNADeprotectionDesalting,
		PostRNADeprotectionEvaporation,
		EvaporationInstruments,
		HydrofluoricAcidSafetyAgent
	}],

	RequiredWhenCompleted[packet, {
		Instrument,
		CycleFilePath,
		SequenceFilePath,
		SynSequenceFilePath,
		SynthesizerWashSolution,
		CleaningPrepManipulation,
		WasteWeightTare,
		WasteWeight,
		DeblockSolutionWeightData,
		InitialPurgePressure,
		CleavageIncubationInstruments,
		RNADeprotectionIncubationInstruments
	}],

	ResolvedWhenCompleted[packet, {
		Instrument,
		ActivatorSolution,
		OxidationSolution,
		CapASolution,
		CapBSolution,
		WashSolution,
		DeprotectionSolution,
		Columns,
		SynthesizerWashSolution
	}],

	Test["If Cleavage is false for all strands, no cleavage-related fields should be informed:",
		If[MatchQ[Cases[(Lookup[packet,Cleavage]),True],{}],
			AllTrue[
				Lookup[packet, {Filters, CleavageMethods, CleavageSolutions, CleavageTimes,
					CleavageTemperatures, CleavageSolutionVolumes, CleavageSolutionManipulation, FilterTransferManipulation,
					FilterWashManipulation, CleavageEvaporationProtocol,CleavageWashVolumes,CleavageWashSolutions}], MatchQ[#, {Null ...}] &],
			True
		],
		True
	],

	Test["If at least one strand will be cleaved, cleavage-related fields must be populated:",
		If[Not[MatchQ[Cases[(Lookup[packet,Cleavage]),True],{}]],
			NoneTrue[
				Lookup[packet, {Filters, CleavageMethods, CleavageSolutions, CleavageTimes,
					CleavageTemperatures, CleavageSolutionVolumes, CleavageWashVolumes,CleavageWashSolutions}], MatchQ[#, {Null ...}] &],
			True
		],
		True
	],
	Test["If at least one strand will be cleaved and the protocol is complete, cleavage-related protocols must be populated:",
		If[MatchQ[Lookup[packet,Status],Completed]&&Not[MatchQ[Cases[(Lookup[packet,Cleavage]),True],{}]],
			NoneTrue[
				Lookup[packet, {CleavageSolutionManipulation, FilterTransferManipulation,
					FilterWashManipulation, CleavageEvaporationProtocol}], MatchQ[#, {Null ...}] &],
			True
		],
		True
	],

	Test["If at least one strand will be deprotected, deprotection-related fields must be populated:",
		If[Not[MatchQ[Cases[(Lookup[packet,RNADeprotection]),True],{}]],
			NoneTrue[
				Lookup[packet, {RNADeprotectionMethods, RNADeprotectionResuspensionSolutions,
					RNADeprotectionResuspensionSolutionVolumes, RNADeprotectionResuspensionTimes,
					RNADeprotectionResuspensionTemperatures, RNADeprotectionSolutions, RNADeprotectionSolutionVolumes,
					RNADeprotectionTimes, RNADeprotectionTemperatures, RNADeprotectionQuenchingSolutions,
					RNADeprotectionQuenchingSolutionVolumes}], MatchQ[#, {Null ...}] &],
			True
		],
		True
	],
	Test["If at least one strand will be deprotected and the protocol is complete, deprotection-related protocols must be populated:",
		If[MatchQ[Lookup[packet,Status],Completed]&&Not[MatchQ[Cases[(Lookup[packet,RNADeprotection]),True],{}]],
			NoneTrue[
				Lookup[packet, {RNADeprotectionResuspensionIncubations, RNADeprotectionResuspensionSolutionManipulations,
					RNADeprotectionSolutionManipulations, RNADeprotectionQuenchingManipulations,
					DeprotectionResuspensionManipulations, DeprotectionResuspensionTransfers}], MatchQ[#, {Null ...}] &],
			True
		],
		True
	],

	Test["If at least one strand will be desalted after cleavage and the protocol is complete, post cleavage desalting-related protocols must be populated:",
		If[MatchQ[Lookup[packet,Status],Completed]&&Not[MatchQ[Cases[(Lookup[packet,PostCleavageDesalting]),True],{}]],
			NoneTrue[
				Lookup[packet, {PostCleavageDesaltingType, PostCleavageDesaltingCartridges, PostCleavageDesaltingPreFlushBuffer,
					PostCleavageDesaltingPreFlushVolumes, PostCleavageDesaltingPreFlushRates, PostCleavageDesaltingEquilibrationVolumes,
					PostCleavageDesaltingEquilibrationRates, PostCleavageDesaltingSampleVolumes, PostCleavageDesaltingSampleLoadRates,
					PostCleavageDesaltingRinseAndReloads, PostCleavageDesaltingRinseVolumes, PostCleavageDesaltingWashVolumes,
					PostCleavageDesaltingWashRates, PostCleavageDesaltingElutionVolumes, PostCleavageDesaltingNumberOfElutions,
					PostCleavageDesaltingElutionRates}], MatchQ[#, {Null ...}] &],
			True
		],
		True
	],
	Test["If at least one strand will be desalted after deprotection and the protocol is complete, post deprotectino desalting-related protocols must be populated:",
		If[MatchQ[Lookup[packet,Status],Completed]&&Not[MatchQ[Cases[(Lookup[packet,PostRNADeprotectionDesalting]),True],{}]],
			NoneTrue[
				Lookup[packet, {PostRNADeprotectionDesaltingType, PostRNADeprotectionDesaltingCartridges, PostRNADeprotectionDesaltingPreFlushBuffer,
					PostRNADeprotectionDesaltingPreFlushVolumes, PostRNADeprotectionDesaltingPreFlushRates, PostRNADeprotectionDesaltingEquilibrationVolumes,
					PostRNADeprotectionDesaltingEquilibrationRates, PostRNADeprotectionDesaltingSampleVolumes, PostRNADeprotectionDesaltingSampleLoadRates,
					PostRNADeprotectionDesaltingRinseAndReloads, PostRNADeprotectionDesaltingRinseVolumes, PostRNADeprotectionDesaltingWashVolumes,
					PostRNADeprotectionDesaltingWashRates, PostRNADeprotectionDesaltingElutionVolumes, PostRNADeprotectionDesaltingNumberOfElutions,
					PostRNADeprotectionDesaltingElutionRates}], MatchQ[#, {Null ...}] &],
			True
		],
		True
	],

	RequiredTogetherTest[packet, {ActivatorSolution, ActivatorVolume, ActivatorSolutionDesiccants}],
	RequiredTogetherTest[packet, {OxidationSolution, OxidationVolume, OxidationTime, NumberOfOxidations}],
	RequiredTogetherTest[packet, {DeprotectionSolution, DeprotectionVolume, DeprotectionTime, NumberOfDeprotections}],
	RequiredTogetherTest[packet, {CapASolution, CapBSolution, CapAVolume, CapBVolume, CapTime, NumberOfCappings}],
	RequiredTogetherTest[packet, {WashSolution, InitialWashTime, InitialWashVolume,NumberOfInitialWashes, OxidationWashTime, OxidationWashVolume,
		NumberOfOxidationWashes, DeprotectionWashTime, NumberOfDeprotectionWashes, DeprotectionWashVolume, NumberOfFinalWashes, FinalWashTime, FinalWashVolume}]
};


(* ::Subsection::Closed:: *)
(*validProtocolDynamicLightScatteringQTests*)


validProtocolDynamicLightScatteringQTests[packet:PacketP[Object[Protocol,DynamicLightScattering]]]:={

	(* shared fields, null *)
	NullFieldTest[packet,{
		CO2PressureLog,
		InitialCO2Pressure
		}],

	(* DLS-specific fields *)
	NotNullFieldTest[packet, {
		SamplesIn,
		ContainersIn,
		AssayFormFactor,
		AssayType,
		Instrument,
		SampleLoadingPlate,
		Temperature,
		EquilibrationTime,
		NumberOfAcquisitions,
		AcquisitionTime,
		AssayContainers,
		AssayContainerFillDirection,
		DLSRunTime
	}],

	RequiredWhenCompleted[packet, {
		MethodFilePath,
		DataFilePath,
		Data,
		PlatePreparationUnitOperations,
		PlatePreparation
	}],

	RequiredTogetherTest[packet,{
		Analyte,
		AnalyteMassConcentrations,
		Buffer,
		DilutionMixType,
		DilutionMixInstrument
	}],

	RequiredTogetherTest[packet,{
		MeasurementDelayTime,
		(IsothermalMeasurements|IsothermalRunTime),
		IsothermalAttenuatorAdjustment
	}],

	RequiredTogetherTest[packet,{
		MinTemperature,
		MaxTemperature,
		TemperatureRampOrder,
		NumberOfCycles,
		TemperatureRamping,
		TemperatureResolution
	}],

	(*Min/Max temperature sanity check*)
	FieldComparisonTest[packet, {MinTemperature, MaxTemperature}, LessEqual]
};



(* ::Subsection::Closed:: *)
(*validProtocolDNASequencingQTests*)


validProtocolDNASequencingQTests[packet:PacketP[Object[Protocol,DNASequencing]]]:={

	NotNullFieldTest[packet,{
		(*Shared fields not Null*)
		ContainersIn,

		(*Specific fields not Null*)
		Instrument,
		SequencingCartridge,
		InjectionGroups,
		BufferCartridge,
		PreparedPlate,
		NumberOfInjections,
		ReadLength,
		SampleVolumes,
		ReactionVolumes,
		AssayPlate,
		PlateSeal,
		PrimeTime,
		PrimeVoltage,
		InjectionTime,
		InjectionVoltage,
		RampTime,
		RunVoltage,
		RunTime
	}],


	(*Shared fields Null*)
	NullFieldTest[packet,{
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialCO2Pressure,
		InitialArgonPressure
	}],


	(*Required together*)
	RequiredTogetherTest[packet,{
		PreparedPlate,
		PrimerConcentration,
		PrimerVolume,
		MasterMixVolume,
		AdenosineTripshophateTerminator,
		ThymidineTripshophateTerminator,
		GuanosineTripshophateTerminator,
		CytosineTripshophateTerminator,
		DiluentVolume
	}],


	(*Required when completed*)
	RequiredWhenCompleted[packet,{
		MethodFilePath
	}],


	(*SamplesIn test*)
	Test[
		"Unless the protocol is doing preparatory primitives, Samples In should be Informed if the Protocol is not Canceled or Aborted:",
		Lookup[packet,{SamplesIn,PreparatoryUnitOperations,Status}],
		{{ObjectP[Object[Sample]]..},_,_}|{{(ObjectP[{Model[Sample],Object[Sample]}]|Null)..},{Except[Null]..},_}|{_,_,Canceled|Aborted}
	],


	(*Primer fields tests*)
	If[MemberQ[
		NullQ/@Flatten[Lookup[packet,{PrimerVolumes,PrimerConcentrations}]],
		False
	],
		Test[
			"If any primer field is populated, the rest are also populated:",
			NullQ/@Flatten[Lookup[packet,{PrimerConcentrations,PrimerVolumes}]],
			ListableP[False]
		],
		Nothing
	]

};


(* ::Subsection::Closed:: *)
(*validProtocolFilterQTests*)


validProtocolFilterQTests[packet:PacketP[Object[Protocol,Filter]]]:= {
	(* shared fields *)
	NullFieldTest[packet, {
		Data,
		CO2PressureLog,
		ArgonPressureLog,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	NotNullFieldTest[packet, {
		ContainersIn,
		ContainersOut
	}],

	RequiredWhenCompleted[packet, {
		SamplesIn,
		SamplesOut
	}],

	(* type specific fields *)
	NotNullFieldTest[packet, Filters],

	Test[
		"Unless the protocol is doing preparatory primitives, Samples In should be Informed if the Protocol is not Canceled or Aborted:",
		Lookup[packet,{SamplesIn,PreparatoryUnitOperations,Status}],
		{{ObjectP[Object[Sample]]..},_,_}|{{(ObjectP[{Model[Sample],Object[Sample]}]|Null)..},{Except[Null]..},_}|{_,_,Canceled|Aborted}
	]

};

(* ::Subsection::Closed:: *)
(*validProtocolFilterQTests*)


validProtocolFlowCytometryQTests[packet:PacketP[Object[Protocol,FlowCytometry]]]:= {
	(* shared fields *)
	NullFieldTest[packet, {
		CO2PressureLog,
		ArgonPressureLog,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	NotNullFieldTest[packet, {
		ContainersIn,
		SamplesIn
	}],

	RequiredWhenCompleted[packet, {
		ContainersOut,
		SamplesOut
	}]

};

(* ::Subsection::Closed:: *)
(*validProtocolAlphaScreenQTests*)


validProtocolAlphaScreenQTests[packet:PacketP[Object[Protocol,AlphaScreen]]]:={
	(* shared fields adapted from validPlateReaderProtocolTests*)
	NullFieldTest[packet,{
		SamplesOut,
		ContainersOut,
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	NotNullFieldTest[packet,{
		PreparedPlate,
		Instrument,
		AssayPlates,
		ReadTemperature,
		ReadEquilibrationTime,
		PlateReaderMix,
		Gain,
		SettlingTime,
		ExcitationTime,
		DelayTime,
		IntegrationTime,
		ExcitationWavelength,
		EmissionWavelength,
		ReadDirection
	}],

	(* unique fields for AlphaScreen*)
	Test["ExcitationWavelength must be 680nm:",
		MatchQ[Lookup[packet,ExcitationWavelength],680. Nanometer],
		True
	],

	Test["If FocalHeight is not populated, then AutoFocalHeight must be True:",
		Or[
			NullQ[Lookup[packet, FocalHeight]] && TrueQ[Lookup[packet, AutoFocalHeight]],
			Not[NullQ[Lookup[packet, FocalHeight]]]
		],
		True
	],


	(* adapted from validProtocolFluorescenceIntensityQTests *)
	Test["If the protocol is completed, the length of Data should be equal to the length of SamplesIn unless a prepared plate is provided:",
		(*if the protocol is completed and it is not a prepared plate, MatchQ the length of Data and SamplesIn*)
		If[And[
			MatchQ[Lookup[packet,PreparedPlate],False],
			MatchQ[Lookup[packet,Status],Completed]
			],
			MatchQ[Length[DeleteCases[Lookup[packet,Data],Null]],Length[DeleteCases[Lookup[packet,SamplesIn],Null]]],
			True
		],
		True
	],


	(* Test for master switches: START *)
	(* If the switches are on, the relevant fields need to be populated.
	   If the switches are off, the relevant fields need to be Null.*)
	Test["If a template is provided for gain and focal height optimization, the gain and focal height optimization fields should be Null:",
		If[MatchQ[Lookup[packet,OpticsOptimizationTemplate],Except[Null]],
			MatchQ[Lookup[packet,{
				OptimizeGain,
				GainOptimizationSamples,
				GainOptimizationSamplesWell,
				TargetSaturationPercentage,
				NumberOfGainOptimizations,
				StartingGain,
				OptimizeGainValues,
				GainOptimizationPrimitives,
				GainOptimizationManipulation,
				GainOptimizationMethodFilePaths,
				GainOptimizationDataFileNames,
				GainOptimizationData,
				OptimizeFocalHeight,
				FocalHeightOptimizationSamples,
				FocalHeightOptimizationSamplesWell,
				FocalHeightStep,
				NumberOfFocalHeightOptimizations,
				StartingFocalHeight,
				OptimizeFocalHeightValues,
				FocalHeightOptimizationPrimitives,
				FocalHeightOptimizationManipulation,
				FocalHeightOptimizationMethodFilePaths,
				FocalHeightOptimizationDataFileNames,
				FocalHeightOptimizationData
			}],NullP|{}],
			True
		],
		True
	],

	Test["If OptimizeGain is False, the gain optimization fields should be Null:",
		If[MatchQ[Lookup[packet,OptimizeGain],False],
			MatchQ[Lookup[packet,{
				GainOptimizationSamples,
				GainOptimizationSamplesWell,
				TargetSaturationPercentage,
				NumberOfGainOptimizations,
				StartingGain,
				OptimizeGainValues,
				GainOptimizationPrimitives,
				GainOptimizationManipulation,
				GainOptimizationMethodFilePaths,
				GainOptimizationDataFileNames,
				GainOptimizationData
			}],NullP|{}],
			True
		],
		True
	],

	Test["If OptimizeFocalHeight is False, the focal height optimization fields should be Null:",
		If[MatchQ[Lookup[packet,OptimizeFocalHeight],False],
			MatchQ[Lookup[packet,{
				FocalHeightOptimizationSamples,
				FocalHeightOptimizationSamplesWell,
				FocalHeightStep,
				NumberOfFocalHeightOptimizations,
				StartingFocalHeight,
				OptimizeFocalHeightValues,
				FocalHeightOptimizationPrimitives,
				FocalHeightOptimizationManipulation,
				FocalHeightOptimizationMethodFilePaths,
				FocalHeightOptimizationDataFileNames,
				FocalHeightOptimizationData
			}],NullP|{}],
			True
		],
		True
	],


	Test["If there is no mixing, no mixing parameters are set:",
		If[MatchQ[Lookup[packet,PlateReaderMix],False],
			MatchQ[Lookup[packet,{
				PlateReaderMixMode,
				PlateReaderMixRate,
				PlateReaderMixTime,
				PlateReaderMixSchedule
			}],NullP],
			True
		],
		True
	],

	(* Test for master switches: END *)

	(* RequiredTogetherTest: START *)
	RequiredTogetherTest[packet, {PlateReaderMixMode,PlateReaderMixRate,PlateReaderMixTime,PlateReaderMixSchedule}],

	RequiredTogetherTest[packet, {MoatBuffer,MoatSize,MoatVolume}]

	(* RequiredTogetherTest: END *)

};


(* ::Subsection::Closed:: *)
(*validProtocolFluorescenceIntensityQTests*)


validProtocolFluorescenceIntensityQTests[packet:PacketP[{Object[Protocol,FluorescenceIntensity],Object[Protocol,FluorescenceKinetics],Object[Protocol,FluorescencePolarization],Object[Protocol,FluorescencePolarizationKinetics]}]]:=Join[
	validPlateReaderProtocolTests[packet],
	{
		NotNullFieldTest[packet,{ExcitationWavelengths,EmissionWavelengths,NumberOfReadings}]
	}
];


(* ::Subsection::Closed:: *)
(*validProtocolFluorescenceSpectroscopyQTests*)


validProtocolFluorescenceSpectroscopyQTests[packet:PacketP[Object[Protocol,FluorescenceSpectroscopy]]]:=Join[
	validPlateReaderProtocolTests[packet],
	{
		RequiredTogetherTest[packet,{ExcitationWavelength,MinEmissionWavelength,MaxEmissionWavelength}],
		RequiredTogetherTest[packet,{MinExcitationWavelength,MaxExcitationWavelength,EmissionWavelength}],

		Test["If performing a gain adjustment for an emission scan, the corresponding adjustment wavelength must be populated:",
			If[MatchQ[Lookup[packet,EmissionScanGainPercentage],PercentP],
				MatchQ[Lookup[packet,AdjustmentEmissionWavelength],DistanceP],
				True
			],
			True
		],

		Test["If performing a gain adjustment for an excitation scan, the corresponding adjustment wavelength must be populated:",
			If[MatchQ[Lookup[packet,ExcitationScanGainPercentage],PercentP],
				MatchQ[Lookup[packet,AdjustmentExcitationWavelength],DistanceP],
				True
			],
			True
		]
	}
];


(* ::Subsection::Closed:: *)
(*validProtocolFluorescenceThermodynamicsQTests*)


validProtocolFluorescenceThermodynamicsQTests[packet:PacketP[Object[Protocol,FluorescenceThermodynamics]]]:={

(* Shared fields which should be null *)
	NullFieldTest[packet,{
		SamplesOut,
		ContainersOut,
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	NotNullFieldTest[packet,{
	(* shared fields not null *)
		SamplesIn,
		ContainersIn,
	(* unique fields not null *)
		LiquidHandler,
		Thermocycler,
		LiquidHandlerProgram,
		ExcitationWavelength,
		ExcitationBandwidth,
		EmissionWavelength,
		EmissionBandwidth,

		TemperatureRampRate,
		EquilibrationTime,
		MinTemperature,
		MaxTemperature,

		AliquotVolumes,
		Complements,
		ComplementVolumes,
		Buffers,
		BufferVolumes,
		ReactionVolume,
		EquilibrationTime,

		AssayFilePath
	}],


(* Passive reference or intercalating dye *)
	RequiredTogetherTest[packet,{PassiveReference,PassiveReferenceVolume}],
	RequiredTogetherTest[packet,{Dye,DyeVolume}],

(* Temperature settings *)
	FieldComparisonTest[packet,{MinTemperature,MaxTemperature},LessEqual],

	Test["TemperatureRampOrder must contain only one entry, or two unique entries:",
		DeleteCases[Lookup[packet,TemperatureRampOrder],Null],
		{_}|({_,_}?DuplicateFreeQ)
	],

	Test["The complement concentrations listed in the second column of Complements match the concentrations listed in ComplementConcentrations:",
		(Lookup[packet,Complements])[[All,2]],
		Lookup[packet,ComplementConcentrations]
	],

	Test["The complement volumes listed in the third column of Complements match the volumes listed in ComplementVolumes:",
		(Lookup[packet,Complements])[[All,3]],
		Lookup[packet,ComplementVolumes]
	],

	Test["SamplesIn and AliquotVolumes have the same length:",
		Length[Lookup[packet,SamplesIn]],
		Length[Lookup[packet,AliquotVolumes]]
	],
	Test["SamplesIn and Complements have the same length:",
		Length[Lookup[packet,SamplesIn]],
		Length[Lookup[packet,Complements]]
	],
	Test["SamplesIn and ComplementVolumes have the same length:",
		Length[Lookup[packet,SamplesIn]],
		Length[Lookup[packet,ComplementVolumes]]
	],
	Test["SamplesIn and Buffers have the same length:",
		Length[Lookup[packet,SamplesIn]],
		Length[Lookup[packet,BufferVolumes]]
	],
	Test["SamplesIn and BufferVolumes have the same length:",
		Length[Lookup[packet,SamplesIn]],
		Length[Lookup[packet,BufferVolumes]]
	],

(* UPON COMPLETION *)
	RequiredWhenCompleted[packet,{
		Data,
		Buffers
	}],

	Test["If Data is informed, SamplesIn and Data have the same length:",
		Length[DeleteCases[Lookup[packet,Data],Null]],
		0|Length[Lookup[packet,SamplesIn]]
	],

	FieldSyncTest[Join[Download[Lookup[packet,Data]],{packet}],ExcitationWavelength],
	FieldSyncTest[Join[Download[Lookup[packet,Data]],{packet}],EmissionWavelength],
	FieldSyncTest[Join[Download[Lookup[packet,Data]],{packet}],ExcitationBandwidth],
	FieldSyncTest[Join[Download[Lookup[packet,Data]],{packet}],EmissionBandwidth]
};


(* ::Subsection::Closed:: *)
(*validProtocolFPLCQTests*)


validProtocolFPLCQTests[packet:PacketP[Object[Protocol,FPLC]]]:={
(* Shared field shaping *)
	NullFieldTest[packet,{
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	NotNullFieldTest[packet,{
		(* Shared field shaping *)
		ContainersIn,
		Instrument,
		(* specific to FPLC - Not Null Fields *)
		FlowRate,
		GradientMethods,
		SeparationMode,
		Scale,
		NumberOfInjections,
		SampleVolumes,
		Columns,
		Wavelengths,
		BufferA,
		BufferB
	}],

	(* Check that index-matched fields are of proper length *)
	Test[
		"The number of SampleVolumes must equal the number of SamplesIn:",
		SameLengthQ[Lookup[packet,SampleVolumes], Lookup[packet,SamplesIn]],
		True
	],

	Test[
		"The number of GradientMethods must equal the number of SamplesIn:",
		SameLengthQ[Lookup[packet,GradientMethods], Lookup[packet,SamplesIn]],
		True
	],

(* When Completed *)
	RequiredWhenCompleted[packet, {
		SamplesIn,
		Data,
		DataFilePath,
		MethodFilePath
	}],

	Test[
		"Unless the protocol is doing preparatory primitives, Samples In should be Informed if the Protocol is not Canceled or Aborted:",
		Lookup[packet,{SamplesIn,PreparatoryUnitOperations,Status}],
		{{ObjectP[Object[Sample]]..},_,_}|{{(ObjectP[{Model[Sample],Object[Sample]}]|Null)..},{Except[Null]..},_}|{_,_,Canceled|Aborted}
	]
};




(* ::Subsection::Closed:: *)
(*validProtocolFreezeCellsQTests*)


validProtocolFreezeCellsQTests[packet:PacketP[Object[Protocol,FreezeCells]]]:={

	(* Shared fields *)
	NullFieldTest[packet,{
		CO2PressureLog,
		ArgonPressureLog,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	(* Type specific fields *)
	NotNullFieldTest[packet,{
		Batches,
		FreezingMethods,
		Instruments,
		TransportFreezers,
		Tweezer
	}],

	RequiredTogetherTest[packet,{
		FreezingRates,
		Durations,
		ResidualTemperatures
	}],

	RequiredTogetherTest[packet,{
		FreezingContainers,
		Coolants
	}],

	RequiredTogetherTest[packet,{
		ControlledRateFreezerBatches,
		ControlledRateFreezerBatchLengths,
		ControlledRateFreezerInstrument,
		ControlledRateFreezerTransportCoolers,
		ControlledRateFreezerTransportTemperatures,
		ControlledRateFreezerStorageConditions,
		RunTimes
	}],

	RequiredTogetherTest[packet,{InsulatedCoolerBatches,
		InsulatedCoolerBatchLengths,
		InsulatedCoolerFreezingContainers,
		InsulatedCoolerCoolants,
		InsulatedCoolerFreezingConditions,
		InsulatedCoolerTransportCoolers,
		InsulatedCoolerTransportTemperatures,
		InsulatedCoolerStorageConditions
	}]
};


(* ::Subsection::Closed:: *)
(*validProtocolFlashChromatographyQTests*)


validProtocolFlashChromatographyQTests[packet:PacketP[Object[Protocol,FlashChromatography]]]:={

	NotNullFieldTest[packet,{
		BufferA,
		BufferB,
		SeparationMode,
		Detector,
		Column,
		LoadingType,
		LoadingAmount,
		MaxLoadingPercent,
		FlowRate,
		GradientA,
		GradientB,
		Gradient,
		CollectFractions,
		Detectors,
		ColumnStorageCondition
	}],

	(* Check that index-matched fields are of proper length *)
	Test[
		"The number of LoadingAmount must equal the number of SamplesIn:",
		SameLengthQ[Lookup[packet,LoadingAmount], Lookup[packet,SamplesIn]],
		True
	],

	Test[
		"The number of Column must equal the number of SamplesIn:",
		SameLengthQ[Lookup[packet,Column], Lookup[packet,SamplesIn]],
		True
	],

	(* When Completed *)
	RequiredWhenCompleted[packet, {
		SamplesIn,
		Data
	}],

	ResolvedWhenCompleted[
		packet,
		{
			BufferA,
			BufferB,
			Column
		}
	]
};






(* ::Subsection::Closed:: *)
(*validProtocolGasChromatographyQTests*)


validProtocolGasChromatographyQTests[packet:PacketP[Object[Protocol,GasChromatography]]]:= {

(* shared fields null *)
	(*
	NullFieldTest[packet,{
		SamplesOut,
		ContainersOut
	}],
	*)

	NotNullFieldTest[packet, {
		Instrument,
		CarrierGas,
		Inlet,
		InletLiner,
		LinerORing,
		InletORing,
		InletSeptum,
		Columns,
		ColumnsRequested,
		TrimColumn,
		ConditionColumn,
		Detector,
		SamplingMethod,
		SeparationMethod,
		InletSeptumPurgeFlowRate,
		InletMode,
		GCColumnMode,
		InjectionTable,
		ColumnAssembly,
		InitialColumnResidenceTime
	}],

	RequiredWhenCompleted[packet, {
		SamplesIn,
		Data
	}],

	(*RequiredTogetherTest[packet, {Variables}],*)

	(* Field Specific Tests *)

	Test["If a sample, standard or blank will be diluted, DilutionSolvents must contain a dilution solvent and a DilutionVolume must be specified:",
		{Or@@Flatten[Lookup[packet, {Dilute,StandardDilute,BlankDilute}]], Lookup[packet,{DilutionSolvent, SecondaryDilutionSolvent, TertiaryDilutionSolvent}],
			Lookup[packet, {DilutionSolventVolume, SecondaryDilutionSolventVolume, TertiaryDilutionSolventVolume,StandardDilutionSolventVolume, StandardSecondaryDilutionSolventVolume, StandardTertiaryDilutionSolventVolume,BlankDilutionSolventVolume, BlankSecondaryDilutionSolventVolume, BlankTertiaryDilutionSolventVolume}]},
		{True,Except[NullP|{{}...}],Except[NullP|{{}...}]}|{False,NullP|{{}...},NullP|{{}...}}
	],

	Test["If DilutionSolvent is specified, a DilutionSolvent and DilutionSolvent volume must be specified for a sample, standard or blank:",
		{Lookup[packet, DilutionSolvent], Flatten[Lookup[packet, {DilutionSolventVolume,StandardDilutionSolventVolume,BlankDilutionSolventVolume}]]},
		{NullP|{},NullP|{}}|{Except[NullP|{}],Except[NullP|{}]}
	],

	Test["If SecondaryDilutionSolvent is specified, a SecondaryDilutionSolvent and SecondaryDilutionSolvent volume must be specified for a sample, standard or blank:",
		{Lookup[packet, SecondaryDilutionSolvent], Flatten[Lookup[packet, {SecondaryDilutionSolventVolume,StandardSecondaryDilutionSolventVolume,BlankSecondaryDilutionSolventVolume}]]},
		{NullP|{},NullP|{}}|{Except[NullP|{}],Except[NullP|{}]}
	],

	Test["If TertiaryDilutionSolvent is specified, a TertiaryDilutionSolvent and TertiaryDilutionSolvent volume must be specified for a sample, standard or blank:",
		{Lookup[packet, TertiaryDilutionSolvent], Flatten[Lookup[packet, {TertiaryDilutionSolventVolume,StandardTertiaryDilutionSolventVolume,BlankTertiaryDilutionSolventVolume}]]},
		{NullP|{},NullP|{}}|{Except[NullP|{}],Except[NullP|{}]}
	],

	Test["If the sample will be vortexed, VortexMixRate and VortexTime must be specified:",
		And@@MapThread[
			MatchQ[{#1, #2, #3}, {Except[True],Null,Null}|{True,Except[Null],Except[Null]}]&,
			Lookup[packet, {Vortex, VortexMixRate, VortexTime}]/.({}->{Null})
		],
		True
	],

	Test["If the standard will be vortexed, StandardVortexMixRate and StandardVortexTime must be specified:",
		And@@MapThread[
			MatchQ[{#1, #2, #3}, {Except[True],Null,Null}|{True,Except[Null],Except[Null]}]&,
			Lookup[packet, {StandardVortex, StandardVortexMixRate, StandardVortexTime}]/.({}->{Null})
		],
		True
	],

	Test["If the blank will be vortexed, BlankVortexMixRate and BlankVortexTime must be specified:",
		And@@MapThread[
			MatchQ[{#1, #2, #3}, {Except[True],Null,Null}|{True,Except[Null],Except[Null]}]&,
			Lookup[packet, {BlankVortex, BlankVortexMixRate, BlankVortexTime}]/.({}->{Null})
		],
		True
	],

	Test["If the sample will be agitated, AgitationTime, AgitationTemperature, AgitationMixRate, AgitationOnTime and AgitationOffTime must be specified:",
		And@@MapThread[
			MatchQ[{#1, #2, #3, #4, #5, #6}, {Except[True],Null,Null,Null,Null,Null}|{True,Except[Null],Except[Null],Except[Null],Except[Null],Except[Null]}]&,
				Lookup[packet, {Agitate, AgitationTime, AgitationTemperature, AgitationMixRate, AgitationOnTime, AgitationOffTime}]/.({}->{Null})
		],
			True
	],

	Test["If the standard will be agitated, StandardAgitationTime, StandardAgitationTemperature, StandardAgitationMixRate, StandardAgitationOnTime and StandardAgitationOffTime must be specified:",
		And@@MapThread[
			MatchQ[{#1, #2, #3, #4, #5, #6}, {Except[True],Null,Null,Null,Null,Null}|{True,Except[Null],Except[Null],Except[Null],Except[Null],Except[Null]}]&,
			Lookup[packet, {StandardAgitate, StandardAgitationTime, StandardAgitationTemperature, StandardAgitationMixRate, StandardAgitationOnTime, StandardAgitationOffTime}]/.({}->{Null})
		],
		True
	],

	Test["If the blank will be agitated, BlankAgitationTime, BlankAgitationTemperature, BlankAgitationMixRate, BlankAgitationOnTime and BlankAgitationOffTime must be specified:",
		And@@MapThread[
			MatchQ[{#1, #2, #3, #4, #5, #6}, {Except[True],Null,Null,Null,Null,Null}|{True,Except[Null],Except[Null],Except[Null],Except[Null],Except[Null]}]&,
			Lookup[packet, {BlankAgitate, BlankAgitationTime, BlankAgitationTemperature, BlankAgitationMixRate, BlankAgitationOnTime, BlankAgitationOffTime}]/.({}->{Null})
		],
		True
	],

	Test["If any LiquidInjections are specified, a LiquidInjectionSyringe must be specified:",
		{Flatten[Lookup[packet, {SamplingMethod, StandardSamplingMethod, BlankSamplingMethod}]], Lookup[packet, LiquidInjectionSyringe]},
		{{Except[LiquidInjection]..},Null}|{Except[{Except[LiquidInjection]..}],Except[Null]}
	],

	Test["If the SamplingMethod is LiquidInjection, InjectionVolume, SampleAspirationRate, SampleInjectionRate must be specified:",
		And@@MapThread[
			MatchQ[{#1, #2, #3, #4}, {Except[LiquidInjection],_,_,_}|{LiquidInjection,Except[Null],Except[Null],Except[Null]}]&,
			Lookup[packet, {SamplingMethod, InjectionVolume, SampleAspirationRate, SampleInjectionRate}]/.({}->{Null})
		],
		True
	],

	Test["If the StandardSamplingMethod is LiquidInjection, StandardInjectionVolume, StandardSampleAspirationRate, StandardSampleInjectionRate must be specified:",
		And@@MapThread[
			MatchQ[{#1, #2, #3, #4}, {Except[LiquidInjection],_,_,_}|{LiquidInjection,Except[Null],Except[Null],Except[Null]}]&,
			Lookup[packet, {StandardSamplingMethod, StandardInjectionVolume, StandardSampleAspirationRate, StandardSampleInjectionRate}]/.({}->{Null})
		],
		True
	],

	Test["If the BlankSamplingMethod is LiquidInjection, BlankInjectionVolume, BlankSampleAspirationRate, BlankSampleInjectionRate must be specified:",
		And@@MapThread[
			MatchQ[{#1, #2, #3, #4}, {Except[LiquidInjection],_,_,_}|{LiquidInjection,Except[Null],Except[Null],Except[Null]}]&,
			Lookup[packet, {BlankSamplingMethod, BlankInjectionVolume, BlankSampleAspirationRate, BlankSampleInjectionRate}]/.({}->{Null})
		],
		True
	],

	Test["If any HeadspaceInjections are specified, a HeadspaceInjectionSyringe must be specified:",
		{Flatten[Lookup[packet, {SamplingMethod, StandardSamplingMethod, BlankSamplingMethod}]], Lookup[packet, HeadspaceInjectionSyringe]},
		{{Except[HeadspaceInjection]..},Null}|{Except[{Except[HeadspaceInjection]..}],Except[Null]}
	],

	Test["If the SamplingMethod is HeadspaceInjection, InjectionVolume, SampleAspirationRate, SampleInjectionRate must be specified:",
		And@@MapThread[
			MatchQ[{#1, #2, #3, #4}, {Except[HeadspaceInjection],_,_,_}|{HeadspaceInjection,Except[Null],Except[Null],Except[Null]}]&,
			Lookup[packet, {SamplingMethod, InjectionVolume, SampleAspirationRate, SampleInjectionRate}]/.({}->{Null})
		],
		True
	],

	Test["If the StandardSamplingMethod is HeadspaceInjection, StandardInjectionVolume, StandardSampleAspirationRate, StandardSampleInjectionRate must be specified:",
		And@@MapThread[
			MatchQ[{#1, #2, #3, #4}, {Except[HeadspaceInjection],_,_,_}|{HeadspaceInjection,Except[Null],Except[Null],Except[Null]}]&,
			Lookup[packet, {StandardSamplingMethod, StandardInjectionVolume, StandardSampleAspirationRate, StandardSampleInjectionRate}]/.({}->{Null})
		],
		True
	],

	Test["If the BlankSamplingMethod is HeadspaceInjection, BlankInjectionVolume, BlankSampleAspirationRate, BlankSampleInjectionRate must be specified:",
		And@@MapThread[
			MatchQ[{#1, #2, #3, #4}, {Except[HeadspaceInjection],_,_,_}|{HeadspaceInjection,Except[Null],Except[Null],Except[Null]}]&,
			Lookup[packet, {BlankSamplingMethod, BlankInjectionVolume, BlankSampleAspirationRate, BlankSampleInjectionRate}]/.({}->{Null})
		],
		True
	],

	Test["If any SPMEInjections are specified, a SPMEInjectionFiber must be specified:",
		{Flatten[Lookup[packet, {SamplingMethod, StandardSamplingMethod, BlankSamplingMethod}]], Lookup[packet, SPMEInjectionFiber]},
		{{Except[SPMEInjection]..},Null}|{Except[{Except[SPMEInjection]..}],Except[Null]}
	],

	Test["If the SamplingMethod is SPMEInjection, SPMECondition, SPMESampleExtractionTime, SPMESampleDesorptionTime must be specified:",
		And@@MapThread[
			MatchQ[{#1, #2, #3, #4}, {Except[SPMEInjection],Null,Null,Null}|{SPMEInjection,Except[Null],Except[Null],Except[Null]}]&,
			Lookup[packet, {SamplingMethod, SPMECondition, SPMESampleExtractionTime, SPMESampleDesorptionTime}]/.({}->{Null})
		],
		True
	],

	Test["If the StandardSamplingMethod is SPMEInjection, StandardSPMECondition, StandardSPMESampleExtractionTime, StandardSPMESampleDesorptionTime must be specified:",
		And@@MapThread[
			MatchQ[{#1, #2, #3, #4}, {Except[SPMEInjection],Null,Null,Null}|{SPMEInjection,Except[Null],Except[Null],Except[Null]}]&,
			Lookup[packet, {StandardSamplingMethod, StandardSPMECondition, StandardSPMESampleExtractionTime, StandardSPMESampleDesorptionTime}]/.({}->{Null})
		],
		True
	],

	Test["If the BlankSamplingMethod is SPMEInjection, BlankSPMECondition, BlankSPMESampleExtractionTime, BlankSPMESampleDesorptionTime must be specified:",
		And@@MapThread[
			MatchQ[{#1, #2, #3, #4}, {Except[SPMEInjection],Null,Null,Null}|{SPMEInjection,Except[Null],Except[Null],Except[Null]}]&,
			Lookup[packet, {BlankSamplingMethod, BlankSPMECondition, BlankSPMESampleExtractionTime, BlankSPMESampleDesorptionTime}]/.({}->{Null})
		],
		True
	],

	Test["If the InletMode is Split, SplitRatio or SplitVentFlowRate must be specified:",
		And@@MapThread[
			MatchQ[{#1, #2, #3}, {Except[Split],Null,Null}|{Split,Except[Null],Null}|{Split,Null,Except[Null]}]&,
			Lookup[packet, {InletMode, SplitRatio, SplitVentFlowRate}]/.({}->{Null})
		],
		True
	],

	Test["If the StandardInletMode is Split, StandardSplitRatio or StandardSplitVentFlowRate must be specified:",
		And@@MapThread[
			MatchQ[{#1, #2, #3}, {Except[Split],Null,Null}|{Split,Except[Null],Null}|{Split,Null,Except[Null]}]&,
			Lookup[packet, {StandardInletMode, StandardSplitRatio, StandardSplitVentFlowRate}]/.({}->{Null})
		],
		True
	],

	Test["If the BlankInletMode is Split, BlankSplitRatio or BlankSplitVentFlowRate must be specified:",
		And@@MapThread[
			MatchQ[{#1, #2, #3}, {Except[Split],Null,Null}|{Split,Except[Null],Null}|{Split,Null,Except[Null]}]&,
			Lookup[packet, {BlankInletMode, BlankSplitRatio, BlankSplitVentFlowRate}]/.({}->{Null})
		],
		True
	],

	Test["If the InletMode is Splitless, InletSeptumPurgeFlowRate and SplitlessTime must be specified:",
		And@@MapThread[
			MatchQ[{#1, #2, #3}, {Except[Splitless],_,Null}|{Splitless,Except[Null],Except[Null]}]&,
			Lookup[packet, {InletMode, InletSeptumPurgeFlowRate, SplitlessTime}]/.({}->{Null})
		],
		True
	],

	Test["If the StandardInletMode is Splitless, StandardInletSeptumPurgeFlowRate and StandardSplitlessTime must be specified:",
		And@@MapThread[
			MatchQ[{#1, #2, #3}, {Except[Splitless],_,Null}|{Splitless,Except[Null],Except[Null]}]&,
			Lookup[packet, {StandardInletMode, StandardInletSeptumPurgeFlowRate, StandardSplitlessTime}]/.({}->{Null})
		],
		True
	],

	Test["If the BlankInletMode is Splitless, BlankInletSeptumPurgeFlowRate and BlankSplitlessTime must be specified:",
		And@@MapThread[
			MatchQ[{#1, #2, #3}, {Except[Splitless],_,Null}|{Splitless,Except[Null],Except[Null]}]&,
			Lookup[packet, {BlankInletMode, BlankInletSeptumPurgeFlowRate, BlankSplitlessTime}]/.({}->{Null})
		],
		True
	],

	Test["If the InletType is SplitSplitless, SolventEliminationFlowRate must not be specified:",
		Lookup[packet,{Inlet,SolventEliminationFlowRate}],
		{Except[SplitSplitless],{___}}|{SplitSplitless,NullP|{}}
	],

	Test["If the GasSaver is True, GasSaverFlowrate and GasSaverTime must be specified:",
		And@@MapThread[
			MatchQ[{#1, #2, #3}, {Except[True],Null,Null}|{True,Except[Null],Except[Null]}]&,
			Lookup[packet, {GasSaver, GasSaverFlowRate, GasSaverActivationTime}]/.({}->{Null})
		],
		True
	],

	Test["If the StandardGasSaver is True, StandardGasSaverFlowRate and StandardGasSaverTime must be specified:",
		And@@MapThread[
			MatchQ[{#1, #2, #3}, {Except[True],Null,Null}|{True,Except[Null],Except[Null]}]&,
			Lookup[packet, {StandardGasSaver, StandardGasSaverFlowRate, StandardGasSaverActivationTime}]/.({}->{Null})
		],
		True
	],

	Test["If the BlankGasSaver is True, BlankGasSaverFlowRate and BlankGasSaverTime must be specified:",
		And@@MapThread[
			MatchQ[{#1, #2, #3}, {Except[True],Null,Null}|{True,Except[Null],Except[Null]}]&,
			Lookup[packet, {BlankGasSaver, BlankGasSaverFlowRate, BlankGasSaverActivationTime}]/.({}->{Null})
		],
		True
	],

	Test["If ConditionColumn is True, ColumnConditioningGas, ColumnConditioningTime and ColumnConditioningTemperature must be specified:",
		{Lookup[packet,ConditionColumn],Lookup[packet,{ColumnConditioningGas, ColumnConditioningTime, ColumnConditioningTemperature}]},
		{True,{Except[Null],Except[Null],Except[Null]}}|{Except[True],_}
	],

	RequiredTogetherTest[packet, {PostRunOvenTime,PostRunOvenTemperature}],

	(* Detector options *)

	Test["If the Detector is FlameIonizationDetector, FIDTemperature, FIDAirFlowrate, FIDH2Flowrate, FIDMakeupGasFlowrate, CarrierGasFlowCorrection must be specified:",
		{Lookup[packet,Detector],Lookup[packet,{FIDTemperature,FIDAirFlowRate,FIDDihydrogenFlowRate,FIDMakeupGasFlowRate,CarrierGasFlowCorrection}]},
		{FlameIonizationDetector,{Except[Null],Except[Null],Except[Null],Except[Null],Except[Null]}}|{Except[FlameIonizationDetector],_}
	],

	Test["If the Detector is not FlameIonizationDetector, FIDTemperature, FIDAirFlowrate, FIDH2Flowrate, FIDMakeupGasFlowrate, CarrierGasFlowCorrection must not be specified:",
		{Lookup[packet,Detector],Lookup[packet,{FIDTemperature,FIDAirFlowRate,FIDDihydrogenFlowRate,FIDMakeupGasFlowRate,CarrierGasFlowCorrection}]},
		{Except[FlameIonizationDetector],{Null,Null,Null,Null,Null}}|{FlameIonizationDetector,_}
	],

	Test["If the Detector is FlameIonizationDetector, the FID data collection frequency must be specified:",
		{Lookup[packet,{Detector,FIDDataCollectionFrequency}]},
		{{FlameIonizationDetector,GreaterP[0 Hertz]}|{Except[FlameIonizationDetector],Null}}
	],

	Test["If the Detector is MSD, TransferLineTemperature, IonSource, IonMode, SourceTemperature, QuadrupoleTemperature, SolventDelay, AcquisitionWindowStartTimes, MassRanges, MassRangeScanSpeeds, MassSelections must be specified:",
		{Lookup[packet,Detector],Lookup[packet,{TransferLineTemperature, IonSource, IonMode, SourceTemperature, QuadrupoleTemperature, SolventDelay, AcquisitionWindowStartTimes, MassRanges, MassRangeScanSpeeds, MassSelections}]},
		{MassSpectrometer,{Except[Null],Except[Null],Except[Null],Except[Null],Except[Null],Except[Null],Except[{}],Except[{}],Except[{}],Except[{}]}}|{Except[MassSpectrometer],__}
	],

	Test["If the Detector is not MSD, TransferLineTemperature, IonSource, IonMode, SourceTemperature, QuadrupoleTemperature, SolventDelay, AcquisitionWindowStartTimes, MassRanges, MassRangeScanSpeeds, MassSelections must not be specified:",
		{Lookup[packet,Detector],Lookup[packet,{TransferLineTemperature, IonSource, IonMode, SourceTemperature, QuadrupoleTemperature, SolventDelay, AcquisitionWindowStartTimes, MassRanges, MassRangeScanSpeeds, MassSelections}]},
		{Except[MassSpectrometer],{Null,Null,Null,Null,Null,Null,{},{},{},{}}}|{MassSpectrometer,__}
	],

	Test["MassSelectionResolutions, MassSelectionDetectionGains and MassSelections are specified together, if the Detector is MSD:",
		Lookup[packet,{Detector, MassSelectionResolutions, MassSelectionDetectionGains, MassSelections}],
		{_,{}|NullP,{}|NullP,{}|NullP}|{MassSpectrometer,Except[{}|NullP],Except[{}|NullP],Except[{}|NullP]}
	]


};


(* ::Subsection::Closed:: *)
(*validProtocolGrindQTests*)


validProtocolGrindQTests[packet:PacketP[Object[Protocol, Grind]]]:={

	(* Required fields *)
	NotNullFieldTest[packet,
		{
			(* required shared fields *)
			SamplesIn,
			Amounts,
			ContainersOut,

			(* required specific fields *)
			BulkDensities,
			CoolingTimes,
			Finenesses,
			GrinderTypes,
			GrinderTypes,
			GrindingContainers,
			GrindingProfiles,
			GrindingRates,
			Instruments,
			NumbersOfGrindingSteps,
			SamplesOutStorageConditions,
			Times
		}
	],

	NullFieldTest[packet, {
		Data,
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	(* required fields if GrinderType is BallMill *)
	Test["If GrinderType is set to BallMill, GrindingBeads and NumbersOfGrindingBeads must be informed:",
		MapThread[If[
			MatchQ[#1, BallMill],
			!NullQ[#2] && !NullQ[#3],
			True
		]&, {Lookup[packet, GrinderTypes], Lookup[packet, GrindingBeads], Lookup[packet, NumbersOfGrindingBeads]}],
		{True..}
	],

	(*Upon Completion*)
	RequiredWhenCompleted[packet, {
		(* required shared fields *)
		SamplesOut
	}],

	Test["If the protocol is completed, GrindingVideos must be informed if GrinderType is set to MortarGrinder:",
		If[
			And[
				MatchQ[Lookup[packet, Status], Completed],
				MemberQ[Lookup[packet, GrinderTypes], MortarGrinder]
			],
			!MatchQ[Lookup[packet, GrindingVideos], NullP|{}],
			True
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validProtocolHPLCQTests*)


validProtocolHPLCQTests[packet:PacketP[Object[Protocol,HPLC]]]:={

(* Shared field shaping *)
	NotNullFieldTest[packet, {
		ContainersIn,
		BufferA,
		BufferB,
		BufferC,
		Columns,
		SampleVolumes,
		Gradients,
		SeparationMode,
		Scale,
		SystemPrimeBufferA,
		SystemPrimeBufferB,
		SystemPrimeBufferC,
		SystemFlushBufferA,
		SystemFlushBufferB,
		SystemFlushBufferC,
		SystemPrimeGradient,
		ColumnSelectorAssembly,
		MinPressure,
		MaxPressure
	}],

	NullFieldTest[packet,{
		CO2PressureLog,
		ArgonPressureLog,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	RequiredWhenCompleted[
		packet,
		{
			SamplesIn,
			Data,
			SystemPrimeData,
			SystemFlushData,
			EnvironmentalData,
			MinPressure,
			MaxPressure,
			AutosamplerDeckPlacements,
			InitialAnalyteVolumes,
			FinalAnalyteVolumes,
			InjectedAnalyteVolumes,
			FinalAnalyteVolumes,
			InjectionTable,
			Instrument,
			Detectors,
			InitialSystemPrimeBufferAAppearance,
			InitialSystemPrimeBufferBAppearance,
			InitialSystemPrimeBufferCAppearance,
			FinalSystemPrimeBufferAAppearance,
			FinalSystemPrimeBufferBAppearance,
			FinalSystemPrimeBufferCAppearance,
			InitialBufferAAppearance,
			InitialBufferBAppearance,
			InitialBufferCAppearance,
			FinalBufferAAppearance,
			FinalBufferBAppearance,
			FinalBufferCAppearance,
			InitialSystemFlushBufferAAppearance,
			InitialSystemFlushBufferBAppearance,
			InitialSystemFlushBufferCAppearance,
			FinalSystemFlushBufferAAppearance,
			FinalSystemFlushBufferBAppearance,
			FinalSystemFlushBufferCAppearance
		}
	],
	ResolvedWhenCompleted[
		packet,
		{
			BufferA,
			BufferB,
			BufferC
		}
	],

	(* Gradient Split Field Checks *)
	Test["Only one of GradientA and IsocraticGradientA can be specified:",
		And@@MapThread[
			MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
			{Lookup[packet,GradientA],Lookup[packet,IsocraticGradientA]}
		],
		True
	],
	Test["Only one of GradientB and IsocraticGradientB can be specified:",
		And@@MapThread[
			MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
			{Lookup[packet,GradientB],Lookup[packet,IsocraticGradientB]}
		],
		True
	],
	Test["Only one of GradientC and IsocraticGradientC can be specified:",
		And@@MapThread[
			MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
			{Lookup[packet,GradientC],Lookup[packet,IsocraticGradientC]}
		],
		True
	],
	Test["Only one of GradientD and IsocraticGradientD can be specified:",
		And@@MapThread[
			MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
			{Lookup[packet,GradientD],Lookup[packet,IsocraticGradientD]}
		],
		True
	],
	Test["Only one of FlowRateVariable and FlowRateConstant can be specified:",
		And@@MapThread[
			MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
			{Lookup[packet,FlowRateVariable],Lookup[packet,FlowRateConstant]}
		],
		True
	],

	(* Column Prime Gradient Split Field Checks *)
	If[!NullQ[Lookup[packet,ColumnPrimeGradients]]&&!MatchQ[Lookup[packet,ColumnPrimeGradients],{}],
		{
			Test["Only one of ColumnPrimeGradientAs and ColumnPrimeIsocraticGradientAs can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,ColumnPrimeGradientAs],Lookup[packet,ColumnPrimeIsocraticGradientAs]}
				],
				True
			],
			Test["Only one of ColumnPrimeGradientBs and ColumnPrimeIsocraticGradientBs can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,ColumnPrimeGradientBs],Lookup[packet,ColumnPrimeIsocraticGradientBs]}
				],
				True
			],
			Test["Only one of ColumnPrimeGradientCs and ColumnPrimeIsocraticGradientCs can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,ColumnPrimeGradientCs],Lookup[packet,ColumnPrimeIsocraticGradientCs]}
				],
				True
			],
			Test["Only one of ColumnPrimeGradientDs and ColumnPrimeIsocraticGradientDs can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,ColumnPrimeGradientDs],Lookup[packet,ColumnPrimeIsocraticGradientDs]}
				],
				True
			],
			Test["Only one of ColumnPrimeFlowRateVariable and ColumnPrimeFlowRateConstant can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,ColumnPrimeFlowRateVariable],Lookup[packet,ColumnPrimeFlowRateConstant]}
				],
				True
			]
		},
		NullFieldTest[packet,{ColumnPrimeGradientAs,ColumnPrimeIsocraticGradientAs,ColumnPrimeGradientBs,ColumnPrimeIsocraticGradientBs,ColumnPrimeGradientCs,ColumnPrimeIsocraticGradientCs,ColumnPrimeGradientDs,ColumnPrimeIsocraticGradientDs,ColumnPrimeFlowRateVariable,ColumnPrimeFlowRateConstant,ColumnPrimeAbsorbanceWavelengths,ColumnPrimeMinAbsorbanceWavelengths,ColumnPrimeMaxAbsorbanceWavelengths,ColumnPrimeWavelengthResolutions,ColumnPrimeUVFilters,ColumnPrimeAbsorbanceSamplingRates,ColumnPrimeExcitationWavelengths,ColumnPrimeSecondaryExcitationWavelengths,ColumnPrimeTertiaryExcitationWavelengths,ColumnPrimeQuaternaryExcitationWavelengths,ColumnPrimeEmissionWavelengths,ColumnPrimeSecondaryEmissionWavelengths,ColumnPrimeTertiaryEmissionWavelengths,ColumnPrimeQuaternaryEmissionWavelengths,ColumnPrimeEmissionCutOffFilters,ColumnPrimeFluorescenceGains,ColumnPrimeSecondaryFluorescenceGains,ColumnPrimeTertiaryFluorescenceGains,ColumnPrimeQuaternaryFluorescenceGains,ColumnPrimeFluorescenceFlowCellTemperatures,ColumnPrimeLightScatteringLaserPowers,ColumnPrimeLightScatteringFlowCellTemperatures,ColumnPrimeRefractiveIndexMethods,ColumnPrimeRefractiveIndexFlowCellTemperatures, ColumnPrimeNebulizerGases, ColumnPrimeNebulizerGasPressures, ColumnPrimeNebulizerGasHeatings, ColumnPrimeNebulizerHeatingPowers, ColumnPrimeDriftTubeTemperatures, ColumnPrimeELSDGains, ColumnPrimeELSDSamplingRates}]
	],
	
	(* Column Flush Gradient Split Field Checks *)
	If[!NullQ[Lookup[packet,ColumnFlushGradients]]&&!MatchQ[Lookup[packet,ColumnFlushGradients],{}],
		{
			Test["Only one of ColumnFlushGradientAs and ColumnFlushIsocraticGradientAs can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,ColumnFlushGradientAs],Lookup[packet,ColumnFlushIsocraticGradientAs]}
				],
				True
			],
			Test["Only one of ColumnFlushGradientBs and ColumnFlushIsocraticGradientBs can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,ColumnFlushGradientBs],Lookup[packet,ColumnFlushIsocraticGradientBs]}
				],
				True
			],
			Test["Only one of ColumnFlushGradientCs and ColumnFlushIsocraticGradientCs can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,ColumnFlushGradientCs],Lookup[packet,ColumnFlushIsocraticGradientCs]}
				],
				True
			],
			Test["Only one of ColumnFlushGradientDs and ColumnFlushIsocraticGradientDs can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,ColumnFlushGradientDs],Lookup[packet,ColumnFlushIsocraticGradientDs]}
				],
				True
			],
			Test["Only one of ColumnFlushFlowRateVariable and ColumnFlushFlowRateConstant can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,ColumnFlushFlowRateVariable],Lookup[packet,ColumnFlushFlowRateConstant]}
				],
				True
			]
		},
		NullFieldTest[packet,{ColumnFlushGradientAs,ColumnFlushIsocraticGradientAs,ColumnFlushGradientBs,ColumnFlushIsocraticGradientBs,ColumnFlushGradientCs,ColumnFlushIsocraticGradientCs,ColumnFlushGradientDs,ColumnFlushIsocraticGradientDs,ColumnFlushFlowRateVariable,ColumnFlushFlowRateConstant,ColumnFlushAbsorbanceWavelengths, ColumnFlushMinAbsorbanceWavelengths, ColumnFlushMaxAbsorbanceWavelengths, ColumnFlushWavelengthResolutions, ColumnFlushUVFilters, ColumnFlushAbsorbanceSamplingRates, ColumnFlushExcitationWavelengths, ColumnFlushSecondaryExcitationWavelengths, ColumnFlushTertiaryExcitationWavelengths, ColumnFlushQuaternaryExcitationWavelengths, ColumnFlushEmissionWavelengths, ColumnFlushSecondaryEmissionWavelengths, ColumnFlushTertiaryEmissionWavelengths, ColumnFlushQuaternaryEmissionWavelengths, ColumnFlushEmissionCutOffFilters, ColumnFlushFluorescenceGains, ColumnFlushSecondaryFluorescenceGains, ColumnFlushTertiaryFluorescenceGains, ColumnFlushQuaternaryFluorescenceGains, ColumnFlushFluorescenceFlowCellTemperatures, ColumnFlushLightScatteringLaserPowers, ColumnFlushLightScatteringFlowCellTemperatures, ColumnFlushRefractiveIndexMethods, ColumnFlushRefractiveIndexFlowCellTemperatures, ColumnFlushNebulizerGases, ColumnFlushNebulizerGasPressures, ColumnFlushNebulizerGasHeatings, ColumnFlushNebulizerHeatingPowers, ColumnFlushDriftTubeTemperatures, ColumnFlushELSDGains, ColumnFlushELSDSamplingRates}]
	],

	(* Standard Gradient Split Field Checks *)
	If[!NullQ[Lookup[packet,StandardGradients]],
		{
			Test["Only one of StandardGradientA and StandardIsocraticGradientA can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,StandardGradientA],Lookup[packet,StandardIsocraticGradientA]}
				],
				True
			],
			Test["Only one of StandardGradientB and StandardIsocraticGradientB can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,StandardGradientB],Lookup[packet,StandardIsocraticGradientB]}
				],
				True
			],
			Test["Only one of StandardGradientC and StandardIsocraticGradientC can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,StandardGradientC],Lookup[packet,StandardIsocraticGradientC]}
				],
				True
			],
			Test["Only one of StandardGradientD and StandardIsocraticGradientD can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,StandardGradientD],Lookup[packet,StandardIsocraticGradientD]}
				],
				True
			],
			Test["Only one of StandardFlowRateVariable and StandardFlowRateConstant can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,StandardFlowRateVariable],Lookup[packet,StandardFlowRateConstant]}
				],
				True
			]
		},
		NullFieldTest[packet,{StandardGradientA,StandardIsocraticGradientA,StandardGradientB,StandardIsocraticGradientB,StandardGradientC,StandardIsocraticGradientC,StandardGradientD,StandardIsocraticGradientD,StandardFlowRateVariable,StandardFlowRateConstant,StandardAbsorbanceWavelength, StandardMinAbsorbanceWavelength, StandardMaxAbsorbanceWavelength, StandardWavelengthResolution, StandardUVFilter, StandardAbsorbanceSamplingRate, StandardExcitationWavelengths, StandardSecondaryExcitationWavelengths, StandardTertiaryExcitationWavelengths, StandardQuaternaryExcitationWavelengths, StandardEmissionWavelengths, StandardSecondaryEmissionWavelengths, StandardTertiaryEmissionWavelengths, StandardQuaternaryEmissionWavelengths, StandardEmissionCutOffFilters, StandardFluorescenceGains, StandardSecondaryFluorescenceGains, StandardTertiaryFluorescenceGains, StandardQuaternaryFluorescenceGains, StandardFluorescenceFlowCellTemperatures, StandardLightScatteringLaserPowers, StandardLightScatteringFlowCellTemperatures, StandardRefractiveIndexMethods, StandardRefractiveIndexFlowCellTemperatures,StandardNebulizerGas, StandardNebulizerGasPressure, StandardNebulizerGasHeating, StandardNebulizerHeatingPower, StandardDriftTubeTemperature, StandardELSDGain, StandardELSDSamplingRate, StandardsStorageConditions}]
	],

	(* Blank Gradient Split Field Checks *)
	If[!NullQ[Lookup[packet,BlankGradients]],
		{
			Test["Only one of BlankGradientA and BlankIsocraticGradientA can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,BlankGradientA],Lookup[packet,BlankIsocraticGradientA]}
				],
				True
			],
			Test["Only one of BlankGradientB and BlankIsocraticGradientB can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,BlankGradientB],Lookup[packet,BlankIsocraticGradientB]}
				],
				True
			],
			Test["Only one of BlankGradientC and BlankIsocraticGradientC can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,BlankGradientC],Lookup[packet,BlankIsocraticGradientC]}
				],
				True
			],
			Test["Only one of BlankGradientD and BlankIsocraticGradientD can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,BlankGradientD],Lookup[packet,BlankIsocraticGradientD]}
				],
				True
			],
			Test["Only one of BlankFlowRateVariable and BlankFlowRateConstant can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,BlankFlowRateVariable],Lookup[packet,BlankFlowRateConstant]}
				],
				True
			]
		},
		NullFieldTest[packet,{BlankGradientA,BlankIsocraticGradientA,BlankGradientB,BlankIsocraticGradientB,BlankGradientC,BlankIsocraticGradientC,BlankGradientD,BlankIsocraticGradientD,BlankFlowRateVariable,BlankFlowRateConstant,BlankAbsorbanceWavelength, BlankMinAbsorbanceWavelength, BlankMaxAbsorbanceWavelength, BlankWavelengthResolution, BlankUVFilter, BlankAbsorbanceSamplingRate, BlankExcitationWavelengths, BlankSecondaryExcitationWavelengths, BlankTertiaryExcitationWavelengths, BlankQuaternaryExcitationWavelengths, BlankEmissionWavelengths, BlankSecondaryEmissionWavelengths, BlankTertiaryEmissionWavelengths, BlankQuaternaryEmissionWavelengths, BlankEmissionCutOffFilters, BlankFluorescenceGains, BlankSecondaryFluorescenceGains, BlankTertiaryFluorescenceGains, BlankQuaternaryFluorescenceGains, BlankFluorescenceFlowCellTemperatures, BlankLightScatteringLaserPowers, BlankLightScatteringFlowCellTemperatures, BlankRefractiveIndexMethods, BlankRefractiveIndexFlowCellTemperatures, BlankNebulizerGas, BlankNebulizerGasPressure, BlankNebulizerGasHeating, BlankNebulizerHeatingPower, BlankDriftTubeTemperature, BlankELSDGain, BlankELSDSamplingRate, BlanksStorageConditions}]
	],

	Module[{instrument,instrumentModel},
		instrument=Lookup[packet,Instrument];
		instrumentModel=If[MatchQ[instrument,ObjectP[Object[Instrument,HPLC]]],Download[instrument,Model],instrument];
		If[MatchQ[Download[instrumentModel,NumberOfBuffers],4],
			{
				NotNullFieldTest[packet, {
					BufferD,
					SystemPrimeBufferD,
					SystemFlushBufferD
				}],
				ResolvedWhenCompleted[
					packet,
					{
						BufferD,
						SystemPrimeBufferD,
						SystemFlushBufferD
					}
				],
				RequiredWhenCompleted[
					packet,
					{
						InitialSystemPrimeBufferDAppearance,
						FinalSystemPrimeBufferDAppearance,
						InitialBufferDAppearance,
						FinalBufferDAppearance,
						InitialSystemFlushBufferDAppearance,
						FinalSystemFlushBufferDAppearance
					}
				]
			},
			NullFieldTest[packet, {
				BufferD,
				SystemPrimeBufferD,
				SystemFlushBufferD
			}]
		]
	],

	Test["If FractionCollection is set to True, FractionCollectionDetector must be specified:",
		Xnor[MatchQ[Lookup[packet,FractionCollection],True],!NullQ[Lookup[packet,FractionCollectionDetector]]],
		True
	],

	Test["If FractionCollection is set to True, NumberOfFractionContainers must be specified:",
		If[MatchQ[Lookup[packet,FractionCollection],True],!NullQ[Lookup[packet,NumberOfFractionContainers]],True],
		True
	],

	Test["FractionCollectionDetector is a member of Detectors:",
		If[!NullQ[Lookup[packet,FractionCollectionDetector]],
			MemberQ[Lookup[packet,Detectors],Lookup[packet,FractionCollectionDetector]],
			True
		],
		True
	],

	(* pH Calibration *)
	If[MatchQ[Lookup[packet,pHCalibration],True],
		NotNullFieldTest[packet,{
			LowpHCalibrationBuffer,
			HighpHCalibrationBuffer,
			LowpHCalibrationTarget,
			HighpHCalibrationTarget
		}],
		NullFieldTest[packet,{
			LowpHCalibrationBuffer,
			HighpHCalibrationBuffer,
			LowpHCalibrationTarget,
			HighpHCalibrationTarget
		}]
	],

	(* pH Calibration *)
	If[MatchQ[Lookup[packet,ConductivityCalibration],True],
		NotNullFieldTest[packet,{
			ConductivityCalibrationBuffer,
			ConductivityCalibrationTarget
		}],
		NullFieldTest[packet,{
			ConductivityCalibration,
			ConductivityCalibrationBuffer,
			ConductivityCalibrationTarget
		}]
	],

	(* pH Detector *)
	If[MemberQ[Lookup[packet,Detectors],pH],
		NotNullFieldTest[packet,{
			pHCalibration,
			pHTemperatureCompensation
		}],
		NullFieldTest[packet,{
			pHCalibration,
			pHTemperatureCompensation
		}]
	],

	(* Conductance Detector *)
	If[MemberQ[Lookup[packet,Detectors],Conductance],
		NotNullFieldTest[packet,{
			ConductivityCalibration,
			ConductivityTemperatureCompensation
		}],
		NullFieldTest[packet,{
			ConductivityCalibration,
			ConductivityTemperatureCompensation
		}]
	],

	(*make sure that all of the fluorescence parameters are populated*)
	If[MemberQ[Lookup[packet,Detectors],Fluorescence],
		{
			NotNullFieldTest[packet, {
				ExcitationWavelengths,
				EmissionWavelengths,
				FluorescenceGains
			}],
			RequiredTogetherTest[packet, {ColumnPrimeExcitationWavelengths, ColumnPrimeEmissionWavelengths,ColumnPrimeFluorescenceGains}],
			RequiredTogetherTest[packet, {StandardExcitationWavelengths,StandardEmissionWavelengths,StandardFluorescenceGains}],
			RequiredTogetherTest[packet, {BlankExcitationWavelengths,BlankEmissionWavelengths,BlankFluorescenceGains}],
			RequiredTogetherTest[packet, {ColumnFlushExcitationWavelengths, ColumnFlushEmissionWavelengths,ColumnFlushFluorescenceGains}],
			RequiredTogetherTest[packet, {ColumnPrimeSecondaryExcitationWavelengths, ColumnPrimeSecondaryEmissionWavelengths,ColumnPrimeSecondaryFluorescenceGains}],
			RequiredTogetherTest[packet, {ColumnPrimeTertiaryExcitationWavelengths, ColumnPrimeTertiaryEmissionWavelengths,ColumnPrimeTertiaryFluorescenceGains}],
			RequiredTogetherTest[packet, {ColumnPrimeQuaternaryExcitationWavelengths, ColumnPrimeQuaternaryEmissionWavelengths,ColumnPrimeQuaternaryFluorescenceGains}],
			RequiredTogetherTest[packet, {SecondaryExcitationWavelengths, SecondaryEmissionWavelengths,SecondaryFluorescenceGains}],
			RequiredTogetherTest[packet, {TertiaryExcitationWavelengths, TertiaryEmissionWavelengths,TertiaryFluorescenceGains}],
			RequiredTogetherTest[packet, {QuaternaryExcitationWavelengths, QuaternaryEmissionWavelengths,QuaternaryFluorescenceGains}],
			RequiredTogetherTest[packet, {StandardSecondaryExcitationWavelengths, StandardSecondaryEmissionWavelengths,StandardSecondaryFluorescenceGains}],
			RequiredTogetherTest[packet, {StandardTertiaryExcitationWavelengths, StandardTertiaryEmissionWavelengths,StandardTertiaryFluorescenceGains}],
			RequiredTogetherTest[packet, {StandardQuaternaryExcitationWavelengths, StandardQuaternaryEmissionWavelengths,StandardQuaternaryFluorescenceGains}],
			RequiredTogetherTest[packet, {BlankSecondaryExcitationWavelengths, BlankSecondaryEmissionWavelengths,BlankSecondaryFluorescenceGains}],
			RequiredTogetherTest[packet, {BlankTertiaryExcitationWavelengths, BlankTertiaryEmissionWavelengths,BlankTertiaryFluorescenceGains}],
			RequiredTogetherTest[packet, {BlankQuaternaryExcitationWavelengths, BlankQuaternaryEmissionWavelengths,BlankQuaternaryFluorescenceGains}],
			RequiredTogetherTest[packet, {ColumnFlushSecondaryExcitationWavelengths, ColumnFlushSecondaryEmissionWavelengths,ColumnFlushSecondaryFluorescenceGains}],
			RequiredTogetherTest[packet, {ColumnFlushTertiaryExcitationWavelengths, ColumnFlushTertiaryEmissionWavelengths,ColumnFlushTertiaryFluorescenceGains}],
			RequiredTogetherTest[packet, {ColumnFlushQuaternaryExcitationWavelengths, ColumnFlushQuaternaryEmissionWavelengths,ColumnFlushQuaternaryFluorescenceGains}]
		},
		NullFieldTest[packet,{
			ColumnPrimeExcitationWavelengths,
			ColumnPrimeSecondaryExcitationWavelengths,
			ColumnPrimeTertiaryExcitationWavelengths,
			ColumnPrimeQuaternaryExcitationWavelengths,
			ColumnPrimeEmissionWavelengths,
			ColumnPrimeSecondaryEmissionWavelengths,
			ColumnPrimeTertiaryEmissionWavelengths,
			ColumnPrimeQuaternaryEmissionWavelengths,
			ColumnPrimeEmissionCutOffFilters,
			ColumnPrimeFluorescenceGains,
			ColumnPrimeSecondaryFluorescenceGains,
			ColumnPrimeTertiaryFluorescenceGains,
			ColumnPrimeQuaternaryFluorescenceGains,
			ColumnPrimeFluorescenceFlowCellTemperatures,
			ExcitationWavelengths,
			SecondaryExcitationWavelengths,
			TertiaryExcitationWavelengths,
			QuaternaryExcitationWavelengths,
			EmissionWavelengths,
			SecondaryEmissionWavelengths,
			TertiaryEmissionWavelengths,
			QuaternaryEmissionWavelengths,
			FluorescenceGains,
			SecondaryFluorescenceGains,
			TertiaryFluorescenceGains,
			QuaternaryFluorescenceGains,
			EmissionCutOffFilters,
			FluorescenceFlowCellTemperatures,
			StandardExcitationWavelengths,
			StandardSecondaryExcitationWavelengths,
			StandardTertiaryExcitationWavelengths,
			StandardQuaternaryExcitationWavelengths,
			StandardEmissionWavelengths,
			StandardSecondaryEmissionWavelengths,
			StandardTertiaryEmissionWavelengths,
			StandardQuaternaryEmissionWavelengths,
			StandardEmissionCutOffFilters,
			StandardFluorescenceGains,
			StandardSecondaryFluorescenceGains,
			StandardTertiaryFluorescenceGains,
			StandardQuaternaryFluorescenceGains,
			StandardFluorescenceFlowCellTemperatures,
			BlankExcitationWavelengths,
			BlankSecondaryExcitationWavelengths,
			BlankTertiaryExcitationWavelengths,
			BlankQuaternaryExcitationWavelengths,
			BlankEmissionWavelengths,
			BlankSecondaryEmissionWavelengths,
			BlankTertiaryEmissionWavelengths,
			BlankQuaternaryEmissionWavelengths,
			BlankEmissionCutOffFilters,
			BlankFluorescenceGains,
			BlankSecondaryFluorescenceGains,
			BlankTertiaryFluorescenceGains,
			BlankQuaternaryFluorescenceGains,
			BlankFluorescenceFlowCellTemperatures,
			ColumnFlushExcitationWavelengths,
			ColumnFlushSecondaryExcitationWavelengths,
			ColumnFlushTertiaryExcitationWavelengths,
			ColumnFlushQuaternaryExcitationWavelengths,
			ColumnFlushEmissionWavelengths,
			ColumnFlushSecondaryEmissionWavelengths,
			ColumnFlushTertiaryEmissionWavelengths,
			ColumnFlushQuaternaryEmissionWavelengths,
			ColumnFlushEmissionCutOffFilters,
			ColumnFlushFluorescenceGains,
			ColumnFlushSecondaryFluorescenceGains,
			ColumnFlushTertiaryFluorescenceGains,
			ColumnFlushQuaternaryFluorescenceGains,
			ColumnFlushFluorescenceFlowCellTemperatures
		}]
	],

	(*make sure that all of the MALS and DLS parameters are informed together*)
	If[MemberQ[Lookup[packet,Detectors],MultiAngleLightScattering|DynamicLightScattering],
		NotNullFieldTest[packet, {
			LightScatteringLaserPowers
		}],
		NullFieldTest[packet,{
			ColumnPrimeLightScatteringLaserPowers,
			ColumnPrimeLightScatteringFlowCellTemperatures,
			LightScatteringLaserPowers,
			LightScatteringFlowCellTemperatures,
			StandardLightScatteringLaserPowers,
			StandardLightScatteringFlowCellTemperatures,
			BlankLightScatteringLaserPowers,
			BlankLightScatteringFlowCellTemperatures,
			ColumnFlushLightScatteringLaserPowers,
			ColumnFlushLightScatteringFlowCellTemperatures
		}]
	],

	(*make sure that all of the RI parameters are informed correctly*)
	If[MemberQ[Lookup[packet,Detectors],RefractiveIndex],
		NotNullFieldTest[packet,{
			RefractiveIndexMethods
		}],
		NullFieldTest[packet,{
			ColumnPrimeRefractiveIndexMethods,
			ColumnPrimeRefractiveIndexFlowCellTemperatures,
			RefractiveIndexMethods,
			RefractiveIndexFlowCellTemperatures,
			StandardRefractiveIndexMethods,
			StandardRefractiveIndexFlowCellTemperatures,
			BlankRefractiveIndexMethods,
			BlankRefractiveIndexFlowCellTemperatures,
			ColumnFlushRefractiveIndexMethods,
			ColumnFlushRefractiveIndexFlowCellTemperatures
		}]
	],

	Test[
		"Unless the protocol is doing preparatory primitives, Samples In should be Informed if the Protocol is not Canceled or Aborted:",
		Lookup[packet,{SamplesIn,PreparatoryUnitOperations,Status}],
		{{ObjectP[Object[Sample]]..},_,_}|{{(ObjectP[{Model[Sample],Object[Sample]}]|Null)..},{Except[Null]..},_}|{_,_,Canceled|Aborted}
	],

	Test[
		"If the ELSD child options are informed, then the parent ones should be too:",
		If[
			And[
				MatchQ[Lookup[packet,Status],Completed],
				Or@@(!NullQ[#]&/@Lookup[packet,{NebulizerGasHeating, NebulizerHeatingPower, DriftTubeTemperature}])
			],
			And@@(!NullQ[#]&/@Lookup[packet,{NebulizerGas, NebulizerGasPressure, ELSDGain, ELSDSamplingRate}]),
			True
		],
		True
	],

	Test[
		"If the StandardELSD child options are informed, then the parent ones should be too:",
		If[
			And[
				MatchQ[Lookup[packet,Status],Completed],
				Or@@(!NullQ[#]&/@Lookup[packet,{StandardNebulizerGasHeating, StandardNebulizerHeatingPower, StandardDriftTubeTemperature}])
			],
			And@@(!NullQ[#]&/@Lookup[packet,{StandardNebulizerGas, StandardNebulizerGasPressure, StandardELSDGain, StandardELSDSamplingRate}]),
			True
		],
		True
	],
	Test[
		"If the BlankELSD child options are informed, then the parent ones should be too:",
		If[
			And[
				MatchQ[Lookup[packet,Status],Completed],
				Or@@(!NullQ[#]&/@Lookup[packet,{BlankNebulizerGasHeating, BlankNebulizerHeatingPower, BlankDriftTubeTemperature}])
			],
			And@@(!NullQ[#]&/@Lookup[packet,{BlankNebulizerGas, BlankNebulizerGasPressure, BlankELSDGain, BlankELSDSamplingRate}]),
			True
		],
		True
	],
	Test[
		"If the ColumnPrimeELSD child options are informed, then the parent ones should be too:",
		If[
			And[
				MatchQ[Lookup[packet,Status],Completed],
				Or@@(!NullQ[#]&/@Lookup[packet,{ColumnPrimeNebulizerGasHeatings, ColumnPrimeNebulizerHeatingPowers, ColumnPrimeDriftTubeTemperatures}])
			],
			And@@(!NullQ[#]&/@Lookup[packet,{ColumnPrimeNebulizerGases, ColumnPrimeNebulizerGasPressures, ColumnPrimeELSDGains, ColumnPrimeELSDSamplingRates}]),
			True
		],
		True
	],
	Test[
		"If the ColumnFlushELSD child options are informed, then the parent ones should be too:",
		If[
			And[
				MatchQ[Lookup[packet,Status],Completed],
				Or@@(!NullQ[#]&/@Lookup[packet,{ColumnFlushNebulizerGasHeatings, ColumnFlushNebulizerHeatingPowers, ColumnFlushDriftTubeTemperatures}])
			],
			And@@(!NullQ[#]&/@Lookup[packet,{ColumnFlushNebulizerGases, ColumnFlushNebulizerGasPressures, ColumnFlushELSDGains, ColumnFlushELSDSamplingRates}]),
			True
		],
		True
	],

	Test[
		"If Nebulizer Gas was used, need to ensure that the gas logs were filled out:",
		If[
			And[
				MatchQ[Lookup[packet,Status],Completed],
				AnyTrue[Lookup[packet,{NebulizerGas,BlankNebulizerGas,StandardNebulizerGas,ColumnFlushNebulizerGases,ColumnFlushNebulizerGases}],TrueQ]
			],
			And@@(!NullQ[#]&/@Lookup[packet,{InitialNitrogenPressure,NitrogenPressureLog}]),
			True
		],
		True
	],

	Test[
		"If Columns>0, then there should be a ColumnOrientation:",
		If[
			!MatchQ[Lookup[packet,Columns],ListableP[Null]|{}],
			Not[MatchQ[Lookup[packet,ColumnOrientation],ListableP[Null]|{}]],
			True
		],
		True
	],

	Test[
		"If GuardColumn is not Null, then there should be a GuardColumnOrientation:",
		If[
			!MatchQ[Lookup[packet,GuardColumn],ListableP[Null]|{}],
			Not[MatchQ[Lookup[packet,GuardColumnOrientation],ListableP[Null]|{}]],
			True
		],
		True
	],

	Test[
		"If completed and fractions were collected, FractionContainerPlacements must exist:",
		If[
			And[
				MatchQ[Lookup[packet,Status],Completed],
				TrueQ[Lookup[packet,FractionCollection]]
			],
			Not[NullQ[Lookup[packet,FractionContainerPlacements]]],
			True
		],
		True
	],

	Test[
		"If completed and fractions were NOT collected, all the FractionCollectionOptions are Null:",
		If[
			And[
				MatchQ[Lookup[packet,Status],Completed],
				!TrueQ[Lookup[packet,FractionCollection]]
			],
			And[
				NullQ[Lookup[packet,FractionContainerPlacements]/.{}->Null],
				NullQ[Lookup[packet,FractionCollectionMethods]/.{}->Null],
				NullQ[Lookup[packet,FractionContainers]/.{}->Null],
				NullQ[Lookup[packet,SamplesOut]/.{}->Null],
				NullQ[Lookup[packet,ContainersOut]/.{}->Null]
			],
			True
		],
		True
	],

	Test["Sample options are all the same length:",
		Apply[
			SameLengthQ,
			Lookup[packet, {
				SamplesIn,
				InjectionVolumes,
				Gradients
			}]
		],
		True
	],

	Test["Standard options are all the same length if Standards are informed:",
		If[
			And[
				Not[NullQ[Lookup[packet,Standards]]],
				MatchQ[Lookup[packet,Status],Completed]
			],
			Apply[
				SameLengthQ,
				Lookup[packet, {
					Standards,
					StandardSampleVolumes,
					StandardGradients
				}]
			],
			True
		],
		True
	],

	Test["If complete, SamplesIn and Data are the same length:",
		If[
			MatchQ[Lookup[packet,Status],Completed],
			Apply[
				SameLengthQ,
				Lookup[packet, {
					SamplesIn,
					Data
				}]
			],
			True
		],
		True
	]

};


(* ::Subsection::Closed:: *)
(*validProtocolImageSampleQTests*)


validProtocolImageSampleQTests[packet:PacketP[Object[Protocol,ImageSample]]] := Flatten[{

	(* shared fields Null *)
	NotNullFieldTest[packet, {
		ContainersIn
	}],

	(* shared fields NotNull *)
	NullFieldTest[packet,{
		SamplesOut,
		ContainersOut,
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	(* Fields required for pre-funtopia version *)
	RequiredTogetherTest[packet, {Imager, FieldsOfView, Illumination, ExposureTime}],

	(* Fields required for post-funtopia version *)
	RequiredTogetherTest[packet, {ImagingDirections, IlluminationDirections, BatchedImagingParameters, BatchLengths, BatchedContainerIndexes}],

	(* Tests for post-funtopia version: *)
	If[!MatchQ[Lookup[packet, BatchedImagingParameters], {}],
		{
			Test[
				"At least one of PlateImagerInstruments and SampleImagerInstruments is populated:",
				Lookup[packet, {PlateImagerInstruments, SampleImagerInstruments}],
				Except[{{},{}}]
			],
			Test[
				"The length of ContainersIn field should match the lengths of the ImagingDirections and IlluminationDirections fields:",
				SameLengthQ[Lookup[packet,SamplesIn],Lookup[packet,ImagingDirections], Lookup[packet, IlluminationDirections]],
				True
			],
			Test[
				"The length of BatchLengths must match the length of BatchedContainerParameters:",
				SameLengthQ[Lookup[packet,BatchLengths],Lookup[packet,BatchedImagingParameters]],
				True
			],
			RequiredWhenCompleted[packet, {BatchedContainers, DeckPlacements}]
		},
		{}
	],

	Test[
		"Unless the protocol is doing preparatory primitives, Samples In should be Informed if the Protocol is not Canceled or Aborted:",
		Lookup[packet,{SamplesIn,PreparatoryUnitOperations,Status}],
		{{ObjectP[Object[Sample]]..},_,_}|{{(ObjectP[{Model[Sample],Object[Sample]}]|Null)..},{Except[Null]..},_}|{_,_,Canceled|Aborted}
	]

}];



(* ::Subsection::Closed:: *)
(*validProtocolIonChromatographyQTests*)


validProtocolIonChromatographyQTests[packet:PacketP[Object[Protocol,IonChromatography]]]:={

	(* Shared field shaping *)
	NotNullFieldTest[packet, {
		ContainersIn,
		AnalysisChannels
	}],

	NullFieldTest[packet,{
		CO2PressureLog,
		ArgonPressureLog,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	If[MemberQ[packet[AnalysisChannels],AnionChannel],
		RequiredWhenCompleted[
			packet,
			{
				SamplesIn,
				Data,
				EnvironmentalData,
				ChannelSelection,
				AnionInitialPressureLowerLimit,
				AnionInitialPressureUpperLimit,
				AutosamplerDeckPlacements,
				BufferContainerPlacements,
				Instrument
			}
		],
		Nothing
	],

	If[MemberQ[packet[AnalysisChannels],CationChannel],
		RequiredWhenCompleted[
			packet,
			{
				SamplesIn,
				Data,
				EnvironmentalData,
				ChannelSelection,
				CationInitialPressureLowerLimit,
				CationInitialPressureUpperLimit,
				AutosamplerDeckPlacements,
				BufferContainerPlacements,
				Instrument
			}
		],
		Nothing
	],

	If[MemberQ[packet[AnalysisChannels],ElectrochemicalChannel],
		RequiredWhenCompleted[
			packet,
			{
				SamplesIn,
				Data,
				EnvironmentalData,
				InitialPressureLowerLimit,
				InitialPressureUpperLimit,
				AutosamplerDeckPlacements,
				BufferContainerPlacements,
				Instrument,
				ElectrochemicalInjectionTable
			}
		],
		Nothing
	],

	If[MemberQ[packet[Detectors],ElectrochemicalDetector],
		RequiredWhenCompleted[
			packet,
			{
				ElectrochemicalDetectionMode,
				WorkingElectrode,
				ReferenceElectrode,
				ReferenceElectrodeMode,
				ElectrochemicalSamplingRate,
				DetectionTemperature
			}
		],
		Nothing
	],

	If[MemberQ[packet[Detectors],UVVis],
		RequiredWhenCompleted[
			packet,
			{
				AbsorbanceWavelength,
				AbsorbanceSamplingRate
			}
		],
		Nothing
	],


	Test[
		"Unless the protocol is doing preparatory primitives, Samples In should be Informed if the Protocol is not Canceled or Aborted:",
		Lookup[packet,{SamplesIn,PreparatoryUnitOperations,Status}],
		{{ObjectP[Object[Sample]]..},_,_}|{{(ObjectP[{Model[Sample],Object[Sample]}]|Null)..},{Except[Null]..},_}|{_,_,Canceled|Aborted}
	],

	Test[
		"If the AnionSample child options are informed, then AnionSamples option should be too:",
		If[
			And[
				MatchQ[Lookup[packet,Status],Completed],
				Or@@(!MatchQ[#,Null|{}]&/@Lookup[packet,{AnionColumn, AnionGuardColumn, AnionSampleVolumes, EluentGeneratorInletSolution, AnionGradientMethods, AnionSuppressorMode, AnionDetectionTemperature, AnionInjectionTable}])
			],
			And@@(!MatchQ[#,Null|{}]&/@Lookup[packet,AnionSamples]),
			True
		],
		True
	],

	Test[
		"If the CationSample child options are informed, then CationSamples option should be too:",
		If[
			And[
				MatchQ[Lookup[packet,Status],Completed],
				Or@@(!MatchQ[#,Null|{}]&/@Lookup[packet,{CationColumn, CationGuardColumn, CationSampleVolumes, CationGradientMethods, CationSuppressorMode, CationDetectionTemperature, CationInjectionTable}])
			],
			And@@(!MatchQ[#,Null|{}]&/@Lookup[packet,CationSamples]),
			True
		],
		True
	],

	Test["Sample options are all the same length:",
		Apply[
			SameLengthQ,
			Lookup[packet,{
				SamplesIn,
				AnalysisChannels
			}]
		],
		True
	],

	Test["Standard options are all the same length if Standards are informed:",
		If[
			And[
				Not[MatchQ[Lookup[packet,Standards],{}|Null]],
				MatchQ[Lookup[packet,Status],Completed]
			],
			Apply[
				SameLengthQ,
				Lookup[packet, {
					Standards,
					StandardAnalysisChannels
				}]
			],
			True
		],
		True
	],

	Test["Blank options are all the same length if Blanks are informed:",
		If[
			And[
				Not[MatchQ[Lookup[packet,Blanks],{}|Null]],
				MatchQ[Lookup[packet,Status],Completed]
			],
			Apply[
				SameLengthQ,
				Lookup[packet, {
					Blanks,
					BlankAnalysisChannels
				}]
			],
			True
		],
		True
	],

	Test["If complete, SamplesIn and Data are the same length:",
		If[
			MatchQ[Lookup[packet,Status],Completed],
			Apply[
				SameLengthQ,
				Lookup[packet, {
					SamplesIn,
					Data
				}]
			],
			True
		],
		True
	]

};


(* ::Subsection::Closed:: *)
(*validProtocolIRSpectroscopyQTests*)


validProtocolIRSpectroscopyQTests[packet:PacketP[Object[Protocol,IRSpectroscopy]]] := Flatten[{

(* shared fields Null *)
	NotNullFieldTest[packet, {
		ContainersIn,
		Instrument,
		MaxWavenumber,
		MinWavenumber,
		WavenumberResolution
	}],

(* shared fields NotNull *)
	NullFieldTest[packet,{
		SamplesOut,
		ContainersOut,
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	Test[
		"Unless the protocol is doing preparatory primitives, Samples In should be Informed if the Protocol is not Canceled or Aborted:",
		Lookup[packet,{SamplesIn,PreparatoryUnitOperations,Status}],
		{{ObjectP[Object[Sample]]..},_,_}|{{(ObjectP[{Model[Sample],Object[Sample]}]|Null)..},{Except[Null]..},_}|{_,_,Canceled|Aborted}
	]

}
];


(* ::Subsection::Closed:: *)
(*validProtocolLCMSQTests*)


validProtocolLCMSQTests[packet:PacketP[Object[Protocol,LCMS]]]:={
	NotNullFieldTest[packet, {
		ContainersIn,
		ChromatographyInstrument,
		MassSpectrometryInstrument,
		MassAnalyzer,
		IonSource,
		SeparationMode,
		Detectors,
		NeedleWashSolution,
		SystemPrimeBufferA,
		SystemPrimeBufferB,
		SystemPrimeBufferC,
		SystemPrimeBufferD,
		SystemPrimeGradient,
		ColumnSelection,
		BufferA,
		BufferB,
		BufferC,
		BufferD,
		InjectionTable,
		SampleVolumes,
		GradientMethods,
		Calibrant,
		CalibrationMethods,
		MassAcquisitionMethods,
		IonModes,
		ESICapillaryVoltages,
		DesolvationTemperatures,
		DesolvationGasFlows,
		SourceTemperatures,
		DeclusteringVoltages,
		ConeGasFlows,
		StepwaveVoltages,
		AcquisitionWindows,
		AcquisitionModes,
		Fragmentations,
		ScanTimes,
		AbsorbanceSelection,
		MinAbsorbanceWavelengths,
		MaxAbsorbanceWavelengths,
		WavelengthResolutions,
		UVFilters,
		AbsorbanceSamplingRates,
		SystemFlushBufferA,
		SystemFlushBufferB,
		SystemFlushBufferC,
		SystemFlushBufferD,
		SystemFlushGradient
	}],
	NullFieldTest[packet, {
		SamplesOut,
		ContainersOut
	}],
	RequiredWhenCompleted[
		packet,
		{
			Data,
			SamplesIn,
			NitrogenPressureLog,
			ArgonPressureLog,
			InitialNitrogenPressure,
			InitialArgonPressure,
			InitialSystemPrimeBufferAAppearance,
			InitialSystemPrimeBufferBAppearance,
			InitialSystemPrimeBufferCAppearance,
			InitialSystemPrimeBufferDAppearance,
			FinalSystemPrimeBufferAAppearance,
			FinalSystemPrimeBufferBAppearance,
			FinalSystemPrimeBufferCAppearance,
			FinalSystemPrimeBufferDAppearance,
			BufferACap,
			BufferBCap,
			BufferCCap,
			BufferDCap,
			InitialBufferAAppearance,
			InitialBufferBAppearance,
			InitialBufferCAppearance,
			InitialBufferDAppearance,
			CalibrationData,
			SystemPrimeData,
			SystemFlushData,
			FinalBufferAAppearance,
			FinalBufferBAppearance,
			FinalBufferCAppearance,
			FinalBufferDAppearance,
			InitialSystemFlushBufferAAppearance,
			InitialSystemFlushBufferBAppearance,
			InitialSystemFlushBufferCAppearance,
			InitialSystemFlushBufferDAppearance,
			FinalSystemFlushBufferAVolume,
			FinalSystemFlushBufferBVolume,
			FinalSystemFlushBufferCVolume,
			FinalSystemFlushBufferDVolume
		}
	],

	(* Gradient Split Field Checks *)
	If[!NullQ[Lookup[packet,GradientMethods]],
		{
			Test["Only one of GradientAs and IsocraticGradientA can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,GradientAs],Lookup[packet,IsocraticGradientA]}
				],
				True
			],
			Test["Only one of GradientBs and IsocraticGradientB can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,GradientBs],Lookup[packet,IsocraticGradientB]}
				],
				True
			],
			Test["Only one of GradientCs and IsocraticGradientC can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,GradientCs],Lookup[packet,IsocraticGradientC]}
				],
				True
			],
			Test["Only one of GradientDs and IsocraticGradientD can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,GradientDs],Lookup[packet,IsocraticGradientD]}
				],
				True
			],
			Test["Only one of FlowRateVariable and FlowRateConstant can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,FlowRateVariable],Lookup[packet,FlowRateConstant]}
				],
				True
			]
		},
		NullFieldTest[packet,{GradientAs,IsocraticGradientA,GradientBs,IsocraticGradientB,GradientCs,IsocraticGradientC,GradientDs,IsocraticGradientD,FlowRateVariable,FlowRateConstant}]
	],
	
	RequiredTogetherTest[packet,{ColumnPrimeGradientMethod, ColumnPrimeMassAcquisitionMethod, ColumnPrimeIonMode, ColumnPrimeESICapillaryVoltage, ColumnPrimeDesolvationTemperature, ColumnPrimeDesolvationGasFlow, ColumnPrimeSourceTemperature, ColumnPrimeDeclusteringVoltage, ColumnPrimeConeGasFlow, ColumnPrimeStepwaveVoltage, ColumnPrimeAcquisitionWindows, ColumnPrimeAcquisitionModes, ColumnPrimeFragmentations}],
	RequiredTogetherTest[packet,{ColumnPrimeMinMasses, ColumnPrimeMaxMasses}],
	RequiredTogetherTest[packet,{ColumnPrimeLowCollisionEnergies, ColumnPrimeHighCollisionEnergies}],
	RequiredTogetherTest[packet,{ColumnPrimeInitialLowCollisionEnergies, ColumnPrimeInitialHighCollisionEnergies, ColumnPrimeFinalLowCollisionEnergies, ColumnPrimeFinalHighCollisionEnergies}],
	UniquelyInformedTest[packet,{ColumnPrimeMinMasses,ColumnPrimeMassSelections}],
	UniquelyInformedTest[packet,{ColumnPrimeCollisionEnergies, ColumnPrimeLowCollisionEnergies, ColumnPrimeInitialLowCollisionEnergies}],
	If[MemberQ[Lookup[packet,ColumnPrimeAcquisitionModes],DataDependent],
		NotNullFieldTest[packet,{ColumnPrimeAcquisitionSurveys}],
		Nothing
	],
	If[!MemberQ[Lookup[packet,ColumnPrimeAcquisitionModes],DataDependent],
		NullFieldTest[packet,{ColumnPrimeMinimumThresholds, ColumnPrimeAcquisitionLimits, ColumnPrimeCycleTimeLimits, ColumnPrimeExclusionModes, ColumnPrimeExclusionMassSelections, ColumnPrimeFragmentScanTimes, ColumnPrimeInclusionModes, ColumnPrimeInclusionMassSelections,ColumnPrimeIsotopeExclusionModes
		}],
		Nothing
	],
	If[!MemberQ[Lookup[packet,ColumnPrimeExclusionModes],TimeLimit],
		NullFieldTest[packet,{ColumnPrimeExclusionTimeLimits}],
		Nothing
	],
	If[!MemberQ[Lookup[packet,ColumnPrimeIsotopeExclusionModes],ChargedState],
		NullFieldTest[packet,{ColumnPrimeChargeStateSelections, ColumnPrimeChargeStateLimits, ColumnPrimeChargeStateMassWindows}],
		Nothing
	],
	If[!MemberQ[Lookup[packet,ColumnPrimeIsotopeExclusionModes],MassDifference],
		NullFieldTest[packet,{ColumnPrimeIsotopeMassDifferences, ColumnPrimeIsotopeRatios, ColumnPrimeIsotopeDetectionMinimums}],
		Nothing
	],
	(* Column Prime Gradient Split Field Checks *)
	If[!NullQ[Lookup[packet,ColumnPrimeGradientMethod]],
		{
			Test["Only one of ColumnPrimeGradientA and ColumnPrimeIsocraticGradientA can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,ColumnPrimeGradientA],Lookup[packet,ColumnPrimeIsocraticGradientA]}
				],
				True
			],
			Test["Only one of ColumnPrimeGradientB and ColumnPrimeIsocraticGradientB can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,ColumnPrimeGradientB],Lookup[packet,ColumnPrimeIsocraticGradientB]}
				],
				True
			],
			Test["Only one of ColumnPrimeGradientC and ColumnPrimeIsocraticGradientC can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,ColumnPrimeGradientC],Lookup[packet,ColumnPrimeIsocraticGradientC]}
				],
				True
			],
			Test["Only one of ColumnPrimeGradientD and ColumnPrimeIsocraticGradientD can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,ColumnPrimeGradientD],Lookup[packet,ColumnPrimeIsocraticGradientD]}
				],
				True
			],
			Test["Only one of ColumnPrimeFlowRateVariable and ColumnPrimeFlowRateConstant can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,ColumnPrimeFlowRateVariable],Lookup[packet,ColumnPrimeFlowRateConstant]}
				],
				True
			]
		},
		NullFieldTest[packet,{ColumnPrimeGradientA,ColumnPrimeIsocraticGradientA,ColumnPrimeGradientB,ColumnPrimeIsocraticGradientB,ColumnPrimeGradientC,ColumnPrimeIsocraticGradientC,ColumnPrimeGradientD,ColumnPrimeIsocraticGradientD,ColumnPrimeFlowRateVariable,ColumnPrimeFlowRateConstant}]
	],

	RequiredTogetherTest[packet,{Standards,StandardSampleVolumes,StandardGradientMethods, StandardMassAcquisitionMethods, StandardIonModes, StandardESICapillaryVoltages, StandardDesolvationTemperatures, StandardDesolvationGasFlows, StandardSourceTemperatures, StandardDeclusteringVoltages, StandardConeGasFlows, StandardStepwaveVoltages, StandardAcquisitionWindows, StandardAcquisitionModes, StandardFragmentations}],
	RequiredTogetherTest[packet,{StandardMinMasses, StandardMaxMasses}],
	RequiredTogetherTest[packet,{StandardLowCollisionEnergies, StandardHighCollisionEnergies}],
	RequiredTogetherTest[packet,{StandardInitialLowCollisionEnergies, StandardInitialHighCollisionEnergies, StandardFinalLowCollisionEnergies, StandardFinalHighCollisionEnergies}],
	UniquelyInformedTest[packet,{StandardMinMasses,StandardMassSelections}],
	UniquelyInformedTest[packet,{StandardCollisionEnergies, StandardLowCollisionEnergies, StandardInitialLowCollisionEnergies}],
	If[MemberQ[Lookup[packet,StandardAcquisitionModes],DataDependent],
		NotNullFieldTest[packet,{StandardAcquisitionSurveys}],
		Nothing
	],
	If[!MemberQ[Lookup[packet,StandardAcquisitionModes],DataDependent],
		NullFieldTest[packet,{StandardMinimumThresholds, StandardAcquisitionLimits, StandardCycleTimeLimits, StandardExclusionModes, StandardExclusionMassSelections, StandardFragmentScanTimes, StandardInclusionModes, StandardInclusionMassSelections, StandardIsotopeExclusionModes
		}],
		Nothing
	],
	If[!MemberQ[Lookup[packet,StandardExclusionModes],TimeLimit],
		NullFieldTest[packet,{StandardExclusionTimeLimits}],
		Nothing
	],
	If[!MemberQ[Lookup[packet,StandardIsotopeExclusionModes],ChargedState],
		NullFieldTest[packet,{StandardChargeStateSelections, StandardChargeStateLimits, StandardChargeStateMassWindows}],
		Nothing
	],
	If[!MemberQ[Lookup[packet,StandardIsotopeExclusionModes],MassDifference],
		NullFieldTest[packet,{StandardIsotopeMassDifferences, StandardIsotopeRatios, StandardIsotopeDetectionMinimums}],
		Nothing
	],
	(* Standard Gradient Split Field Checks *)
	If[!NullQ[Lookup[packet,StandardGradientMethods]],
		{
			Test["Only one of StandardGradientAs and StandardIsocraticGradientA can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,StandardGradientAs],Lookup[packet,StandardIsocraticGradientA]}
				],
				True
			],
			Test["Only one of StandardGradientBs and StandardIsocraticGradientB can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,StandardGradientBs],Lookup[packet,StandardIsocraticGradientB]}
				],
				True
			],
			Test["Only one of StandardGradientCs and StandardIsocraticGradientC can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,StandardGradientCs],Lookup[packet,StandardIsocraticGradientC]}
				],
				True
			],
			Test["Only one of StandardGradientDs and StandardIsocraticGradientD can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,StandardGradientDs],Lookup[packet,StandardIsocraticGradientD]}
				],
				True
			],
			Test["Only one of StandardFlowRateVariable and StandardFlowRateConstant can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,StandardFlowRateVariable],Lookup[packet,StandardFlowRateConstant]}
				],
				True
			]
		},
		NullFieldTest[packet,{StandardGradientAs,StandardIsocraticGradientA,StandardGradientBs,StandardIsocraticGradientB,StandardGradientCs,StandardIsocraticGradientC,StandardGradientDs,StandardIsocraticGradientD,StandardFlowRateVariable,StandardFlowRateConstant}]
	],

	RequiredTogetherTest[packet,{Blanks,BlankSampleVolumes,BlankGradientMethods, BlankMassAcquisitionMethods, BlankIonModes, BlankESICapillaryVoltages, BlankDesolvationTemperatures, BlankDesolvationGasFlows, BlankSourceTemperatures, BlankDeclusteringVoltages, BlankConeGasFlows, BlankStepwaveVoltages, BlankAcquisitionWindows, BlankAcquisitionModes, BlankFragmentations}],
	RequiredTogetherTest[packet,{BlankMinMasses, BlankMaxMasses}],
	RequiredTogetherTest[packet,{BlankLowCollisionEnergies, BlankHighCollisionEnergies}],
	RequiredTogetherTest[packet,{BlankInitialLowCollisionEnergies, BlankInitialHighCollisionEnergies, BlankFinalLowCollisionEnergies, BlankFinalHighCollisionEnergies}],
	UniquelyInformedTest[packet,{BlankMinMasses,BlankMassSelections}],
	UniquelyInformedTest[packet,{BlankCollisionEnergies, BlankLowCollisionEnergies, BlankInitialLowCollisionEnergies}],
	If[MemberQ[Lookup[packet,BlankAcquisitionModes],DataDependent],
		NotNullFieldTest[packet,{BlankAcquisitionSurveys}],
		Nothing
	],
	If[!MemberQ[Lookup[packet,BlankAcquisitionModes],DataDependent],
		NullFieldTest[packet,{BlankMinimumThresholds, BlankAcquisitionLimits, BlankCycleTimeLimits, BlankExclusionModes, BlankExclusionMassSelections, BlankFragmentScanTimes, BlankInclusionModes, BlankInclusionMassSelections, BlankIsotopeExclusionModes
		}],
		Nothing
	],
	If[!MemberQ[Lookup[packet,BlankExclusionModes],TimeLimit],
		NullFieldTest[packet,{BlankExclusionTimeLimits}],
		Nothing
	],
	If[!MemberQ[Lookup[packet,BlankIsotopeExclusionModes],ChargedState],
		NullFieldTest[packet,{BlankChargeStateSelections, BlankChargeStateLimits, BlankChargeStateMassWindows}],
		Nothing
	],
	If[!MemberQ[Lookup[packet,BlankIsotopeExclusionModes],MassDifference],
		NullFieldTest[packet,{BlankIsotopeMassDifferences, BlankIsotopeRatios, BlankIsotopeDetectionMinimums}],
		Nothing
	],
	(* Blank Gradient Split Field Checks *)
	If[!NullQ[Lookup[packet,BlankGradientMethods]],
		{
			Test["Only one of BlankGradientAs and BlankIsocraticGradientA can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,BlankGradientAs],Lookup[packet,BlankIsocraticGradientA]}
				],
				True
			],
			Test["Only one of BlankGradientBs and BlankIsocraticGradientB can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,BlankGradientBs],Lookup[packet,BlankIsocraticGradientB]}
				],
				True
			],
			Test["Only one of BlankGradientCs and BlankIsocraticGradientC can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,BlankGradientCs],Lookup[packet,BlankIsocraticGradientC]}
				],
				True
			],
			Test["Only one of BlankGradientDs and BlankIsocraticGradientD can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,BlankGradientDs],Lookup[packet,BlankIsocraticGradientD]}
				],
				True
			],
			Test["Only one of BlankFlowRateVariable and BlankFlowRateConstant can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,BlankFlowRateVariable],Lookup[packet,BlankFlowRateConstant]}
				],
				True
			]
		},
		NullFieldTest[packet,{BlankGradientAs,BlankIsocraticGradientA,BlankGradientBs,BlankIsocraticGradientB,BlankGradientCs,BlankIsocraticGradientC,BlankGradientDs,BlankIsocraticGradientD,BlankFlowRateVariable,BlankFlowRateConstant}]
	],

	RequiredTogetherTest[packet,{ColumnFlushGradientMethod, ColumnFlushMassAcquisitionMethod, ColumnFlushIonMode, ColumnFlushESICapillaryVoltage, ColumnFlushDesolvationTemperature, ColumnFlushDesolvationGasFlow, ColumnFlushSourceTemperature, ColumnFlushDeclusteringVoltage, ColumnFlushConeGasFlow, ColumnFlushStepwaveVoltage, ColumnFlushAcquisitionWindows, ColumnFlushAcquisitionModes, ColumnFlushFragmentations}],
	RequiredTogetherTest[packet,{ColumnFlushMinMasses, ColumnFlushMaxMasses}],
	RequiredTogetherTest[packet,{ColumnFlushLowCollisionEnergies, ColumnFlushHighCollisionEnergies}],
	RequiredTogetherTest[packet,{ColumnFlushInitialLowCollisionEnergies, ColumnFlushInitialHighCollisionEnergies, ColumnFlushFinalLowCollisionEnergies, ColumnFlushFinalHighCollisionEnergies}],
	UniquelyInformedTest[packet,{ColumnFlushMinMasses,ColumnFlushMassSelections}],
	UniquelyInformedTest[packet,{ColumnFlushCollisionEnergies, ColumnFlushLowCollisionEnergies, ColumnFlushInitialLowCollisionEnergies}],
	If[MemberQ[Lookup[packet,ColumnFlushAcquisitionModes],DataDependent],
		NotNullFieldTest[packet,{ColumnFlushAcquisitionSurveys}],
		Nothing
	],
	If[!MemberQ[Lookup[packet,ColumnFlushAcquisitionModes],DataDependent],
		NullFieldTest[packet,{ColumnFlushMinimumThresholds, ColumnFlushAcquisitionLimits, ColumnFlushCycleTimeLimits, ColumnFlushExclusionModes, ColumnFlushExclusionMassSelections, ColumnFlushFragmentScanTimes, ColumnFlushInclusionModes, ColumnFlushInclusionMassSelections, ColumnFlushIsotopeExclusionModes
		}],
		Nothing
	],
	If[!MemberQ[Lookup[packet,ColumnFlushExclusionModes],TimeLimit],
		NullFieldTest[packet,{ColumnFlushExclusionTimeLimits}],
		Nothing
	],
	If[!MemberQ[Lookup[packet,ColumnFlushIsotopeExclusionModes],ChargedState],
		NullFieldTest[packet,{ColumnFlushChargeStateSelections, ColumnFlushChargeStateLimits, ColumnFlushChargeStateMassWindows}],
		Nothing
	],
	If[!MemberQ[Lookup[packet,ColumnFlushIsotopeExclusionModes],MassDifference],
		NullFieldTest[packet,{ColumnFlushIsotopeMassDifferences, ColumnFlushIsotopeRatios, ColumnFlushIsotopeDetectionMinimums}],
		Nothing
	],
	(* Column Flush Gradient Split Field Checks *)
	If[!NullQ[Lookup[packet,ColumnFlushGradientMethod]],
		{
			Test["Only one of ColumnFlushGradientA and ColumnFlushIsocraticGradientA can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,ColumnFlushGradientA],Lookup[packet,ColumnFlushIsocraticGradientA]}
				],
				True
			],
			Test["Only one of ColumnFlushGradientB and ColumnFlushIsocraticGradientB can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,ColumnFlushGradientB],Lookup[packet,ColumnFlushIsocraticGradientB]}
				],
				True
			],
			Test["Only one of ColumnFlushGradientC and ColumnFlushIsocraticGradientC can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,ColumnFlushGradientC],Lookup[packet,ColumnFlushIsocraticGradientC]}
				],
				True
			],
			Test["Only one of ColumnFlushGradientD and ColumnFlushIsocraticGradientD can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,ColumnFlushGradientD],Lookup[packet,ColumnFlushIsocraticGradientD]}
				],
				True
			],
			Test["Only one of ColumnFlushFlowRateVariable and ColumnFlushFlowRateConstant can be specified:",
				And@@MapThread[
					MatchQ[{#1,#2},{Null,Except[Null]}|{Except[Null],Null}]&,
					{Lookup[packet,ColumnFlushFlowRateVariable],Lookup[packet,ColumnFlushFlowRateConstant]}
				],
				True
			]
		},
		NullFieldTest[packet,{ColumnFlushGradientA,ColumnFlushIsocraticGradientA,ColumnFlushGradientB,ColumnFlushIsocraticGradientB,ColumnFlushGradientC,ColumnFlushIsocraticGradientC,ColumnFlushGradientD,ColumnFlushIsocraticGradientD,ColumnFlushFlowRateVariable,ColumnFlushFlowRateConstant}]
	],
	
	Test["If the protocol is completed, the length of Data should be equal to the length of SamplesIn:",
		{Status,Length[DeleteCases[Lookup[packet,Data],Null]]},
		{Completed,Length[DeleteCases[Lookup[packet,SamplesIn],Null]]}|{Except[Completed],_}
	],
	Test["If the protocol is completed, the length of BlankData should be equal to the length of Blanks:",
		{Status,Length[DeleteCases[Lookup[packet,BlankData],Null]]},
		{Completed,Length[DeleteCases[Lookup[packet,Blanks],Null]]}|{Except[Completed],_}
	],
	Test["If the protocol is completed, the length of StandardData should be equal to the length of Standards:",
		{Status,Length[DeleteCases[Lookup[packet,StandardData],Null]]},
		{Completed,Length[DeleteCases[Lookup[packet,Standards],Null]]}|{Except[Completed],_}
	],
	Test[
		"Unless the protocol is doing preparatory primitives, Samples In should be Informed if the Protocol is not Canceled or Aborted:",
		Lookup[packet,{SamplesIn,PreparatoryUnitOperations,Status}],
		{{ObjectP[Object[Sample]]..},_,_}|{{(ObjectP[{Model[Sample],Object[Sample]}]|Null)..},{Except[Null]..},_}|{_,_,Canceled|Aborted}
	]
};


(* ::Subsection::Closed:: *)
(*validProtocolLuminescenceIntensityQTests*)


validProtocolLuminescenceIntensityQTests[packet:PacketP[{Object[Protocol,LuminescenceIntensity],Object[Protocol,LuminescenceKinetics]}]]:=Join[
	validPlateReaderProtocolTests[packet],
	{
		NotNullFieldTest[packet,{IntegrationTime}]
	}
];


(* ::Subsection::Closed:: *)
(*validProtocolLyophilizeQTests*)


validProtocolLyophilizeQTests[packet:PacketP[Object[Protocol,Lyophilize]]]:={

	(* field shaping *)
	NotNullFieldTest[packet, {
		(*shared*)
		ContainersIn,
		Instruments,
		(* specific *)
		TemperaturePressureProfile,
		PressureGradient,
		TemperatureGradient
	}],

	NullFieldTest[packet, {
		InitialMainCO2Pressure,
		InitialMainArgonPressure,
		CO2PressureLog,
		ArgonPressureLog,
		SamplesOut,
		ContainersOut,
		Data
	}],

	RequiredWhenCompleted[packet,{NitrogenPressureLog,PressureData,SamplesIn}],

	Test[
		"Unless the protocol is doing preparatory primitives, Samples In should be Informed if the Protocol is not Canceled or Aborted:",
		Lookup[packet,{SamplesIn,PreparatoryUnitOperations,Status}],
		{{ObjectP[Object[Sample]]..},_,_}|{{(ObjectP[{Model[Sample],Object[Sample]}]|Null)..},{Except[Null]..},_}|{_,_,Canceled|Aborted}
	]

};




(* ::Subsection::Closed:: *)
(*validProtocolLuminescenceSpectroscopyQTests*)


validProtocolLuminescenceSpectroscopyQTests[packet:PacketP[{Object[Protocol,LuminescenceSpectroscopy]}]]:=Join[
	validPlateReaderProtocolTests[packet],
	{
		UniquelyInformedTest[packet,{Gain,GainPercentage}],
		NotNullFieldTest[packet,{MinEmissionWavelength,MaxEmissionWavelength}]
	}
];


(* ::Subsection::Closed:: *)
(*validProtocolMagneticBeadSeparationQTests*)


validProtocolMagneticBeadSeparationQTests[packet:PacketP[Object[Protocol,MagneticBeadSeparation]]]:={

	NotNullFieldTest[packet,{
		(*Shared fields not Null*)
		ContainersIn,

		(*Specific fields not Null*)
		Target,
		SeparationMode,
		LiquidHandlingScale,
		ProcessingOrder,
		SampleVolumes,
		MagneticBeads,
		MagneticBeadVolumes,
		MagnetizationRacks,
		AssayContainers,
		LoadingTimes,
		LoadingTemperatures,
		LoadingMagnetizationTimes,
		LoadingAspirationVolumes,
		LoadingCollectionContainers
	}],


	(*Shared fields Null*)
	NullFieldTest[packet,{
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialCO2Pressure,
		InitialArgonPressure
	}],


	(*Required together*)
	RequiredTogetherTest[packet,{
		AssayPrimitives,
		AssayManipulation
	}],
	RequiredTogetherTest[packet,{
		PreWashBuffers,
		PreWashBufferVolumes,
		PreWashTimes,
		PreWashTemperatures,
		PreWashMagnetizationTimes,
		PreWashAspirationVolumes,
		NumberOfPreWashes
	}],
	RequiredTogetherTest[packet,{
		EquilibrationBuffers,
		EquilibrationBufferVolumes,
		EquilibrationTimes,
		EquilibrationTemperatures,
		EquilibrationMagnetizationTimes,
		EquilibrationAspirationVolumes
	}],
	RequiredTogetherTest[packet,{
		WashBuffers,
		WashBufferVolumes,
		WashTimes,
		WashTemperatures,
		WashMagnetizationTimes,
		WashAspirationVolumes,
		WashCollectionContainers,
		WashCollectionContainerResources,
		NumberOfWashes
	}],
	RequiredTogetherTest[packet,{
		ElutionBuffers,
		ElutionBufferVolumes,
		ElutionTimes,
		ElutionTemperatures,
		ElutionMagnetizationTimes,
		ElutionAspirationVolumes,
		ElutionCollectionContainers,
		ElutionCollectionContainerResources,
		NumberOfElutions
	}],


	(*Required when completed*)
	RequiredWhenCompleted[packet,{
		SamplesOut,
		ContainersOut
	}],


	(*SamplesIn test*)
	Test[
		"Unless the protocol is doing preparatory primitives, Samples In should be Informed if the Protocol is not Canceled or Aborted:",
		Lookup[packet,{SamplesIn,PreparatoryUnitOperations,Status}],
		{{ObjectP[Object[Sample]]..},_,_}|{{(ObjectP[{Model[Sample],Object[Sample]}]|Null)..},{Except[Null]..},_}|{_,_,Canceled|Aborted}
	]

};

(* ::Subsection::Closed:: *)
(*validProtocolManualSamplePreparationQTests*)

validProtocolManualSamplePreparationQTests[packet:PacketP[Object[Protocol, ManualSamplePreparation]]]:={};

(* ::Subsection::Closed:: *)
(*validProtocolMassSpectrometryQTests*)


validProtocolMassSpectrometryQTests[packet:PacketP[Object[Protocol,MassSpectrometry]]]:={

(* Shared field shaping *)
	NotNullFieldTest[packet, {
	(*shared*)
		ContainersIn,
	(*specific*)
		AcquisitionModes,
		MassAnalyzer,
		IonSource,
		IonModes
	}],

	NullFieldTest[packet,{
		SamplesOut,
		ContainersOut,
		CO2PressureLog,
		InitialCO2Pressure
	}],

	RequiredWhenCompleted[packet,{
		SamplesIn,
		Data,
		Instrument
	}],

	(*ESI-QQQ New Tests*)
	If[MatchQ[Lookup[packet,MassAnalyzer],TripleQuadrupole],
		NotNullFieldTest[packet, {DesolvationTemperatures,DesolvationGasFlows,ConeGasFlows,ESICapillaryVoltages,IonGuideVoltages,DeclusteringVoltages,SourceTemperatures}],
		Nothing
	],

	UniquelyInformedTest[packet,{MinMasses,MassSelections}],
	RequiredTogetherTest[packet, {MinMasses, MaxMasses}],
	RequiredTogetherTest[packet, {FragmentMinMasses, FragmentMaxMasses}],

	(* Tests for TOF Analyzer *)
	Test[
		"If TOF, AccelerationVoltage is informed:",
		If[(Lookup[packet,MassAnalyzer])=== TOF,
			!NullQ[Lookup[packet,AccelerationVoltage]],
			True
		],
		True
	],
	Test[
		"If TOF,  GridVoltage is informed:",
		If[(Lookup[packet,MassAnalyzer])=== TOF,
			!NullQ[Lookup[packet,GridVoltages]],
			True
		],
		True
	],
	Test[
		"If TOF,  LensVoltage is informed:",
		If[(Lookup[packet,MassAnalyzer])=== TOF,
			!NullQ[Lookup[packet,LensVoltages]],
			True
		],
		True
	],
	Test[
		"If TOF,  DelayTime is informed:",
		If[(Lookup[packet,MassAnalyzer])=== TOF,
			!NullQ[Lookup[packet,DelayTimes]],
			True
		],
		True
	],

	(*QTOF Specific*)
	Test[
		"If QTOF,  SourceVoltageOffset is informed:",
		If[(Lookup[packet,MassAnalyzer])=== QTOF,
			!NullQ[Lookup[packet,SourceVoltageOffset]],
			True
		],
		True
	],

	(* Tests for MALDI Source fields *)
	Test[
		"If MALDI, LaserFrequency is informed:",
		If[MemberQ[(Lookup[packet,IonSource]),MALDI],
			!NullQ[Lookup[packet,LaserFrequency]],
			True
		],
		True
	],
	Test[
		"If MALDI, ShotsPerRaster is informed:",
		If[MemberQ[(Lookup[packet,IonSource]),MALDI],
			!NullQ[Lookup[packet,ShotsPerRaster]],
			True
		],
		True
	],
	Test[
		"If MALDI, MinLaserPower is informed:",
		If[MemberQ[(Lookup[packet,IonSource]),MALDI],
			!NullQ[Lookup[packet,MinLaserPowers]],
			True
		],
		True
	],
	Test[
		"If MALDI, MaxLaserPower is informed:",
		If[MemberQ[(Lookup[packet,IonSource]),MALDI],
			!NullQ[Lookup[packet,MaxLaserPowers]],
			True
		],
		True
	],
	Test[
		"If MALDI, DelayTime is informed:",
		If[MemberQ[(Lookup[packet,IonSource]),MALDI],
			!NullQ[Lookup[packet,DelayTimes]],
			True
		],
		True
	],

(* Tests for ESI Source fields *)
	Test[
		"If  ESI, ESICapillaryVoltage is informed:",
		If[MemberQ[(Lookup[packet,IonSource]),ESI],
			!NullQ[Lookup[packet,ESICapillaryVoltage]],
			True
		],
		True
	],
	Test[
		"If ESI, SamplingConeVoltage is informed:",
		If[MemberQ[(Lookup[packet,IonSource]),ESI],
			!NullQ[Lookup[packet,SamplingConeVoltage]],
			True
		],
		True
	],
	Test[
		"If ESI, SourceTemperature is informed:",
		If[MemberQ[(Lookup[packet,IonSource]),ESI],
			!NullQ[Lookup[packet,SourceTemperature]],
			True
		],
		True
	],
	Test[
		"If ESI, DesolvationTemperature is informed:",
		If[MemberQ[(Lookup[packet,IonSource]),ESI],
			!NullQ[Lookup[packet,DesolvationTemperature]],
			True
		],
		True
	],
	Test[
		"If ESI, ConeGasFlow is informed:",
		If[MemberQ[(Lookup[packet,IonSource]),ESI],
			!NullQ[Lookup[packet,ConeGasFlow]],
			True
		],
		True
	],
	Test[
		"If ESI, DesolvationGasFlow is informed:",
		If[MemberQ[(Lookup[packet,IonSource]),ESI],
			!NullQ[Lookup[packet,DesolvationGasFlow]],
			True
		],
		True
	],
	Test[
		"If ESI, NitrogenPressureLog is informed:",
		If[MemberQ[(Lookup[packet,IonSource]),ESI],
			!NullQ[Lookup[packet,NitrogenPressureLog]],
			True
		],
		True
	],

	(*------------------------TESTS FOR ESI-QTOF PROTOCOLS------------------------*)
	If[MatchQ[Lookup[packet,{AcquisitionMode ,IonSource, MassAnalyzer}],{MS,ESI,QTOF}], {

	(* --- Experimental Tests --- *)
		NotNullFieldTest[packet, {
			Calibrants,
			InfusionFlowRates,
			ScanTimes,
			RunDurations
		}],

		Test[
			"If the protocol is completed, its data fields are properly informed:",
			If[
				MatchQ[Lookup[packet,Status],Completed],
				And[
					Apply[SameLengthQ,Lookup[packet,{SamplesIn,Data}]]
				],
				True
			],
			True
		],
		Test[
			"If the protocol is completed, its nitrogen and argon pressure fields are properly informed:",
			If[
				MatchQ[Lookup[packet,Status],Completed],
				!NullQ[{InitialNitrogenPressure, InitialArgonPressure,NitrogenPressureLog,ArgonPressureLog}],
				True
			],
			True
		]


	},
		{}
	],




	(*------------------------TESTS FOR MALDI PROTOCOLS------------------------*)
	If[MatchQ[Lookup[packet,{AcquisitionMode ,IonSource, MassAnalyzer}],{MS,MALDI,TOF}], {

	(* --- Experimental Tests --- *)
		NotNullFieldTest[packet, {
			Calibrants,
			CalibrationMethods,
			SpottingMethods,
			CalibrantWells
		}],

		Test[
			"If the protocol is completed, its data fields are properly informed:",
			If[
				MatchQ[Lookup[packet,Status],Completed],
				And[
					Apply[SameLengthQ,Lookup[packet,{SamplesIn,Data}]],
					MatchQ[Lookup[packet,MatrixData],{ObjectP[]..}],
					MatchQ[Lookup[packet,CalibrantData],{ObjectP[]..}]
				],
				True
			],
			True
		],

	(* --- Procedure Tests --- *)
		ResolvedAfterCheckpoint[packet, "Preparing Samples",
			{
				Matrices,
				Calibrants,
				MALDIPlate
			}
		],

		RequiredAfterCheckpoint[packet, "MALDI Plate Spotting",
			{
				MethodFilePaths,
				MethodExecutionFilePaths,
				BatchExecutionFilePath,
				InstrumentSettingsFilePath,
				ExportScriptFilePath
			}
		],

		ResolvedAfterCheckpoint[packet, "Acquiring Data",
			{
				Instrument
			}
		],
		RequiredAfterCheckpoint[packet, "Acquiring Data",
			{
				PostProcessingProtocols
			}
		],

		ResolvedAfterCheckpoint[packet, "Cleaning Up",
			{
				Sonicator,
				PrimaryPlateCleaningSolvent
			}
		]},
		{}
	],

	Test[
		"Unless the protocol is doing preparatory primitives, Samples In should be Informed if the Protocol is not Canceled or Aborted:",
		Lookup[packet,{SamplesIn,PreparatoryUnitOperations,Status}],
		{{ObjectP[Object[Sample]]..},_,_}|{{(ObjectP[{Model[Sample],Object[Sample]}]|Null)..},{Except[Null]..},_}|{_,_,Canceled|Aborted}
	]
};


(* ::Subsection::Closed:: *)
(*validProtocolMeasureVolumeQTests*)


validProtocolMeasureVolumeQTests[packet:PacketP[Object[Protocol,MeasureVolume]]]:={
	(*Shared field tests*)
	NotNullFieldTest[packet, {
		SamplesIn,
		ContainersIn,
		ErrorTolerance
	}],

	NullFieldTest[packet,{
		SamplesOut,
		ContainersOut,

		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	If[
		MatchQ[Lookup[packet,VolumeMeasurements],ListableP[ObjectP[Object[Program]]]],
		RequiredTogetherTest[packet, {UltrasonicallyMeasured,VolumeMeasurements}],
		RequiredTogetherTest[packet, {UltrasonicallyMeasured,BatchLengths,BatchedContainerIndexes,BatchedMeasurementDevices}]
	],

	Test["At least one of UltrasonicallyMeasuredWeightMeasurement and GravimetricallyMeasured is informed:",
		Lookup[packet,{UltrasonicallyMeasured,GravimetricallyMeasured}],
		Except[{{},{}}]
	]

};


(* ::Subsection::Closed:: *)
(*validProtocolMeasureWeightQTests*)


validProtocolMeasureWeightQTests[packet:PacketP[Object[Protocol,MeasureWeight]]]:={

(*shared NotNull*)
	NullFieldTest[packet,{
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	NotNullFieldTest[packet,
	(* protocols pre funtopia *)
  (* TODO delete this test once we delete fields *)
    If[!MatchQ[Lookup[packet,BatchingLengths],{_Integer..}],
      {
        ContainersIn,
        NumberOfWeighings,
        MeasureWeightPrograms
      },
    (* protocols post funtopia *)
      {
        ContainersIn,
        ContainersInExpanded,
        Batching,
        BatchingLengths
      }
    ]
	],

  (* length of NumberOfWeighings should be same as ContainersIn *)
  (* TODO delete this test once we delete fields *)
  Test["Length of NumberOfWeighings should equal ContainersIn:",
    If[!MatchQ[Lookup[packet,BatchingLengths],{_Integer..}],
      Length[Lookup[packet,ContainersIn]]==Length[Lookup[packet,NumberOfWeighings]],
      True],
    True],

  (* length of fields should be same *)
  (* TODO delete this test once we delete field *)
  Test["Length of MeasureWeightPrograms should equal ContainersIn:",
    If[!MatchQ[Lookup[packet,BatchingLengths],{_Integer..}],
      Length[Lookup[packet,ContainersIn]] == Length[Lookup[packet,MeasureWeightPrograms]],
      True],
    True
	],

  (* Data fields should be indexmatching ContainersInExpanded (since they get indexmatched in the parser, this is required once the protocol is completed *)
  Test["Length of Data should equal ContainersInExpanded:",
    If[MatchQ[Lookup[packet,BatchingLengths],{_Integer..}] && MatchQ[Lookup[packet,Status],Completed],
      Length[Lookup[packet,ContainersInExpanded]]==Length[Lookup[packet,Data]]==Length[Lookup[packet,SamplesIn]],
      True],
    True],

  Test["Length of TareData, if acquired, should equal ContainersInExpanded:",
    If[MatchQ[Lookup[packet,BatchingLengths],{_Integer..}] && MatchQ[Lookup[packet,Status],Completed] && !MatchQ[Lookup[packet,TareData],{}],
      Length[Lookup[packet,ContainersInExpanded]]==Length[Lookup[packet,TareData]]==Length[Lookup[packet,SamplesIn]],
      True],
    True],

  Test["Length of ResidueWeightData, if acquired, should equal ContainersInExpanded:",
    If[MatchQ[Lookup[packet,BatchingLengths],{_Integer..}] && MatchQ[Lookup[packet,Status],Completed] && !MatchQ[Lookup[packet,ResidueWeightData],{}],
      Length[Lookup[packet,ContainersInExpanded]]==Length[Lookup[packet,ResidueWeightData]]==Length[Lookup[packet,SamplesIn]],
      True],
    True],

  Test["Length of ScoutData, if acquired, should equal ContainersInExpanded:",
    If[MatchQ[Lookup[packet,BatchingLengths],{_Integer..}] && MatchQ[Lookup[packet,Status],Completed] && !MatchQ[Lookup[packet,ScoutData],{}],
      Length[Lookup[packet,ContainersInExpanded]]==Length[Lookup[packet,ScoutData]]==Length[Lookup[packet,SamplesIn]],
      True],
    True],

(* Balance field should be indexmatching ContainersInExpanded (since it get's indexmatched in the parser, this is required once the protocol is completed *)
  Test["Length of Balance should equal ContainersInExpanded:",
    Which[
      MatchQ[Lookup[packet,BatchingLengths],{_Integer..}] && MatchQ[Lookup[packet,Status],Completed],
        Length[Lookup[packet,ContainersInExpanded]]==Length[Lookup[packet,Balance]]==Length[Lookup[packet,SamplesIn]],
      !MatchQ[Lookup[packet,BatchingLengths],{_Integer..}] && MatchQ[Lookup[packet,Status],Completed],
        Length[Lookup[packet,ContainersIn]]==Length[Lookup[packet,Balance]],
      True,True
      ],
    True],

(* UPON COMPLETION *)
	RequiredWhenCompleted[packet,
    If[!MatchQ[Lookup[packet,BatchingLengths],{_Integer..}],
      {
        Data,
        Balance,
        Weight,
        WeightStandardDeviation,
        WeightDistribution
      },
      {
        Data,
        Balance
      }
    ]
  ]

};


(* ::Subsection::Closed:: *)
(*validProtocolMeasureDensityQTests*)


validProtocolMeasureDensityQTests[packet:PacketP[Object[Protocol,MeasureDensity]]]:={

(* shared fields not null *)
	NotNullFieldTest[packet, {
		ContainersIn,
		SamplesIn,
		Balance,
		Pipette,
		PipetteTips,
		RecoupSample,
		MeasurementVolumes,
		MeasurementContainers
	}],

	NullFieldTest[packet,{
		ContainersOut,
		SamplesOut,
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	If[MatchQ[Lookup[packet,Status],Completed],
	(* length of fields should be same *)
		Test["Length of TareWeights and SampleWeights should equal SamplesIn:",
			And[
				Length[Lookup[packet,SamplesIn]] == Length[Lookup[packet,TareWeights]],
				Length[Lookup[packet,SamplesIn]] == Length[Lookup[packet,SampleWeights]]
			],
			True
		],
		{}
	],

(* UPON COMPLETION *)
	RequiredWhenCompleted[packet,{TareWeights,SampleWeights}]
};


(* ::Subsection::Closed:: *)
(*validProtocolMeasureConductivityQTests*)


validProtocolMeasureConductivityQTests[packet:PacketP[Object[Protocol,MeasureConductivity]]]:={

(* shared fields not null *)
	NotNullFieldTest[packet, {
		ContainersIn,
		SamplesIn
	}],

	NullFieldTest[packet,{
		ContainersOut,
		SamplesOut,
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	RequiredWhenCompleted[
		packet,
		{
			SamplesIn,
			Data
		}
	]
};


(* ::Subsection::Closed:: *)
(*validProtocolMeasureContactAngleQTests*)


validProtocolMeasureContactAngleQTests[packet:PacketP[Object[Protocol,MeasureContactAngle]]]:={

	(* shared fields not null *)
	NotNullFieldTest[
		packet,
		{
			ContainersIn,
			SamplesIn,
			(* specific to object *)
			Instrument,
			NumberOfCycles,
			ContactDetectionSpeed,
			ContactDetectionSensitivity,
			MeasuringSpeed,
			AcquisitionStep,
			EndImmersionDepth,
			StartImmersionDepth,
			EndImmersionDelay,
			StartImmersionDelay,
			Temperature,
			Volume,
			ImmersionContainer,
			WettedLengthMeasurement,
			WettingLiquids
		}
	],

	NullFieldTest[
		packet,
		{
			SamplesOut,
			ContainersOut,
			NitrogenPressureLog,
			CO2PressureLog,
			ArgonPressureLog,
			InitialNitrogenPressure,
			InitialArgonPressure,
			InitialCO2Pressure
		}
	],

	(* UPON COMPLETION *)
	RequiredWhenCompleted[
		packet,
		{
			Data
		}
	],

	(* StartImmersionDepth < EndImmersionDepth, can't use FieldComparisonTest because it doesn't support comparison of multiple Fields *)
	Test["Each StartImmersionDepth should less than the corresponding EndImmersionDepth:",
		And@@MapThread[
			#1<#2&,
			{Lookup[packet,StartImmersionDepth],Lookup[packet,EndImmersionDepth]}
		],
		True
	],

	(* FiberSampleHolder should be informed if the SamplesIn is not the standard Wilhelmy plate *)
	Test["FiberSampleHolder should be informed if and only if the SamplesIn is not the standard Wilhelmy plate:",
		And@@MapThread[
			If[MatchQ[#1,ObjectP[Object[Item,WilhelmyPlate,"id:wqW9BPWEV66O"]]],
				NullQ[#2],
				!NullQ[#2]
			]&,
			{Lookup[packet,SamplesIn],Lookup[packet,FiberSampleHolder]}
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validProtocolMeasureCountQTests*)


validProtocolMeasureCountQTests[packet:PacketP[Object[Protocol,MeasureCount]]]:={

(* shared fields not null *)
	NotNullFieldTest[packet, {
		ContainersIn,
		SamplesIn
	}],

	NullFieldTest[packet,{
		ContainersOut,
		SamplesOut,
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	(*If there are samples whose tablets need to be parametrized, then*)
	If[!MatchQ[Lookup[packet,TabletWeightParameterizations],{}],
	(* length of fields should be same *)
		Test["If there are samples to be parametrized, Balance, Weighboat, Tweezer, and TabletParametrizationReplicates needs to be populated:",
			And[
			!NullQ[Balance],
			!NullQ[WeighBoat],
			!NullQ[Tweezer],
			!NullQ[TabletParameterizationReplicates]
			],
			True
		],
		{}
	],


	If[MatchQ[Lookup[packet,Status],Completed],
	(* length of fields should be same *)
		Test["Length of TabletWeights/TabletWeightStandardDeviations/TabletWeightDistributions should equal TabletWeightParameterizations:",
			And[
			Length[Lookup[packet,TabletWeightParameterizations]] == Length[Lookup[packet,TabletWeights]],
			Length[Lookup[packet,TabletWeightParameterizations]] == Length[Lookup[packet,TabletWeightStandardDeviations]],
			Length[Lookup[packet,TabletWeightParameterizations]] == Length[Lookup[packet,TabletWeightDistributions]]
			],
			True
		],
		{}
	],

	If[MatchQ[Lookup[packet,Status],Completed],
	(* length of fields should be same *)
		Test["Length of TotalSampleWeights should equal TotalWeightMeasurementSamples:",
			Length[Lookup[packet,TotalSampleWeights]] == Length[Lookup[packet,TotalWeightMeasurementSamples]],
			True
		],
		{}
	]

};

(* ::Subsection::Closed:: *)
(*validProtocolMeasureDissolvedOxygenQTests*)


validProtocolMeasureDissolvedOxygenQTests[packet:PacketP[Object[Protocol,MeasureDissolvedOxygen]]]:={

	(* shared fields not null *)
	NotNullFieldTest[packet, {
		ContainersIn,
		SamplesIn
	}],

	NullFieldTest[packet,{
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	(* UPON COMPLETION *)
	RequiredWhenCompleted[packet,{SamplesIn,DissolvedOxygen,Data}]
};


(* ::Subsection::Closed:: *)
(*validProtocolMeasureMeltingPointQTests*)


validProtocolMeasureMeltingPointQTests[packet:PacketP[Object[Protocol,MeasureMeltingPoint]]]:={

	(* shared fields not null *)
	NotNullFieldTest[packet, {
		(*Specific fields not null*)
		SamplesIn,
		ContainersIn,
		Instrument,
		Grind,
		Desiccate,
		MinTemperatures,
		EquilibrationTimes,
		MaxTemperatures,
		TemperatureRampRates,
		RampTimes,
		DesiccantContainer
	}],


	NullFieldTest[packet,
		{
			NitrogenPressureLog,
			CO2PressureLog,
			ArgonPressureLog,
			InitialNitrogenPressure,
			InitialArgonPressure,
			InitialCO2Pressure
		}
	],

	Test["If both Grind and Desiccate are set to True, OrdersOfOperation must be informed:",
		If[MatchQ[{Lookup[packet, Grind], Lookup[packet,Grind]},{True, True}],
			!MatchQ[Lookup[packet, OrdersOfOperations],NullP|{}],
			True
		],
		True
	],

	FieldComparisonTest[packet, {MinTemperatures, MinTemperatures}, Less],


	RequiredTogetherTest[packet,{PestleRate,MortarRate}],


	RequiredTogetherTest[packet,{PreparedSampleContainers,PreparedSampleStorageConditions}],


	Test["If PreparedSampleContainers or PreparedSampleStorageConditions are informed, RecoupSample must be set to True:",
		If[!MatchQ[Lookup[packet,PreparedSampleContainers],NullP|{}],
			MatchQ[Lookup[packet,RecoupSample],True],
			True
		],
		True
	],


	Test["If Grind is set to True, GrinderTypes must be informed:",
		If[MatchQ[Lookup[packet,Grind],True],
			!MatchQ[Lookup[packet,GrinderTypes],NullP|{}],
			True
		],
		True
	],

	Test["The length of GrinderTypes matches the length of SamplesIn:",
		Length[Lookup[packet,SamplesIn]],
		Length[Lookup[packet,GrinderTypes]]
	],

	Test["If Grind is set to True, Grinders must be informed:",
		If[MatchQ[Lookup[packet,Grind],True],
			!MatchQ[Lookup[packet,Grinders],NullP|{}],
			True
		],
		True
	],

	Test["The length of Grinders matches the length of SamplesIn:",
		Length[Lookup[packet,SamplesIn]],
		Length[Lookup[packet,Grinders]]
	],

	Test["If Grind is set to True, GrindingTime must be informed:",
		If[MatchQ[Lookup[packet,Grind],True],
			!MatchQ[Lookup[packet,GrindingTime],NullP|{}],
			True
		],
		True
	],

	Test["The length of Grind matches the length of SamplesIn:",
		Length[Lookup[packet,SamplesIn]],
		Length[Lookup[packet,Grind]]
	],

	Test["If Grind is set to True, NumbersOfGrindingSteps must be informed:",
		If[MatchQ[Lookup[packet,Grind],True],
			!MatchQ[Lookup[packet,NumbersOfGrindingSteps],NullP|{}],
			True
		],
		True
	],

	Test["The length of NumbersOfGrindingSteps matches the length of SamplesIn:",
		Length[Lookup[packet,SamplesIn]],
		Length[Lookup[packet,NumbersOfGrindingSteps]]
	],

	Test["If Grind is set to True, GrindingProfiles must be informed:",
		If[MatchQ[Lookup[packet,Grind],True],
			!MatchQ[Lookup[packet,GrindingProfiles],NullP|{}],
			True
		],
		True
	],

	Test["The length of GrindingProfiles matches the length of SamplesIn:",
		Length[Lookup[packet,SamplesIn]],
		Length[Lookup[packet,GrindingProfiles]]
	],


	Test["If Desiccate is set to True, SampleContainer must be informed:",
		If[MatchQ[Lookup[packet,Desiccate],True],
			!MatchQ[Lookup[packet,SampleContainer],NullP|{}],
			True
		],
		True
	],

	Test["If Desiccate is set to True, DesiccationMethod must be informed:",
		If[MatchQ[Lookup[packet,Desiccate],True],
			!MatchQ[Lookup[packet,DesiccationMethod],NullP|{}],
			True
		],
		True
	],

	Test["If Desiccate is set to True, Desiccant must be informed:",
		If[MatchQ[Lookup[packet,Desiccate],True],
			!MatchQ[Lookup[packet,Desiccant],NullP|{}],
			True
		],
		True
	],

	Test["If Desiccate is set to True, DesiccantPhase must be informed:",
		If[MatchQ[Lookup[packet,Desiccate],True],
			!MatchQ[Lookup[packet,DesiccantPhase],NullP|{}],
			True
		],
		True
	],

	Test["If Desiccate is set to True, DesiccantAmount must be informed:",
		If[MatchQ[Lookup[packet,Desiccate],True],
			!MatchQ[Lookup[packet,DesiccantAmount],NullP|{}],
			True
		],
		True
	],

	Test["If Desiccate is set to True, Desiccator must be informed:",
		If[MatchQ[Lookup[packet,Desiccate],True],
			!MatchQ[Lookup[packet,Desiccator],NullP|{}],
			True
		],
		True
	],

	Test["If Desiccate is set to True, DesiccationTime must be informed:",
		If[MatchQ[Lookup[packet,Desiccate],True],
			!MatchQ[Lookup[packet,DesiccationTime],NullP|{}],
			True
		],
		True
	],

	(*  Test["If DesiccantPhase is set to Liquid, DesiccantContainer must be informed:",
      If[MatchQ[Lookup[packet,DesiccantPhase],Liquid],
        !MatchQ[Lookup[packet,DesiccantContainer],NullP|{}],
        True
      ],
      True
    ],*)

	Test["If DesiccantPhase is set to Liquid, DesiccantAmount must be in a unit of volume:",
		If[MatchQ[Lookup[packet,DesiccantPhase],Liquid],
			VolumeQ[Lookup[packet,DesiccantAmount]],
			True
		],
		True
	],

	Test["If DesiccantPhase is set to Solid, DesiccantAmount must be in a unit of mass:",
		If[MatchQ[Lookup[packet,DesiccantPhase],Solid],
			MassQ[Lookup[packet,DesiccantAmount]],
			True
		],
		True
	],

	Test["If Desiccate is set to True, Cameras must be informed:",
		If[MatchQ[Lookup[packet,Desiccate],True],
			!MatchQ[Lookup[packet,Cameras],NullP|{}],
			True
		],
		True
	],

	(* UPON COMPLETION *)
	RequiredWhenCompleted[packet,{
		Data
	}],

	Test["If the protocol is completed, the length of Data should be equal to the length of SamplesIn:",
		{Status,Length[DeleteCases[Lookup[packet,Data],Null]]},
		{Completed,Length[DeleteCases[Lookup[packet,SamplesIn],Null]]}|{Except[Completed],_}
	],

	Test["If the protocol is completed, GrindingVideos must be informed if Grind is set to True and GrinderType is set to MortarGrinder:",
		If[
			And[
				MatchQ[Lookup[packet,Status],Completed],
				MatchQ[Lookup[packet,Grind],True],
				MatchQ[Lookup[packet,GrinderType], MortarGrinder]
			],
			!MatchQ[Lookup[packet,GrindingVideos],NullP|{}],
			True
		],
		True
	],

	Test["If the protocol is completed, DesiccationVideo must be informed if Desiccate is True:",
		If[
			And[
				MatchQ[Lookup[packet,Status],Completed],
				MatchQ[Lookup[packet,Desiccate], True]
			],
			!MatchQ[Lookup[packet,DesiccationVideo],NullP|{}],
			True
		],
		True
	]

};

(* ::Subsection::Closed:: *)
(*validProtocolMeasurepHQTests*)


validProtocolMeasurepHQTests[packet:PacketP[Object[Protocol,MeasurepH]]]:={

	(* shared fields not null *)
	NotNullFieldTest[
		packet,
		{
			ContainersIn
		}
	],

	NullFieldTest[
		packet,
		{
			ContainersOut,
			SamplesOut,
			NitrogenPressureLog,
			CO2PressureLog,
			ArgonPressureLog,
			InitialNitrogenPressure,
			InitialArgonPressure,
			InitialCO2Pressure
		}
	],

	(* Immersion stuff required together *)
	RequiredTogetherTest[
		packet,
		{
			ProbeSamples,
			ProbeInstruments,
			ProbeRecoupSample,
			ProbeAcquisitionTimes,
			ProbeIndices,
			ProbeBatchLength,
			ProbeInstrumentsSelect,
			ProbeInstrumentsRelease,
			ProbeNumberOfAcquisitions,
			ProbeParameters
		}
	],

	RequiredTogetherTest[
		packet,
		{
			ProbeDirtyPipetteBulb,
			ProbeDirtyWashSolution,
			ProbeCleanPipetteBulb,
			ProbeCleanWashSolution
		}
	],

	If[TrueQ[Lookup[packet,InSitu]],
		Nothing,
		RequiredTogetherTest[
			packet,
			{
				ProbeLowCalibrationBuffer,
				ProbeMediumCalibrationBuffer,
				ProbeHighCalibrationBuffer
			}
		]
	],

	(* Droplet stuff required together *)
	RequiredTogetherTest[
		packet,
		{
			DropletSamples,
			DropletInstruments,
			DropletRecoupSample,
			DropletWashSolution,
			DropletIndices,
			DropletBatchLength,
			DropletInstrumentsSelect,
			DropletInstrumentsRelease,
			DropletParameters
		}
	],

	If[TrueQ[Lookup[packet,InSitu]],
		Nothing,
		RequiredTogetherTest[
			packet,
			{
				DropletLowCalibrationBuffer,
				DropletMediumCalibrationBuffer,
				DropletHighCalibrationBuffer
			}
		]
	],

	(* UPON COMPLETION *)
	RequiredWhenCompleted[
		packet,
		{
			SamplesIn,
			Data
		}
	],

	Test[
		"Unless the protocol is doing preparatory primitives, Samples In should be Informed if the Protocol is not Canceled or Aborted:",
		Lookup[packet,{SamplesIn,PreparatoryUnitOperations,Status}],
		{{ObjectP[Object[Sample]]..},_,_}|{{(ObjectP[{Model[Sample],Object[Sample]}]|Null)..},{Except[Null]..},_}|{_,_,Canceled|Aborted}
	]

};


(* ::Subsection::Closed:: *)
(*validProtocolMeasureRefractiveIndexQTests*)

validProtocolMeasureRefractiveIndexQTests[packet:PacketP[Object[Protocol,MeasureRefractiveIndex]]]:={

	(* Shared fields not null *)
	NotNullFieldTest[packet,{
		ContainersIn,
		SamplesIn,
		Refractometer,
		DensityMeter,
		RefractiveIndexReadingModes,
		Temperatures,
		Calibration,
		SampleVolumes,
		RecoupSamples
	}],

	NullFieldTest[packet,{
		ContainersOut,
		SamplesOut,
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	(* Upon  completion *)
	RequiredWhenCompleted[packet,{
		SamplesIn,
		Data
	}]
};

(* ::Subsection::Closed:: *)
(*validProtocolMeasureSurfaceTensionQTests*)


validProtocolMeasureSurfaceTensionQTests[packet:PacketP[Object[Protocol,MeasureSurfaceTension]]]:={

	(* shared fields not null *)
	NotNullFieldTest[
		packet,
		{
			ContainersIn,
			SamplesIn,
			(* specific to object *)
			Instrument,
			NumberOfCalibrationMeasurements,
			Calibrant,
			CalibrantSurfaceTension,
			EquilibrationTime,
			NumberOfSampleMeasurements,
			ProbeSpeed,
			PreCleaningMethod,
			BurningTime,
			CoolingTime
		}
	],

	NullFieldTest[
		packet,
		{
			NitrogenPressureLog,
			CO2PressureLog,
			ArgonPressureLog,
			InitialNitrogenPressure,
			InitialArgonPressure,
			InitialCO2Pressure
		}
	],

	(* UPON COMPLETION *)
	RequiredWhenCompleted[
		packet,
		{
			Data
		}
	]

};


(* ::Subsection::Closed:: *)
(*validProtocolMeasureViscosityQTests*)


validProtocolMeasureViscosityQTests[packet:PacketP[Object[Protocol,MeasureViscosity]]]:={

	(* shared fields not null *)
	NotNullFieldTest[
		packet,
		{
			ContainersIn,
			SamplesIn,
			(* specific to object *)
			Instrument,
			ViscometerChip,
			SampleTemperature,
			InjectionVolumes,
			InjectionRate,
			MeasurementTemperatures,
			RecoupSamples,
			MeasurementMethodTables
		}
	],

	NullFieldTest[
		packet,
		{
			CO2PressureLog,
			ArgonPressureLog,
			InitialArgonPressure,
			InitialCO2Pressure
		}
	],

	(* UPON COMPLETION *)
	RequiredWhenCompleted[
		packet,
		{
			Data
		}
	]

};


(* ::Subsection::Closed:: *)
(*validProtocolMicroscopeQTests*)


validProtocolMicroscopeQTests[packet:PacketP[Object[Protocol,Microscope]]]:={

(* shared field shaping *)
	NullFieldTest[packet,{
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

(* Required fields *)
	NotNullFieldTest[packet, {
		SamplesIn,
		ContainersIn,

		PhaseContrastImage,

		BlueFluorescenceImage,
		GreenFluorescenceImage,
		RedFluorescenceImage,

		Objective,
		ImagesPerWell,
		LightPath,
		AutoFocusMode,
		AutoFocusCoarseStep,
		AutoFocusFineStep,
		AutoFocusRange,
		AutoFocusStartPoint,
		PlateModel,
		ScanPattern,
		ScanRadius,
		FOVOverlap,
		KohlerIllumination
	}],

(* If the image pattern is set to: Tile Grid, then grid size must be informed *)
	Test["If ScanPattern is set to \"Tile Grid\", GridSize must be informed:",
		Lookup[packet,{ScanPattern,GridSize}],
		{"Tile Grid",Except[NullP]}|{"Random",NullP}
	],

	Test["If PhaseContrastImage is True and Data is informed, then PhaseContrastExposureTime must be informed",
		Lookup[packet,{PhaseContrastImage,Data,PhaseContrastExposureTime}],
		{True, Except[NullP], Except[NullP]}|{True, NullP, NullP}|{False, _, NullP}
	],
	Test["If BlueFluorescenceImage is True and Data is informed, then BlueFluorescenceExposureTime must be informed",
		Lookup[packet,{BlueFluorescenceImage,Data,BlueFluorescenceExposureTime}],
		{True, Except[NullP], Except[NullP]}|{True, NullP, NullP}|{False, _, NullP}
	],
	Test["If GreenFluorescenceImage is True and Data is informed, then GreenFluorescenceExposureTime must be informed",
		Lookup[packet,{GreenFluorescenceImage,Data,GreenFluorescenceExposureTime}],
		{True, Except[NullP], Except[NullP]}|{True, NullP, NullP}|{False, _, NullP}
	],
	Test["If RedFluorescenceImage is True and Data is informed, then RedFluorescenceExposureTime must be informed",
		Lookup[packet,{RedFluorescenceImage,Data,RedFluorescenceExposureTime}],
		{True, Except[NullP], Except[NullP]}|{True, NullP, NullP}|{False, _, NullP}
	],

(* When Completed *)
	RequiredWhenCompleted[packet, {DataFilePath, Data}]

};



(* ::Subsection::Closed:: *)
(*validProtocolMicrowaveDigestionQTests*)


validProtocolMicrowaveDigestionQTests[packet:PacketP[Object[Protocol,MicrowaveDigestion]]]:={

	(* shared field shaping *)
	NullFieldTest[packet,{
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	(* Required fields *)
	NotNullFieldTest[packet, {
		SamplesIn,
		ContainersIn,
		PreparedSample,
		MaxDigestionPressure,
		SampleType
	}],

	(* When Completed *)
	RequiredWhenCompleted[packet, {DataFilePath, Data, ContainersOut, SamplesOut}]
};



(* ::Subsection::Closed:: *)
(*validProtocolNephelometryQTests*)


validProtocolNephelometryQTests[packet:PacketP[Object[Protocol,Nephelometry]]]:={

	NullFieldTest[packet,{
		SamplesOut,
		ContainersOut,
		ArgonPressureLog,
		InitialArgonPressure
	}],

	(* shared fields not null *)
	RequiredWhenCompleted[packet,{Data,SamplesIn}],

	(* unique fields not null *)
	NotNullFieldTest[packet,{
		ContainersIn,
		Instrument,

		(* specific fields *)
		Method,
		PreparedPlate,
		Analytes,
		ReadDirection
	}],

	(* Check groups of fields are all set or all null. Check field groups for temperature, mixing, moat and injections *)
	RequiredTogetherTest[packet,{PlateReaderMixRate,PlateReaderMixTime,PlateReaderMixMode}],
	RequiredTogetherTest[packet,{MoatSize,MoatBuffer,MoatVolume}],
	RequiredTogetherTest[packet,{
		PrimaryInjections,
		PrimaryInjectionFlowRate,
		PrimaryInjectionSample,
		SolventWasteContainer,
		PrimaryPreppingSolvent,
		SecondaryPreppingSolvent,
		PrimaryFlushingSolvent,
		SecondaryFlushingSolvent
	}],

	ResolvedWhenCompleted[packet,{
		Instrument
	}],

	Test["If the protocol is completed, the length of Data should be equal to the length of SamplesIn:",
		{Status,Length[DeleteCases[Lookup[packet,Data],Null]]},
		{Completed,Length[DeleteCases[Lookup[packet,SamplesIn],Null]]}|{Except[Completed],_}
	],

	(*SamplesIn test*)
	Test[
		"Unless the protocol is doing preparatory primitives, Samples In should be Informed if the Protocol is not Canceled or Aborted:",
		Lookup[packet,{SamplesIn,PreparatoryUnitOperations,Status}],
		{{ObjectP[Object[Sample]]..},_,_}|{{(ObjectP[{Model[Sample],Object[Sample]}]|Null)..},{Except[Null]..},_}|{_,_,Canceled|Aborted}
	]

};


(*validProtocolNephelometryKineticsQTests*)
validProtocolNephelometryKineticsQTests[packet:PacketP[Object[Protocol,NephelometryKinetics]]]:={

	NullFieldTest[packet,{
		SamplesOut,
		ContainersOut,
		ArgonPressureLog,
		InitialArgonPressure
	}],

	(* shared fields not null *)
	RequiredWhenCompleted[packet,{Data,MethodFilePath,SamplesIn}],

	(* unique fields not null *)
	NotNullFieldTest[packet,{
		ContainersIn,
		Instrument,

		(* specific fields *)
		Method,
		PreparedPlate,
		Analytes,
		ReadDirection,
		RunTime,
		ReadOrder,
		KineticWindowDurations,
		NumberOfCycles,
		CycleTimes
	}],

	(* Check groups of fields are all set or all null. Check field groups for temperature, mixing, moat and injections *)
	RequiredTogetherTest[packet,{PlateReaderMixRate,PlateReaderMixTime,PlateReaderMixSchedule,PlateReaderMixMode}],
	RequiredTogetherTest[packet,{MoatSize,MoatBuffer,MoatVolume}],
	RequiredTogetherTest[packet,{
		PrimaryInjections,
		PrimaryInjectionFlowRate,
		PrimaryInjectionSample,
		SolventWasteContainer,
		PrimaryPreppingSolvent,
		SecondaryPreppingSolvent,
		PrimaryFlushingSolvent,
		SecondaryFlushingSolvent
	}],

	(* Instrument will be fulfilled after protocol has completed *)
	ResolvedWhenCompleted[packet,{Instrument}],

	Test["If the protocol is completed, the length of Data should be equal to the length of SamplesIn:",
		{Status,Length[DeleteCases[Lookup[packet,Data],Null]]},
		{Completed,Length[DeleteCases[Lookup[packet,SamplesIn],Null]]}|{Except[Completed],_}
	],

	(*SamplesIn test*)
	Test[
		"Unless the protocol is doing preparatory primitives, Samples In should be Informed if the Protocol is not Canceled or Aborted:",
		Lookup[packet,{SamplesIn,PreparatoryUnitOperations,Status}],
		{{ObjectP[Object[Sample]]..},_,_}|{{(ObjectP[{Model[Sample],Object[Sample]}]|Null)..},{Except[Null]..},_}|{_,_,Canceled|Aborted}
	]

};



(* ::Subsection::Closed:: *)
(*validProtocolNMRQTests*)


validProtocolNMRQTests[packet:PacketP[Object[Protocol, NMR]]]:={
	(* shared null *)
	NullFieldTest[packet, {CO2PressureLog, ArgonPressureLog, InitialArgonPressure, InitialCO2Pressure}],

	(* specifc *)
	NotNullFieldTest[packet, {
		Instrument,
		ContainersIn,
		Nuclei,
		DeuteratedSolvents,
		NumberOfScans,
		AcquisitionTimes,
		RelaxationDelays,
		PulseWidths,
		SpectralDomains,
		NMRTubes,
		FlipAngles
	}],

	RequiredWhenCompleted[packet,{
		SamplesIn,
		Data,
		SamplesOut
	}],

	Test["The first index of SpectralDomains is less than the second index:",
		With[{bools = Map[
			TrueQ[#[[1]] < #[[2]]]&,
			Lookup[packet, SpectralDomains]
		]},
			MatchQ[bools, {True...}]
		],
		True
	],

	Test[
		"Unless the protocol is doing preparatory primitives, Samples In should be Informed if the Protocol is not Canceled or Aborted:",
		Lookup[packet,{SamplesIn,PreparatoryUnitOperations,Status}],
		{{ObjectP[Object[Sample]]..},_,_}|{{(ObjectP[{Model[Sample],Object[Sample]}]|Null)..},{Except[Null]..},_}|{_,_,Canceled|Aborted}
	]

};


(* ::Subsection::Closed:: *)
(*validProtocolNMR2DQTests*)


validProtocolNMR2DQTests[packet:PacketP[Object[Protocol, NMR2D]]]:={
	(* shared null *)
	NullFieldTest[packet, {CO2PressureLog, ArgonPressureLog, InitialArgonPressure, InitialCO2Pressure}],

	(* specifc *)
	NotNullFieldTest[packet, {
		Instrument,
		ContainersIn,
		DeuteratedSolvents,
		NMRTubes,
		Probe,
		ExperimentTypes,
		DirectNuclei,
		IndirectNuclei,
		DirectNumberOfPoints,
		DirectAcquisitionTimes,
		DirectSpectralDomains,
		IndirectNumberOfPoints,
		IndirectSpectralDomains,
		SamplingMethods
	}],

	RequiredWhenCompleted[packet,{
		SamplesIn,
		Data,
		SamplesOut
	}],

	Test["The first index of DirectSpectralDomains is less than the second index:",
		With[{bools = Map[
			TrueQ[#[[1]] < #[[2]]]&,
			Lookup[packet, DirectSpectralDomains]
		]},
			MatchQ[bools, {True...}]
		],
		True
	],
	Test["The first index of IndirectSpectralDomains is less than the second index:",
		With[{bools = Map[
			TrueQ[#[[1]] < #[[2]]]&,
			Lookup[packet, IndirectSpectralDomains]
		]},
			MatchQ[bools, {True...}]
		],
		True
	],

	Test["TOCSYMixTimes is populated if and only if ExperimentTypes -> TOCSY | HSQCTOCSY | HMQCTOCSY:",
		Transpose[Lookup[packet, {ExperimentTypes, TOCSYMixTimes}]],
		{Alternatives[
			{TOCSY|HSQCTOCSY|HMQCTOCSY, UnitsP[Millisecond]},
			{Except[TOCSY|HSQCTOCSY|HMQCTOCSY], Null}
		]..}
	],

	Test[
		"Unless the protocol is doing preparatory primitives, Samples In should be Informed if the Protocol is not Canceled or Aborted:",
		Lookup[packet,{SamplesIn,PreparatoryUnitOperations,Status}],
		{{ObjectP[Object[Sample]]..},_,_}|{{(ObjectP[{Model[Sample],Object[Sample]}]|Null)..},{Except[Null]..},_}|{_,_,Canceled|Aborted}
	]
};


(* ::Subsection::Closed:: *)
(*validProtocolPAGEQTests*)


validProtocolPAGEQTests[packet:PacketP[Object[Protocol,PAGE]]]:={
	(*shared Null*)
	NullFieldTest[packet,{
		SamplesOut,
		ContainersOut,

		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	NotNullFieldTest[packet,{
		(* Shared fields shaping *)
		ContainersIn,

		(* Required specific fields *)
		Instrument,
		Gels,
		GelModel,

		ReservoirBuffer,
		GelBuffer,
		NumberOfGels,
		NumberOfLanes,

		PostRunStaining,
		SampleLoadingVolume,
		SeparationTime,
		Voltage,
		DutyCycle,
		CycleDuration,
		LoadingBuffer,
		Ladder,
		ExposureTime,
		SampleDenaturing
	}],

	RequiredTogetherTest[packet,{ExcitationWavelength,ExcitationBandwidth,EmissionWavelength,EmissionBandwidth}],

	(* INDEX MATCHING FIELDS *)
	Test["The length of Gels matches the length of SamplesIn:",
		Length[Lookup[packet,SamplesIn]],
		Length[Lookup[packet,Gels]]
	],

	(* UPON COMPLETION  *)
	ResolvedWhenCompleted[packet,{
		Instrument,
		LoadingPlate,
		LoadingBuffer,
		Ladder,
		Gels
	}],

	RequiredWhenCompleted[packet,{
		SamplesIn,
		MethodFilePath,
		DataFilePath,
		Data,
		LadderData
	}],

	Test["If the protocol is completed, the length of Data should be equal to the length of SamplesIn",
		{Lookup[packet, Status], Length[DeleteCases[Lookup[packet,Data],Null]]},
		Alternatives[
			{Completed,Length[DeleteCases[Lookup[packet,SamplesIn],Null]]},
			{Except[Completed],_}
		]
	],

	Test["Any entries in in the Data field have DataType->Analyte",
		Download[DeleteCases[Lookup[packet,Data],Null], DataType],
		DataType|{}|{Analyte..}
	],

	Test["Any entries in in the LadderData field have DataType->Standard",
		Download[DeleteCases[Lookup[packet,LadderData],Null], DataType],
		DataType|{}|{Standard..}
	],

	Test[
		"Unless the protocol is doing preparatory primitives, Samples In should be Informed if the Protocol is not Canceled or Aborted:",
		Lookup[packet,{SamplesIn,PreparatoryUnitOperations,Status}],
		{{ObjectP[Object[Sample]]..},_,_}|{{(ObjectP[{Model[Sample],Object[Sample]}]|Null)..},{Except[Null]..},_}|{_,_,Canceled|Aborted}
	]
};


(* ::Subsection::Closed:: *)
(*validProtocolPCRQTests*)


validProtocolPCRQTests[packet:PacketP[Object[Protocol,PCR]]]:={

	NotNullFieldTest[packet,{
		(*Shared fields not Null*)
		ContainersIn,

		(*Specific fields not Null*)
		Instrument,
		LidTemperature,
		RunTime,
		ReactionVolume,
		SampleVolumes,
		PlateSeal,
		Activation,
		DenaturationTime,
		DenaturationTemperature,
		DenaturationRampRate,
		PrimerAnnealing,
		ExtensionTime,
		ExtensionTemperature,
		ExtensionRampRate,
		NumberOfCycles,
		FinalExtension,
		HoldTemperature
	}],


	(*Shared fields Null*)
	NullFieldTest[packet,{
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialCO2Pressure,
		InitialArgonPressure
	}],


	(*Required together*)
	RequiredTogetherTest[packet,{
		MasterMix,
		MasterMixVolume
	}],
	RequiredTogetherTest[packet,{
		AssayPlatePrimitives,
		AssayPlateManipulation
	}],
	RequiredTogetherTest[packet,{
		ActivationTime,
		ActivationTemperature,
		ActivationRampRate
	}],
	RequiredTogetherTest[packet,{
		PrimerAnnealingTime,
		PrimerAnnealingTemperature,
		PrimerAnnealingRampRate
	}],
	RequiredTogetherTest[packet,{
		FinalExtensionTime,
		FinalExtensionTemperature,
		FinalExtensionRampRate
	}],


	(*Required when completed*)
	RequiredWhenCompleted[packet,{
		MethodFilePath,
		MethodFileName,
		SamplesOut,
		ContainersOut
	}],


	(*SamplesIn test*)
	Test[
		"Unless the protocol is doing preparatory primitives, Samples In should be Informed if the Protocol is not Canceled or Aborted:",
		Lookup[packet,{SamplesIn,PreparatoryUnitOperations,Status}],
		{{ObjectP[Object[Sample]]..},_,_}|{{(ObjectP[{Model[Sample],Object[Sample]}]|Null)..},{Except[Null]..},_}|{_,_,Canceled|Aborted}
	],


	(*Buffer fields test*)
	Test[
		"Buffer and BufferVolumes are either all informed or all Null(s):",
		Equal@@Map[NullQ[#]&,Lookup[packet,{Buffer,BufferVolumes}]],
		True
	],


	(*Primer fields tests*)
	If[MemberQ[NullQ/@Flatten[Lookup[packet,{ForwardPrimers,ForwardPrimerResources,ForwardPrimerVolumes,ReversePrimers,ReversePrimerResources,ReversePrimerVolumes}]],False],
		Test[
			"If any primer field is populated, the rest are also populated:",
			NullQ/@Flatten[Lookup[packet,{ForwardPrimers,ForwardPrimerResources,ForwardPrimerVolumes,ReversePrimers,ReversePrimerResources,ReversePrimerVolumes}]],
			ListableP[False]
		],
		Nothing
	],
	If[!MatchQ[Lookup[packet,ForwardPrimers],{}],
		Test[
			"For each member of SamplesIn, the length of ForwardPrimerVolumes matches the length of ForwardPrimers:",
			Length/@Lookup[packet,ForwardPrimers],
			Length/@Lookup[packet,ForwardPrimerVolumes]
		],
		Nothing
	],
	If[!MatchQ[Lookup[packet,ReversePrimers],{}],
		Test[
			"For each member of SamplesIn, the length of ReversePrimerVolumes matches the length of ReversePrimers:",
			Length/@Lookup[packet,ReversePrimers],
			Length/@Lookup[packet,ReversePrimerVolumes]
		],
		Nothing
	]

};


(* ::Subsection::Closed:: *)
(*validProtocolPNASynthesisQTests*)


validProtocolPNASynthesisQTests[packet:PacketP[Object[Protocol,PNASynthesis]]]:={

	(* shared null *)
	NullFieldTest[packet, {Data,SamplesIn,ContainersIn,CO2PressureLog,ArgonPressureLog,InitialArgonPressure,InitialCO2Pressure}],

	(* specifc *)
	NotNullFieldTest[packet, {
		StrandModels,
		Scale,TargetLoadings,
		Instrument,
		Resin,
		SynthesisStrategy,
		InitialCapping,
		FinalCapping,
		FinalDeprotection,
		Cleavage,
		DownloadResins,
		DeprotectionSolution,
		CappingSolution,
		ReactionVessels,
		RecoupMonomers
	}],

	(* shared not-null *)
	RequiredWhenCompleted[packet, {
		SamplesOut,
		ContainersOut,
		InitialNitrogenPressure,
		NitrogenPressureLog
	}],

	ResolvedWhenCompleted[packet, {
		Instrument,
		DeprotectionSolution,
		CappingSolution
	}],

	RequiredTogetherTest[packet, {
		CleavageSolution,
		CleavageVolumes,
		CleavageTimes,
		NumbersOfCleavageCycles,
		CollectionVessels,
		CleavedReactionVessels
	}],

	RequiredTogetherTest[packet, {
		TriturationSolution,
		TriturationVolume,
		TriturationTime,
		TriturationTemperature,
		TriturationCentrifugationRate,
		TriturationCentrifugationTime,
		TriturationCentrifugationForce,
		NumberOfTriturationCycles
	}],


	(* If not Canceled, then SwellSolution,SwellResin,SwellVolumes,and SwellTimes are either all informed, or not *)
	Test["If a protocol has been completed, then SwellSolution, SwellResin, SwellVolumes, and SwellTimes are either all informed, or not informed:",
		Lookup[packet, {Status, SwellSolution, SwellResin,SwellVolumes,SwellTimes}],
		Alternatives[
			{Completed,Except[NullP],Except[NullP],Except[{}],Except[{}]},
			{Completed,NullP,NullP,{},{}},
			{Except[Completed],_,_,_,_}
		]
	],

(* If not Canceled, then Methanol, PrimaryResinShrinkVolumes, and PrimaryResinShrinkTimes are either all informed, or not *)
	Test["If a protocol has been completed, then Methanol,PrimaryResinShrinkVolumes,PrimaryResinShrinkTimes are either all informed, or not informed:",
		Lookup[packet, {Status,Methanol,PrimaryResinShrinkVolumes,PrimaryResinShrinkTimes}],
		Alternatives[
			{Completed,Except[NullP],Except[{}],Except[{}]},
			{Completed,NullP,{},{}},
			{Except[Completed],_,_,_}
		]
	],

(* If not Canceled, then SecondaryResinShrinkSolution, SecondaryResinShrinkVolumes, and SecondaryResinShrinkTimes are either all informed, or not *)
	Test["If a protocol has been completed, then SecondaryResinShrinkSolution, SecondaryResinShrinkVolumes, and SecondaryResinShrinkTimes are either all informed, or not informed:",
		Lookup[packet, {Status,SecondaryResinShrinkSolution,SecondaryResinShrinkVolumes,SecondaryResinShrinkTimes}],
		Alternatives[
			{Completed,Except[NullP],Except[{}],Except[{}]},
			{Completed,NullP,{},{}},
			{Except[Completed],_,_,_}
		]
	],

	Test["If the protocol is completed, the CleavedStrandModels and UncleavedStrandModels field have to be populated based on the values in the Cleavage field:",
		If[MatchQ[Lookup[packet,Status],Completed],
			MatchQ[Lookup[packet, {Cleavage, CleavedStrandModels, UncleavedStrandModels}],
				Alternatives[
				(* If there are any True values in Cleavage, then CleavedStrandModels has to have something *)
					{_?(ContainsAny[#,{True}] &),Except[{}], _},
				(* If there are any False values in Cleavage, then UncleavedStrandModels has to have something *)
					{_?(ContainsAny[#,{False}] &),_,Except[{}]}
				]],
			True],
		True
	],

	Test["The CleavedStrandModels and UncleavedStrandModels field have to be empty based on the values in the Cleavage field:",
		Lookup[packet, {Cleavage, CleavedStrandModels, UncleavedStrandModels}],
		Alternatives[
		(* If there are any True values in Cleavage, then CleavedStrandModels has to have something *)
			{_?(AllTrue[#,TrueQ]&), Except[{}], {}},
		(* If there are any False values in Cleavage, then UncleavedStrandModels has to have something *)
			{_?(NoneTrue[#, TrueQ] &), {}, Except[{}]}
		]
	],

	Test["The DownloadedStrandModels field has to be populated based on the value of the DownloadResins field:",
		Lookup[packet, {DownloadResins,DownloadedStrandModels,DownloadMonomers}],
		Alternatives[
			{_?(ContainsAny[#,{True}] &),Except[{}],Except[{}]},
			{_?(NoneTrue[#,TrueQ] &),{},{}}
		]
	],

	Test["The RecoupedMonomers field has to be populated based on the value of the RecoupMonomers and Status field:",
		Lookup[packet, {Status, RecoupMonomers, RecoupedMonomers}],
		Alternatives[
			{Completed,True,Except[{}]},
			{_,_,_}
		]
	],

	Test["The RecoupedMonomersContainers field has to be populated based on the value of the RecoupMonomers field:",
		Lookup[packet, {RecoupMonomers, RecoupedMonomersContainers}],
		Alternatives[
			{True,Except[{}]},
			{False,{}}
		]
	],

	Test["The VacuumManifold field has to be populated based on the value of the DownloadResins field:",
		Lookup[packet, {DownloadResins, VacuumManifold}],
		Alternatives[
			{_?(ContainsAny[#,{False}] &),Except[NullP]},
			{_,NullP}
		]
	],

	Test["If the protocol is completed, and TriturationSolution is populated, then TriturationManipulations should also be populated:",
		Lookup[packet, {Status,TriturationSolution,TriturationManipulations}],
		Alternatives[
			{Completed,Except[NullP],Except[{}]},
			{Completed,NullP,{}},
			{Except[Completed],_,_}
		]
	],

	Test["If the protocol is completed, and ResuspensionBuffer is populated, then resuspension related fields should also be populated:",
		Lookup[packet, {Status,ResuspensionBuffer,ResuspensionVolumes,ResuspensionManipulation,NumbersOfResuspensionMixes}],
		Alternatives[
			{Completed,Except[NullP],Except[{}],Except[NullP],Except[{}]},
			{Completed,NullP,{},NullP,{}},
			{Except[Completed],_,_,_,_}
		]
	],

	Test["Depending on the type of Instrument, SeptumSheet and SeptumCaps must or must not be populated:",
		Lookup[packet,{Instrument,SeptumSheet,SeptumCaps}],
		Alternatives[
			{ObjectP[{Model[Instrument, LiquidHandler], Object[Instrument, LiquidHandler]}], Except[NullP],NullP},
			{ObjectP[{Model[Instrument, PeptideSynthesizer], Object[Instrument, PeptideSynthesizer]}], NullP,Except[NullP]}
		]
	],

  (* ReactionVesselWeights was added in May 2017, hence the DateConfirmed *)
	Test["If a protocol has been completed, then ReactionVesselWeights should be informed:",
		Lookup[packet, {Status, ReactionVesselWeights, DateConfirmed}],
		Alternatives[
			{Completed, Except[{}], _?(#>=DateObject[List[2017, 5, 18]]&)},
			{Completed, _, _?(#<DateObject[List[2017, 5, 18]]&)},
			{Except[Completed], _, _}
		]
	],

	Test["If Instrument is a PeptideSynthesizer, ActivationSolution must be informed:",
		Lookup[packet,{Instrument,ActivationSolution}],
		Alternatives[
			{ObjectP[{Model[Instrument, LiquidHandler], Object[Instrument, LiquidHandler]}], NullP},
			{ObjectP[{Model[Instrument, PeptideSynthesizer], Object[Instrument, PeptideSynthesizer]}], Except[NullP]}
		]
	],

	Test["If Instrument is a LiquidHandler, WashSyringe, WashNeedle, CleavageSyringes, CleavageNeedles must be informed:",
		Lookup[packet,{Instrument,WashSyringe,WashNeedle,CleavageSyringes,CleavageNeedles}],
		Alternatives[
			{
				ObjectP[{Model[Instrument, LiquidHandler], Object[Instrument, LiquidHandler]}],
				Except[NullP],
				Except[NullP],
				Except[NullP],
				Except[NullP]
			},
			{
				ObjectP[{Model[Instrument, PeptideSynthesizer], Object[Instrument, PeptideSynthesizer]}],
				NullP,
				NullP,
				{},
				{}
			}
		]
	],

	Test["VacuumManifold must be populated only if one of the strands is not being downloaded.",
		Lookup[packet, {VacuumManifold, DownloadResins}],
		Alternatives[
			{Except[NullP],_?(ContainsAny[#,{False}]&)},
			{NullP,_?(ContainsOnly[#,{True}]&)}
		]
	]
};



(* ::Subsection::Closed:: *)
(*validProtocolPrepareReferenceElectrodeQTests*)


validProtocolPrepareReferenceElectrodeQTests[packet:PacketP[Object[Protocol, PrepareReferenceElectrode]]]:={
	NullFieldTest[packet, {CO2PressureLog, ArgonPressureLog, InitialArgonPressure, InitialCO2Pressure}],

	NotNullFieldTest[packet, {
		SamplesIn,
		ReferenceElectrodes,
		TargetReferenceElectrodeModels,
		OriginReferenceElectrodeModels,
		ReferenceSolutions,
		FumeHood,
		PolishReferenceElectrode,
		ReferenceElectrodeNeedsAspiration,
		PrimingVolumes,
		NumberOfPrimings,
		ReferenceElectrodePrimingSyringes,
		ReferenceElectrodeReferenceSolutionCollectionContainers,
		ElectrodeRefillVolumes,
		ReferenceElectrodeRefillSyringes,
		ReferenceElectrodeRefillNeedles,
		UniqueReferenceSolutions,
		PrimingSyringes,
		PrimingNeedles,
		ReferenceSolutionCollectionContainers,
		ReferenceElectrodePrimingSoakTimes,
		MaxPrimingSoakTime,
		Tweezers,
		ReferenceElectrodeStorageContainers
	}],

	(* Required When Completed *)
	RequiredWhenCompleted[packet, {
		SamplesOut,
		ContainersOut,
		ReferenceElectrodeRustChecking,
		PolishingPerformed
	}],

	RequiredTogetherTest[packet, {
		WasteReferenceSolutionCollectionContainer,
		WasteReferenceSolutionCollectionSyringe,
		WasteReferenceSolutionCollectionNeedle
	}],

	RequiredTogetherTest[packet, {
		UniqueWashingSolutions,
		WashingSyringes,
		WashingNeedles,
		WashingSolutionCollectionContainers
	}],

	RequiredTogetherTest[packet, {
		PrimaryWashingSolutions,
		PrimaryWashingSolutionVolumes,
		NumberOfPrimaryWashings,
		PrimaryWashingSyringes,
		PrimaryWashingSolutionCollectionContainers
	}],

	RequiredTogetherTest[packet, {
		SecondaryWashingSolutions,
		SecondaryWashingSolutionVolumes,
		NumberOfSecondaryWashings,
		SecondaryWashingSyringes,
		SecondaryWashingSolutionCollectionContainers
	}],

	(* Other Tests *)
	Test[
		"If PolishReferenceElectrode contains True, Sandpaper is informed:",
		Module[{polishReferenceElectrodes, sandpaper},
			{polishReferenceElectrodes, sandpaper} = Lookup[packet,{PolishReferenceElectrode, Sandpaper}];
			{MemberQ[polishReferenceElectrodes, True], sandpaper}
		],
		Alternatives[
			{True, ObjectP[{Model[Item, Consumable, Sandpaper], Object[Item, Consumable, Sandpaper]}]},
			{False, Null}
		]
	]
};


(* ::Subsection::Closed:: *)
(*validProtocolPowderXRDQTests*)


validProtocolPowderXRDQTests[packet:PacketP[Object[Protocol, PowderXRD]]]:={
	(* shared null *)
	NullFieldTest[packet, {CO2PressureLog, ArgonPressureLog, InitialArgonPressure, InitialCO2Pressure}],

	(* specifc *)
	NotNullFieldTest[packet, {
		Current,
		Instrument,
		SampleHandler,
		ExposureTimes,
		DetectorDistances
	}],

	Test[
		"Unless the protocol is doing preparatory primitives, Samples In should be Informed if the Protocol is not Canceled or Aborted:",
		Lookup[packet,{SamplesIn,PreparatoryUnitOperations,Status}],
		{{ObjectP[Object[Sample]]..},_,_}|{{(ObjectP[{Model[Sample],Object[Sample]}]|Null)..},{Except[Null]..},_}|{_,_,Canceled|Aborted}
	]
};



(* ::Subsection::Closed:: *)
(*validProtocolProteinPrepQTests*)


validProtocolProteinPrepQTests[packet:PacketP[Object[Protocol,ProteinPrep]]]:={

(* Shared fields Null *)
	NullFieldTest[packet,{
		Data,
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	NotNullFieldTest[packet,{
	(* shared fields not null *)
		SamplesIn,
		ContainersIn,

	(* unique fields not null *)
		ProteinPrepProgram,
		WashBuffer,
		LysisBufferVolume,
		TotalVolume,
		AliquotVolume,
		CellType,
		NumberOfAliquots,
		LysisTemperature,
		LysisTime
	}],

(* unique fields required only when protocol is completed *)
	RequiredWhenCompleted[packet,{
		SamplesOut,
		ContainersOut
	}]
};



(* ::Subsection::Closed:: *)
(* validProtocolRamanSpectroscopyQTests *)


validProtocolRamanSpectroscopyQTests[packet:PacketP[Object[Protocol,RamanSpectroscopy]]]:={

	(* shared null fields *)
	NullFieldTest[packet, {
		SamplesOut,
		ContainersOut,
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	(* shared not null fields *)
	NotNullFieldTest[packet, {
		SamplesIn,
		ContainersIn,
		Instrument,
		DateCreated,
		Status,
		ResolvedOptions,
		UnresolvedOptions
	}],

	(* unique shared fields *)
	NotNullFieldTest[packet, {
		SamplePlate,
		CalibrationCheck,
		SampleType,
		BackgroundRemove,
		CosmicRadiationFilter,
		ReadOrder,
		ReadParameters,
		SamplingPattern
	}],

	(* shared not-null when completed *)
	RequiredWhenCompleted[packet, {
		Data,
		LaserPower,
		ExposureTime
	}],

	(* need to figure out a way to check the sampling patterns since they are index matched it is not straightforward *)

	Test[
		"Unless the protocol is doing preparatory primitives, Samples In should be Informed if the Protocol is not Canceled or Aborted:",
		Lookup[packet,{SamplesIn,PreparatoryUnitOperations,Status}],
		{{ObjectP[Object[Sample]]..},_,_}|{{(ObjectP[{Model[Sample],Object[Sample]}]|Null)..},{Except[Null]..},_}|{_,_,Canceled|Aborted}
	]

};


(* ::Subsection::Closed:: *)
(*validProtocolRoboticCOVID19TestQTests*)


validProtocolRoboticCOVID19TestQTests[packet:PacketP[Object[Protocol,RoboticCOVID19Test]]]:={
	NotNullFieldTest[packet,{
		(*Shared fields not Null*)
		ContainersIn,

		(*Specific fields not Null*)
		(*===RNA Extraction===*)
		BiosafetyCabinet,
		Disinfectant,
		RNAExtractionPlate,
		LysisMasterMix,
		MagneticBeads,
		ProteaseSolution,
		PrimaryWashSolution,
		SecondaryWashSolution,
		ElutionSolution,
		ElutionPlate,
		(*===RT-qPCR===*)
		ReactionVolume,
		NoTemplateControl,
		ViralRNAControl,
		SampleVolume,
		ForwardPrimers,
		ForwardPrimerVolume,
		ReversePrimers,
		ReversePrimerVolume,
		Probes,
		ProbeVolume,
		ProbeExcitationWavelength,
		ProbeExcitationWavelength,
		MasterMix,
		MasterMixVolume,
		ReactionBuffer,
		ReactionBufferVolume,
		Thermocycler,
		ReverseTranscriptionRampRate,
		ReverseTranscriptionTemperature,
		ReverseTranscriptionTime,
		ActivationRampRate,
		ActivationTemperature,
		ActivationTime,
		DenaturationRampRate,
		DenaturationTemperature,
		DenaturationTime,
		ExtensionRampRate,
		ExtensionTemperature,
		ExtensionTime,
		NumberOfCycles
	}],


	(*Shared fields Null*)
	NullFieldTest[packet,{
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialCO2Pressure,
		InitialArgonPressure
	}],


	(*Required when completed*)
	RequiredWhenCompleted[packet,{
		LysisPrimitives,
		LysisManipulation,
		RNAExtractionPrimitives,
		RNAExtractionManipulation,
		TestSamples,
		AnalysisNotebook
	}],


	(*SamplesIn test*)
	Test[
		"Unless the protocol is doing preparatory primitives, Samples In should be Informed if the Protocol is not Canceled or Aborted:",
		Lookup[packet,{SamplesIn,PreparatoryUnitOperations,Status}],
		{{ObjectP[Object[Sample]]..},_,_}|{{(ObjectP[{Model[Sample],Object[Sample]}]|Null)..},{Except[Null]..},_}|{_,_,Canceled|Aborted}
	]
};


(* ::Subsection::Closed:: *)
(*validProtocolRoboticSamplePreparationQTests*)

validProtocolRoboticSamplePreparationQTests[packet:PacketP[Object[Protocol, RoboticSamplePreparation]]]:={};


(* ::Subsection::Closed:: *)
(*validProtocolRoboticCellPreparationQTests*)

validProtocolRoboticCellPreparationQTests[packet:PacketP[Object[Protocol, RoboticCellPreparation]]]:={

	(* XOr between ColonyHandler and LiquidHandler fields *)
	Module[{colonyHandler,liquidHandler},
		colonyHandler = Download[Lookup[packet, ColonyHandler, Null], Object];
		liquidHandler = Download[Lookup[packet, LiquidHandler, Null], Object];

		Test["Either ColonyHandler or LiquidHandler must be specified, but they both cannot be specified.",
			{colonyHandler, liquidHandler},
			Alternatives[
				{Null,ObjectP[{Object[Instrument, LiquidHandler], Model[Instrument,LiquidHandler]}]},
				{ObjectP[{Object[Instrument, ColonyHandler], Model[Instrument,ColonyHandler]}], Null}
			]
		]
	]
};


(* ::Subsection::Closed:: *)
(*validProtocolqPCRQTests*)


validProtocolqPCRQTests[packet:PacketP[Object[Protocol,qPCR]]]:={

	NotNullFieldTest[packet,{
	(* shared fields not null *)
		ContainersIn,
	(* unique field tests *)
		MasterMix,
		ReactionVolume,
		MasterMixVolume,
		RunTime,
		SampleVolumes,
		BufferVolumes,
		ForwardPrimers,
		ReversePrimers,

		(* Stage master switches *)
		ReverseTranscription,
		Activation,
		PrimerAnnealing,
		MeltingCurve,

		(* Non-optional step parameters *)
		DenaturationTemperature,
		DenaturationTime,
		DenaturationRampRate,
		ExtensionTemperature,
		ExtensionTime,
		ExtensionRampRate,
		NumberOfCycles
	}],

	(* some unique fields must be populated if using an array card *)
	If[!NullQ[Lookup[packet,ArrayCard]],
		NotNullFieldTest[packet,{Probes,ProbeFluorophores,ProbeExcitationWavelengths,ProbeEmissionWavelengths}],
		Nothing
	],

	(* some unique fields must be populated if not using an array card *)
	If[NullQ[Lookup[packet,ArrayCard]],
		NotNullFieldTest[packet,{AssayPlate,PlateSeal,ForwardPrimerVolumes,ReversePrimerVolumes}],
		Nothing
	],

(* shared fields null *)
	NullFieldTest[packet,{
		SamplesOut,
		ContainersOut,
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

(* Required together *)

	RequiredTogetherTest[packet, {
		(* Standard parameters *)
		Standards,
		StandardVolume,
		SerialDilutionFactors,
		NumberOfDilutions,
		NumberOfStandardReplicates,
		StandardForwardPrimers,
		StandardReversePrimers,
		StandardForwardPrimerVolumes,
		StandardReversePrimerVolumes
	}],

	RequiredTogetherTest[packet,{
		DuplexStainingDye,
		(* DuplexStainingDyeVolume not required because usually included in master mix *)
		DuplexStainingDyeExcitationWavelength,
		DuplexStainingDyeEmissionWavelength
	}],

	RequiredTogetherTest[packet,{
		Probes,
		ProbeExcitationWavelengths,
		ProbeEmissionWavelengths
	}],

	RequiredTogetherTest[packet, {
		ReferenceDye,
		(* ReferenceDyeVolume not required because usually included in master mix *)
		ReferenceDyeExcitationWavelength,
		ReferenceDyeEmissionWavelength
	}],

	RequiredTogetherTest[packet,{
		EndogenousForwardPrimers,
		EndogenousReversePrimers,
		EndogenousForwardPrimerVolumes,
		EndogenousReversePrimerVolumes
	}],

	RequiredTogetherTest[packet,{
		EndogenousProbes,
		EndogenousProbeVolumes,
		EndogenousProbeExcitationWavelengths,
		EndogenousProbeEmissionWavelengths
	}],

	RequiredTogetherTest[packet,{
		ReverseTranscriptionTemperature,
		ReverseTranscriptionTime,
		ReverseTranscriptionRampRate
	}],

	RequiredTogetherTest[packet,{
		ActivationTemperature,
		ActivationTime,
		ActivationRampRate
	}],

	RequiredTogetherTest[packet,{
		PrimerAnnealingTemperature,
		PrimerAnnealingTime,
		PrimerAnnealingRampRate
	}],

	RequiredTogetherTest[packet,{
		MeltingCurveTime,
		MeltingCurveStartTemperature,
		MeltingCurveEndTemperature,
		PreMeltingCurveRampRate,
		MeltingCurveRampRate
	}],

	RequiredTogetherTest[packet,{
		StandardProbes,
		StandardProbeVolumes,
		StandardProbeExcitationWavelengths,
		StandardProbeEmissionWavelengths
	}],

	(* Required after compile / after sample manip *)
	(* AssayPlatePrimitives, AssayPlateManipulation, MethodFilePath *)

	(* Required when completed *)
	RequiredWhenCompleted[packet, {
		SamplesIn,
		MethodFileName,
		(* MethodFilePath,  *)
		Data
	}],

	(* StandardData must be populated when completed if standards were run *)
	If[!MatchQ[Lookup[packet, Standards], {}],
		RequiredWhenCompleted[packet, {StandardData}],
		Nothing
	],

	Test[
		"Unless the protocol is doing preparatory primitives, Samples In should be Informed if the Protocol is not Canceled or Aborted:",
		Lookup[packet,{SamplesIn,PreparatoryUnitOperations,Status}],
		{{ObjectP[Object[Sample]]..},_,_}|{{(ObjectP[{Model[Sample],Object[Sample]}]|Null)..},{Except[Null]..},_}|{_,_,Canceled|Aborted}
	]

};

(* ::Subsection::Closed:: *)
(*validProtocolDigitalPCRQTests*)


validProtocolDigitalPCRQTests[packet:PacketP[Object[Protocol,DigitalPCR]]]:={

	(* Shared field shaping - Not Null *)
	NotNullFieldTest[packet,{
		ContainersIn
	}],

	(* shared fields null *)
	NullFieldTest[packet,{
		SamplesOut,
		ContainersOut,
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}]

	(* Add a test to catch preparatory primitives if prepared plate is true? *)

};


(* ::Subsection::Closed:: *)
(*validProtocolTotalProteinDetectionQTests*)


validProtocolTotalProteinDetectionQTests[packet:PacketP[Object[Protocol,TotalProteinDetection]]]:={

	(* Shared field shaping - Not Null *)
	NotNullFieldTest[packet,{
		ContainersIn
	}],

	(* Null fields *)
	NullFieldTest[packet, {
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	(* Required when complete *)
	RequiredWhenCompleted[packet, {
		SamplesIn,
		MethodFilePath,
		MethodFileName,
		DataFilePath,
		DataFileName,
		SamplePlatePrimitives,
		SamplePlateManipulation,
		AssayPlatePrimitives,
		AssayPlateManipulation,
		DataFile,
		Data
	}],


	(* Non-shared fields - Not Null *)
	NotNullFieldTest[packet,{
		MolecularWeightRange,
		Instrument,
		DetectionMode,
		Denaturing,
		SeparatingMatrixLoadTime,
		StackingMatrixLoadTime,
		SampleVolumes,
		LoadingBufferVolumes,
		LoadingVolume,
		Ladder,
		LadderVolume,
		SamplePlate,
		AssayPlate,
		CapillaryCartridge,
		SampleLoadTime,
		Voltage,
		SeparationTime,
		UVExposureTime,
		WashBuffer,
		WashBufferVolume,
		LabelingReagent,
		LabelingReagentVolume,
		LabelingTime,
		BlockingBuffer,
		BlockingBufferVolume,
		LadderBlockingBuffer,
		BlockingTime,
		BlockWashTime,
		NumberOfBlockWashes,
		PeroxidaseReagent,
		PeroxidaseReagentVolume,
		PeroxidaseIncubationTime,
		PeroxidaseWashTime,
		NumberOfPeroxidaseWashes,
		LuminescenceReagent,
		LuminescenceReagentVolume,
		SignalDetectionTimes
	}],

	Test[
		"Unless the protocol is doing preparatory primitives, Samples In should be Informed if the Protocol is not Canceled or Aborted:",
		Lookup[packet,{SamplesIn,PreparatoryUnitOperations,Status}],
		{{ObjectP[Object[Sample]]..},_,_}|{{(ObjectP[{Model[Sample],Object[Sample]}]|Null)..},{Except[Null]..},_}|{_,_,Canceled|Aborted}
	]
};


(* ::Subsection::Closed:: *)
(*validProtocolTotalProteinQuantificationQTests*)


validProtocolTotalProteinQuantificationQTests[packet:PacketP[Object[Protocol,TotalProteinQuantification]]]:={

(* Shared field shaping - Not Null *)
	NotNullFieldTest[packet,{
		ContainersIn
	}],

(* Shared field shaping - Null *)
	NullFieldTest[packet, {
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure,
		SamplesOut,
		ContainersOut
	}],

(* Non-shared fields - not Null *)
	NotNullFieldTest[packet,{
		DetectionMode,
		Instrument,
		StandardCurveReplicates,
		LoadingVolume,
		QuantificationReagent,
		QuantificationReagentVolume,
		QuantificationPlate,
		QuantificationWavelengths,
		QuantificationEquilibrationTime
	}],

(* Non-Shared fields - required when complete *)
	RequiredWhenCompleted[packet,{
		SamplesIn,
		QuantificationPlatePrimitives,
		QuantificationPlateManipulation,
		QuantificationAnalyses,
		SpectroscopyData,
		StandardsSpectroscopyData,
		InputSamplesSpectroscopyData
	}],

	Test[
		"Unless the protocol is doing preparatory primitives, Samples In should be Informed if the Protocol is not Canceled or Aborted:",
		Lookup[packet,{SamplesIn,PreparatoryUnitOperations,Status}],
		{{ObjectP[Object[Sample]]..},_,_}|{{(ObjectP[{Model[Sample],Object[Sample]}]|Null)..},{Except[Null]..},_}|{_,_,Canceled|Aborted}
	]
};


(* ::Subsection::Closed:: *)
(*validProtocolSampleManipulationQTests*)


validProtocolSampleManipulationQTests[packet:PacketP[Object[Protocol,SampleManipulation]]]:={

(* Shared field shaping *)
	NullFieldTest[packet,{
		CO2PressureLog,
		ArgonPressureLog,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	NotNullFieldTest[packet,Manipulations],

(* --- Micro Manipulations --- *)
	Test["If protocol is complete and LiquidHandlingScale is Micro, Program is required:",
		If[
			And[
				MatchQ[Lookup[packet, LiquidHandlingScale],MicroLiquidHandling],
				MatchQ[Lookup[packet, Status],Completed]
			],
			Not[NullQ[Lookup[packet, Program]]],
			True
		],
		True
	],

	Test["If protocol is complete and LiquidHandlingScale is Micro and the protocol was executed in Rosetta, LiquidHandler is required:",
		If[
			And[
				MatchQ[Lookup[packet, LiquidHandlingScale],MicroLiquidHandling],
				MatchQ[Lookup[packet, Status],Completed],
				Not[NullQ[Lookup[packet, ProcedureLog]]]
			],
			Not[NullQ[Lookup[packet, LiquidHandler]]],
			True
		],
		True
	],

(* The trace info is informed if the protocol is completed *)
	Test["If the protocol has been completed and LiquidHandlingScale is Micro, LiquidHandlingLogs and LiquidHandlingLogPaths must be informed:",
		Lookup[packet, {Status,MicroLiquidHandling,LiquidHandlingLogs,LiquidHandlingLogPaths}],
		Alternatives[
			{Completed,MicroLiquidHandling,_List?(Length[#]>0&),_List?(Length[#]>0&)},
			{Except[Completed],_,_,_},
			{_,Except[MicroLiquidHandling],_,_}
		]
	],

(* --- Macro Manipulations --- *)
	Test["If protocol is complete and LiquidHandlingScale is Macro, Program is required:",
		If[
			And[
				MatchQ[Lookup[packet, LiquidHandlingScale],MacroLiquidHandling],
				MatchQ[Lookup[packet, Status],Completed]
			],
			Not[NullQ[Lookup[packet, MacroTransfers]]],
			True
		],
		True
	],

	If[
		MatchQ[Lookup[packet, Status], Completed]&&NullQ[Lookup[packet,ParentProtocol]],
		AnyInformedTest[packet,{SamplesIn,SamplesOut}],
		Nothing
	],
	If[
		MatchQ[Lookup[packet, Status], Completed],
		AnyInformedTest[packet,{ContainersIn,ContainersOut}],
		Nothing
	]

};

validProtocolSampleManipulationAliquotQTests[packet:PacketP[Object[Protocol,SampleManipulation,Aliquot]]]:={};


(* ::Subsection::Closed:: *)
(*validProtocolSampleManipulationDiluteQTests*)

validProtocolSampleManipulationDiluteQTests[packet : PacketP[Object[Protocol, SampleManipulation, Dilute]]] := {};

(* ::Subsection::Closed:: *)
(*validProtocolSampleManipulationResuspendQTests*)


validProtocolSampleManipulationResuspendQTests[packet : PacketP[Object[Protocol, SampleManipulation, Resuspend]]] := {};


(* ::Subsection::Closed:: *)
(*validProtocolSolidPhaseExtractionQTests*)


validProtocolSolidPhaseExtractionQTests[packet:PacketP[Object[Protocol,SolidPhaseExtraction]]]:={

(* shared fields not null *)
	NotNullFieldTest[packet, {ContainersIn}],

(* shared required after completion*)
	RequiredWhenCompleted[packet, {
		SamplesIn,
		SamplesOut,
		ContainersOut
	}],

(* shared fields null *)
	NullFieldTest[packet, {
		Data,
		CO2PressureLog,
		ArgonPressureLog,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

(* unique fields not null *)
	NotNullFieldTest[packet,{
		Instrument,
		ExtractionCartridge
	}],


(* rinsing required together *)
	Test["If RinseAndReload is True, RinseVolume filled in, not otherwise:",
		AllTrue[
			MapThread[
			If[
				Or[
					And[TrueQ[#1], VolumeQ[#2]],
					And[Not[TrueQ[#1]], NullQ[#2]]
				],
				True, False
			] &,
			Lookup[packet, {RinseAndReloads, RinseVolumes}]
		], TrueQ
		],
		True
	],

(* Required After Completion.*)
	RequiredWhenCompleted[packet, {
		BufferPlacements,
		CartridgePlacements,
		SamplePlacements,
		CollectionPlatePlacements,
		InitialPurgePressure,
		WasteWeight,
		PurgePressureLog,
		NitrogenPressureLog,
		InitialNitrogenPressure
	}],

	Test[
		"Unless the protocol is doing preparatory primitives, Samples In should be Informed if the Protocol is not Canceled or Aborted:",
		Lookup[packet,{SamplesIn,PreparatoryUnitOperations,Status}],
		{{ObjectP[Object[Sample]]..},_,_}|{{(ObjectP[{Model[Sample],Object[Sample]}]|Null)..},{Except[Null]..},_}|{_,_,Canceled|Aborted}
	]

};


(* ::Subsection::Closed:: *)
(*validProtocolStockSolutionQTests*)


validProtocolStockSolutionQTests[packet:PacketP[Object[Protocol,StockSolution]]]:={

(* shared fields null *)
	NullFieldTest[packet,{
		ContainersIn,
		Data,
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	(* unique fields not null *)
	NotNullFieldTest[packet,{
		RequestedVolumes,
		PreparatoryContainers,
		ContainersOut
	}],

	(* mixing *)
	RequiredTogetherTest[packet,{MixParameters,MixedSolutions}],

	(* filtration *)
	RequiredTogetherTest[packet,{FiltrationSamples,FiltrationParameters}],

	(* pHing*)
	RequiredTogetherTest[packet,{MinpHs, MaxpHs}]
};


(* ::Subsection::Closed:: *)
(*validProtocolSFCQTests*)


validProtocolSFCQTests[packet:PacketP[Object[Protocol,SupercriticalFluidChromatography]]]:= {

	(* shared fields null *)
	NullFieldTest[packet,{
		SamplesOut,
		ContainersOut
	}],

	NotNullFieldTest[packet, {
		Instrument,
		Scale,
		SeparationMode,
		Detectors,
		InjectionTable,
		SampleTemperature,
		SampleVolumes,
		GradientMethods,
		CO2Gradient,
		GradientA,
		GradientB,
		GradientC,
		GradientD,
		BackPressures,
		FlowRate,
		MaxAcceleration,
		ContainersIn
	}],

	RequiredWhenCompleted[packet, {
		SamplesIn,
		NeedleWashSolution,
		SystemPrimeBufferA,
		SystemPrimeBufferB,
		SystemPrimeBufferC,
		SystemPrimeBufferD,
		SystemPrimeMakeupSolvent,
		SystemPrimeBufferPlacements,
		InitialSystemPrimeBufferAAppearance,
		InitialSystemPrimeBufferBAppearance,
		InitialSystemPrimeBufferCAppearance,
		InitialSystemPrimeBufferDAppearance,
		InitialSystemPrimeMakeupSolventAppearance,
		SystemPrimeGradient,
		FinalSystemPrimeBufferAAppearance,
		FinalSystemPrimeBufferBAppearance,
		FinalSystemPrimeBufferCAppearance,
		FinalSystemPrimeBufferDAppearance,
		FinalSystemPrimeMakeupSolventAppearance,
		CosolventA,
		CosolventB,
		CosolventC,
		CosolventD,
		MakeupSolvent,
		CosolventACap,
		CosolventBCap,
		CosolventCCap,
		CosolventDCap,
		MakeupSolventCap,
		Calibrant,
		BufferContainerPlacements,
		InitialCosolventAAppearance,
		InitialCosolventBAppearance,
		InitialCosolventCAppearance,
		InitialCosolventDAppearance,
		InitialMakeupSolventAppearance,
		AutosamplerDeckPlacements,
		SystemPrimeData,
		SystemFlushData,
		InitialAnalyteVolumes,
		FinalAnalyteVolumes,
		InjectedAnalyteVolumes,
		FinalCosolventAAppearance,
		FinalCosolventBAppearance,
		FinalCosolventCAppearance,
		FinalCosolventDAppearance,
		FinalMakeupSolventAppearance,
		SystemFlushCosolventA,
		SystemFlushCosolventB,
		SystemFlushCosolventC,
		SystemFlushCosolventD,
		SystemFlushMakeupSolvent,
		SystemFlushContainerPlacements,
		InitialSystemFlushCosolventAAppearance,
		InitialSystemFlushCosolventBAppearance,
		InitialSystemFlushCosolventCAppearance,
		InitialSystemFlushCosolventDAppearance,
		InitialSystemFlushMakeupSolventAppearance,
		SystemFlushGradient,
		FinalSystemFlushCosolventAAppearance,
		FinalSystemFlushCosolventBAppearance,
		FinalSystemFlushCosolventCAppearance,
		FinalSystemFlushCosolventDAppearance,
		FinalSystemFlushMakeupSolventAppearance,
		InitialNitrogenPressure,
		NitrogenPressureLog,
		InitialCO2Pressure,
		CO2PressureLog
	}],

	RequiredTogetherTest[packet, {ColumnPrimeGradientMethods, ColumnPrimeCO2Gradient, ColumnPrimeGradientA, ColumnPrimeGradientB, ColumnPrimeGradientC, ColumnPrimeGradientD, ColumnPrimeBackPressure, ColumnPrimeFlowRates, ColumnPrimeTemperatures}],
	RequiredTogetherTest[packet, {ColumnPrimeIonModes, ColumnPrimeMakeupFlowRates, ColumnPrimeMassSelections, ColumnPrimeMinMasses, ColumnPrimeMaxMasses, ColumnPrimeSourceTemperatures, ColumnPrimeESICapillaryVoltages, ColumnPrimeSamplingConeVoltages, ColumnPrimeScanTimes, ColumnPrimeMassDetectionGains}],
	RequiredTogetherTest[packet, {ColumnPrimeMinAbsorbanceWavelengths, ColumnPrimeMaxAbsorbanceWavelengths, ColumnPrimeWavelengthResolutions, ColumnPrimeUVFilter, ColumnPrimeAbsorbanceSamplingRates}],
	RequiredTogetherTest[packet, {Columns, ColumnTemperatures}],
	RequiredTogetherTest[packet, {IonModes, MakeupFlowRates, MassSelection, MinMasses, MaxMasses, SourceTemperatures, ESICapillaryVoltages, SamplingConeVoltages, ScanTimes, MassDetectionGains}],
	RequiredTogetherTest[packet, {MinAbsorbanceWavelengths, MaxAbsorbanceWavelengths, WavelengthResolutions, UVFilters, AbsorbanceSamplingRates}],
	RequiredTogetherTest[packet, {Standards, StandardSampleVolumes, StandardGradientMethods, StandardCO2Gradient, StandardGradientA, StandardGradientB, StandardGradientC, StandardGradientD, StandardBackPressures, StandardFlowRates, StandardColumns, StandardColumnTemperatures}],
	RequiredTogetherTest[packet, {StandardIonModes, StandardMakeupFlowRates, StandardMassSelection, StandardMinMasses, StandardMaxMasses, StandardSourceTemperatures, StandardESICapillaryVoltages, StandardSamplingConeVoltages, StandardSamplingConeVoltages, StandardScanTimes, StandardMassDetectionGains}],
	RequiredTogetherTest[packet, {StandardMinAbsorbanceWavelengths, StandardMaxAbsorbanceWavelengths, StandardWavelengthResolutions, StandardUVFilters, StandardAbsorbanceSamplingRates}],
	RequiredTogetherTest[packet, {Blanks, BlankSampleVolumes, BlankGradientMethods, BlankCO2Gradient, BlankGradientA, BlankGradientB, BlankGradientC, BlankGradientD, BlankBackPressures, BlankFlowRates, BlankColumns, BlankColumnTemperatures}],
	RequiredTogetherTest[packet, {BlankIonModes, BlankMakeupFlowRates, BlankMassSelection, BlankMinMasses, BlankMaxMasses, BlankSourceTemperatures, BlankESICapillaryVoltages, BlankSamplingConeVoltages, BlankScanTimes, BlankMassDetectionGains}],
	RequiredTogetherTest[packet, {BlankMinAbsorbanceWavelengths, BlankMaxAbsorbanceWavelengths, BlankWavelengthResolutions, BlankUVFilters, BlankAbsorbanceSamplingRates}],
	RequiredTogetherTest[packet, {ColumnFlushGradientMethods, ColumnFlushCO2Gradient, ColumnFlushGradientA, ColumnFlushGradientB, ColumnFlushGradientC, ColumnFlushGradientD, ColumnFlushBackPressures, ColumnFlushFlowRates, ColumnFlushTemperatures}],
	RequiredTogetherTest[packet, {ColumnFlushIonModes, ColumnFlushMakeupFlowRates, ColumnFlushMassSelections, ColumnFlushMinMasses, ColumnFlushMaxMasses, ColumnFlushSourceTemperatures, ColumnFlushESICapillaryVoltages, ColumnFlushSamplingConeVoltages, ColumnFlushScanTimes, ColumnFlushMassDetectionGains}],
	RequiredTogetherTest[packet, {ColumnFlushMinAbsorbanceWavelengths, ColumnFlushMaxAbsorbanceWavelengths, ColumnFlushWavelengthResolutions, ColumnFlushUVFilters, ColumnFlushAbsorbanceSamplingRates}],

	(*all the mass spec related requirements*)
	If[MemberQ[Lookup[packet,Detectors],MassSpectrometry],
		NotNullFieldTest[packet,{AcquisitionMode, MassAnalyzer, IonSource}],
		Nothing
	],

	Test["If the protocol is completed, the length of Data should be equal to the length of SamplesIn:",
		{Status,Length[DeleteCases[Lookup[packet,Data],Null]]},
		{Completed,Length[DeleteCases[Lookup[packet,SamplesIn],Null]]}|{Except[Completed],_}
	],


	Test["If the protocol is completed, the length of BlankData should be equal to the length of Blanks:",
		{Status,Length[DeleteCases[Lookup[packet,BlankData],Null]]},
		{Completed,Length[DeleteCases[Lookup[packet,Blanks],Null]]}|{Except[Completed],_}
	],


	Test["If the protocol is completed, the length of StandardData should be equal to the length of Standards:",
		{Status,Length[DeleteCases[Lookup[packet,StandardData],Null]]},
		{Completed,Length[DeleteCases[Lookup[packet,Standards],Null]]}|{Except[Completed],_}
	],

	Test[
		"Unless the protocol is doing preparatory primitives, Samples In should be Informed if the Protocol is not Canceled or Aborted:",
		Lookup[packet,{SamplesIn,PreparatoryUnitOperations,Status}],
		{{ObjectP[Object[Sample]]..},_,_}|{{(ObjectP[{Model[Sample],Object[Sample]}]|Null)..},{Except[Null]..},_}|{_,_,Canceled|Aborted}
	]


};



(* ::Subsection::Closed:: *)
(*validProtocolThermalShiftQTests*)


validProtocolThermalShiftQTests[packet:PacketP[Object[Protocol,ThermalShift]]]:={

	(* Shared field shaping - Not Null *)
	NotNullFieldTest[packet,{
		ContainersIn,
		SamplesIn,
		ReactionVolume,
		AssayContainers,
		SampleVolumes,
		AssayContainers,
		MinTemperature,
		MaxTemperature,
		TemperatureRampOrder,
		EquilibrationTime,
		NumberOfCycles,
		TemperatureRamping,
		TemperatureRampRate,
		DynamicLightScattering
	}],

	NullFieldTest[packet, {
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	RequiredTogetherTest[packet,{
		NumberOfTemperatureRampSteps,
		StepHoldTime
	}],

	RequiredTogetherTest[packet,{
		DynamicLightScatteringLaserPower,
		DynamicLightScatteringDiodeAttenuation
	}],


	RequiredWhenCompleted[packet, {
		SamplesIn,
		DataFiles
	}],

	RequiredTogetherTest[packet, {MinTemperature,MaxTemperature}],

	RequiredTogetherTest[packet, {DetectionReagents, DetectionReagentVolumes}],

	RequiredTogetherTest[packet, {Buffers, BufferVolumes}],

	RequiredTogetherTest[packet, {MinEmissionWavelengths, MaxEmissionWavelengths}],

	AnyInformedTest[packet,{EmissionWavelengths,MinEmissionWavelengths, MaxEmissionWavelengths}],

	(*if the instrument is a multimode spectrophotometer the following fields must be specified otherwise they must be Null*)
	If[MatchQ[Lookup[packet,Instrument],ObjectP[{Object[Instrument,MultimodeSpectrophotometer],Model[Instrument,MultimodeSpectrophotometer]}]],
		NotNullFieldTest[packet,{
			FluorescenceLaserPower,
			StaticLightScatteringLaserPower,
			TemperatureResolution,
			SampleStageLid,
			CapillaryStripLoadingRack,
			CapillaryGaskets,
			CapillaryClips,
			CapillaryStripPreparationPlate
		}],
		NullFieldTest[packet,{
			TemperatureResolution,
			SampleStageLid,
			CapillaryStripLoadingRack,
			CapillaryGaskets,
			CapillaryClips,
			CapillaryStripPreparationPlate
		}]
	],

	(*if the instrument is a multimode spectrophotometer, at least one fluorescence or sls excitation must be informed*)
	If[MatchQ[Lookup[packet,Instrument],ObjectP[{Object[Instrument,MultimodeSpectrophotometer],Model[Instrument,MultimodeSpectrophotometer]}]],
		AnyInformedTest[packet,{
			StaticLightScatteringExcitationWavelengths,
			ExcitationWavelengths
		}],
		{
			NotNullFieldTest[packet,ExcitationWavelengths]
		}
	],

	Test[
		"Unless the protocol is doing preparatory primitives, Samples In should be Informed if the Protocol is not Canceled or Aborted:",
		Lookup[packet,{SamplesIn,PreparatoryUnitOperations,Status}],
		{{ObjectP[Object[Sample]]..},_,_}|{{(ObjectP[{Model[Sample],Object[Sample]}]|Null)..},{Except[Null]..},_}|{_,_,Canceled|Aborted}
	]
};


(* ::Subsection::Closed:: *)
(*validProtocolTransfectionQTests*)


validProtocolTransfectionQTests[packet:PacketP[Object[Protocol,Transfection]]]:={

(* Shared fields Null *)
	NullFieldTest[packet,{
		Data,
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	NotNullFieldTest[packet, {
	(* Shared fields not Null *)
		TransfectionProgram,
		SamplesIn,
		ContainersIn,
		SamplesOut,
		ContainersOut,
	(* Unique fields not null *)
		TransfectionCargo,
		TransfectionCargoVolumes,
		TransfectionReagent,
		TransfectionReagentVolumes,
		Buffer,
		BufferVolumes,
		TransfectionBooster,
		TransfectionBoosterVolumes
	}],

(* Lengths of MapThreaded fields should match *)
	Test[
		"All MapThreaded fields should match in length:",
		Length/@Lookup[packet, {
			TransfectionCargo,
			TransfectionCargoVolumes,
			TransfectionReagent,
			TransfectionReagentVolumes,
			Buffer,
			BufferVolumes,
			TransfectionBooster,
			TransfectionBoosterVolumes
		}],
		{len_Integer..}
	]
};


(* ::Subsection::Closed:: *)
(*validProtocolIncubateQTests*)


validProtocolIncubateQTests[packet:PacketP[Object[Protocol,IncubateOld]]]:={

	(* shared field shaping *)
	NotNullFieldTest[packet,{
		ContainersIn,
		SamplesIn
	}],

	NullFieldTest[packet, {
		ContainersOut,
		Data,
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],


	(* Required fields *)
	NotNullFieldTest[packet, {
		Thaw,
		IncubationTime,
		IncubationTemperature,
		ThermalIncubator,
		MinAnnealingTime,
		RunTime,
		IncubatePrograms
	}],

	(* Required After Completion.*)
	RequiredWhenCompleted[packet, {
		AnnealingTimes,
		CurrentTemperature
	}],

	(* If the thermal incubation protocol will generate a Mix protocol, MixProtocol is informed.*)
	Test[
		"If Mix is equal to True, MixProtocol is informed:",
		If[
			TrueQ[Lookup[packet, Mix]],
			!NullQ[Lookup[packet, MixProtocols]],
			True
		],
		True
	],

	(* If the thermal incubation protocol will generate a centrifuge protocol, CentrifugeProtocol is informed.*)
	Test[
		"If Centrifuge is equal to True, CentrifugeProtocol is informed:",
		If[
			TrueQ[Lookup[packet, Centrifuge]],
			!NullQ[Lookup[packet, CentrifugeProtocols]],
			True
		],
		True
	],

	RequiredAfterCheckpoint[packet,"Storing Samples",{SamplesOut}]

};


(* ::Subsection::Closed:: *)
(*validProtocolEvaporateQTests*)


validProtocolEvaporateQTests[packet:PacketP[Object[Protocol,Evaporate]]]:={

	(*Shared field not null *)
	NotNullFieldTest[packet,{
		ContainersIn
	}],

	(* shared fields null *)
	NullFieldTest[packet,{
		Data,
		CO2PressureLog,
		ArgonPressureLog,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	(*specific field tests*)
	NotNullFieldTest[packet, {
		EvaporationTypes,
		Instruments,
		EquilibrationTimes,
		EvaporationTimes,
		EvaporationTemperatures
	}],

	Test[
		"If any samples are undergoing evaporation on a SpeedVac, the following fields must not be Null at those sample indexs {VacuumEvaporationMethods, EvaporationPressures, PressureRampTimes}:",
		Module[{rotovapIndexes},
			rotovapIndexes = Position[Lookup[packet,EvaporationTypes],SpeedVac];
			Extract[Lookup[packet,#],rotovapIndexes]&/@{
				VacuumEvaporationMethods,
				EvaporationPressures,
				PressureRampTimes
			}
		],
		{}|{Repeated[Except[Null]]}
	],

	ResolvedAfterCheckpoint[packet,"Picking Resources",{Instruments}],

	Test[
		"If any samples are undergoing RotaryEvaporation, the following fields must not be Null at those sample indexs {BathFluids, EvaporationFlask, CondensationFlask, BumpTraps, EvaporationPressures, RotationRates, CondensorTemperatures, PressureRampTimes}:",
		Module[{rotovapIndexes},
			rotovapIndexes = Position[Lookup[packet,EvaporationTypes],RotaryEvaporation];
			Extract[Lookup[packet, #],rotovapIndexes]&/@{
				BathFluids,
				EvaporationFlasks,
				CondensationFlasks,
				BumpTraps,
				EvaporationPressures,
				RotationRates,
				CondenserTemperatures,
				PressureRampTimes
			}
		],
		{}|{Repeated[Except[Null]]}
	],

	Test[
		"If any samples are undergoing NitrogenBlowDown evaporation, the following fields must not be Null at those sample indexs {FlowRateProfile}:",
		Module[{nitroIndexes},
			nitroIndexes = Position[Lookup[packet,EvaporationTypes],NitrogenBlowDown];
			Extract[Lookup[packet,FlowRateProfiles],nitroIndexes]
		],
			Except[NullP]
	],

	(* If one of these informed, they must both be populated *)
	RequiredTogetherTest[packet,{RinseSolutions, RinseVolumes}],

	Test[
		"Unless the protocol is doing preparatory primitives, Samples In should be Informed if the Protocol is not Canceled or Aborted:",
		Lookup[packet,{SamplesIn,PreparatoryUnitOperations,Status}],
		{{ObjectP[Object[Sample]]..},_,_}|{{(ObjectP[{Model[Sample],Object[Sample]}]|Null)..},{Except[Null]..},_}|{_,_,Canceled|Aborted}
	]

};


(* ::Subsection::Closed:: *)
(*validProtocolWesternQTests*)


validProtocolWesternQTests[packet:PacketP[Object[Protocol,Western]]]:={

(* Shared field shaping - Not Null *)
	NotNullFieldTest[packet,{
		ContainersIn
	}],

	NullFieldTest[packet, {
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	RequiredWhenCompleted[packet, {
		SamplesIn,
		MethodFilePath,
		MethodFileName,
		DataFilePath,
		DataFileName,
		SamplePlatePrimitives,
		SamplePlateManipulation,
		AntibodyPlatePrimitives,
		AntibodyPlateManipulation,
		AssayPlatePrimitives,
		AssayPlateManipulation,
		DataFile,
		Data
	}],


(* Non-shared fields - Not Null *)
	NotNullFieldTest[packet,{
		MolecularWeightRange,
		Instrument,
		DetectionMode,
		Denaturing,
		SeparatingMatrixLoadTime,
		StackingMatrixLoadTime,
		SampleVolumes,
		LoadingBufferVolumes,
		LoadingVolume,
		Ladder,
		LadderVolume,
		SamplePlate,
		AssayPlate,
		CapillaryCartridge,
		SampleLoadTime,
		Voltage,
		SeparationTime,
		UVExposureTime,
		WashBuffer,
		WashBufferVolume,
		LabelingReagent,
		LabelingReagentVolume,
		LabelingTime,
		BlockingBuffers,
		BlockingBufferVolume,
		LadderBlockingBuffer,
		LadderBlockingBufferVolume,
		BlockingTime,
		BlockWashTime,
		NumberOfBlockWashes,
		PrimaryAntibodies,
		PrimaryAntibodyVolumes,
		PrimaryAntibodyDilutionFactors,
		SystemStandards,
		AntibodyPlate,
		PrimaryIncubationTime,
		PrimaryWashTime,
		NumberOfPrimaryWashes,
		SecondaryAntibodies,
		SecondaryAntibodyVolumes,
		SecondaryIncubationTime,
		SecondaryWashTime,
		NumberOfSecondaryWashes,
		LadderPeroxidaseReagent,
		LadderPeroxidaseReagentVolume,
		LuminescenceReagent,
		LuminescenceReagentVolume,
		SignalDetectionTimes
	}],

	Test[
		"Unless the protocol is doing preparatory primitives, Samples In should be Informed if the Protocol is not Canceled or Aborted:",
		Lookup[packet,{SamplesIn,PreparatoryUnitOperations,Status}],
		{{ObjectP[Object[Sample]]..},_,_}|{{(ObjectP[{Model[Sample],Object[Sample]}]|Null)..},{Except[Null]..},_}|{_,_,Canceled|Aborted}
	]
};


(* ::Subsection::Closed:: *)
(*validProtocolCapillaryELISAQTests*)


validProtocolCapillaryELISAQTests[packet:PacketP[Object[Protocol,CapillaryELISA]]]:={

	(* Shared field shaping - Not Null *)
	NotNullFieldTest[packet,{
		ContainersIn
	}],

	(* Shared field - Null *)
	NullFieldTest[packet,{
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure,
		SamplesOut,
		ContainersOut
	}],

	(* Non-shared fields - Not Null *)
	NotNullFieldTest[packet,{
		Instrument,
		CartridgeType,
		Species,
		Multiplex,
		SerialDilution,
		Diluents,
		DilutionContainer,
		DilutionMixVolumes,
		DilutionNumberOfMixes,
		DilutionMixRates,
		LoadingVolumes,
		WashBuffer
	}],

	RequiredWhenCompleted[packet,{
		SamplesIn,
		Cartridge,
		MethodFilePath,
		MethodFileName,
		MethodFile,
		DataFilePath,
		DataFileName,
		DataFile,
		Data,
		SampleManipulationPrimitives,
		SampleManipulationProtocol
	}],

	(* Depending on whether the experiment is a multiplex test or not, different fields are required *)
	Which[
		TrueQ[packet[Multiplex]],
		NotNullFieldTest[packet,{MultiplexAnalyteMolecules,MultiplexAnalyteNames}],
		MatchQ[packet[CartridgeType],Customizable],
		NotNullFieldTest[packet,{AnalyteMolecules}],
		True,
		NotNullFieldTest[packet,{AnalyteMolecules,AnalyteNames}]
	],

	RequiredTogetherTest[packet,{DilutionAssayVolumes,StartingDilutionFactors,DilutionFactorIncrements,NumberOfDilutions}],

	RequiredTogetherTest[packet,{SerialDilutionAssayVolumes,SerialDilutionFactors,NumberOfSerialDilutions}],

	AnyInformedTest[packet,{DilutionAssayVolumes,DilutionCurves,SerialDilutionAssayVolumes,SerialDilutionCurves}],

	(* Customizable cartridge and pre-loaded cartridge should provide different information *)
	If[MatchQ[packet[CartridgeType],Customizable],
		{
			NotNullFieldTest[packet,{CustomCaptureAntibodies,CustomDetectionAntibodies,CaptureAntibodyLoadingVolumes,DetectionAntibodyLoadingVolumes}],
			NullFieldTest[packet,{ManufacturingSpecifications,UpperQuantitationLimits,LowerQuantitationLimits,StandardCurveFunctions}]
		},
		{
			NullFieldTest[packet,{CustomCaptureAntibodies,CustomDetectionAntibodies,CaptureAntibodyLoadingVolumes,DetectionAntibodyLoadingVolumes}],
			NotNullFieldTest[packet,{ManufacturingSpecifications,UpperQuantitationLimits,LowerQuantitationLimits}]
		}
	],

	(* Spike and SpikeConcentration should be provided together *)
	RequiredTogetherTest[packet,
		{
			SpikeSamples,
			SpikeVolumes,
			SpikeConcentrations
		}
	],

	RequiredTogetherTest[packet,
		{
			CaptureAntibodyResuspensionConcentrations,
			CaptureAntibodyResuspensionDiluents
		}
	],

	RequiredTogetherTest[packet,
		{
			CaptureAntibodyVolumes,
			DigoxigeninReagents,
			DigoxigeninReagentVolumes,
			CaptureAntibodyConjugationBuffers,
			CaptureAntibodyConjugationBufferVolumes,
			CaptureAntibodyConjugationContainers,
			CaptureAntibodyPurificationColumns,
			CaptureAntibodyColumnWashBuffers,
			CaptureAntibodyConjugationStorageConditions
		}
	],

	RequiredTogetherTest[packet,
		{
			CaptureAntibodyTargetConcentrations,
			CaptureAntibodyDiluents
		}
	],

	RequiredTogetherTest[packet,
		{
			DetectionAntibodyResuspensionConcentrations,
			DetectionAntibodyResuspensionDiluents
		}
	],

	RequiredTogetherTest[packet,
		{
			DetectionAntibodyVolumes,
			BiotinReagents,
			BiotinReagentVolumes,
			DetectionAntibodyConjugationBuffers,
			DetectionAntibodyConjugationBufferVolumes,
			DetectionAntibodyConjugationContainers,
			DetectionAntibodyPurificationColumns,
			DetectionAntibodyColumnWashBuffers,
			DetectionAntibodyConjugationStorageConditions
		}
	],

	RequiredTogetherTest[packet,
		{
			DetectionAntibodyTargetConcentrations,
			DetectionAntibodyDiluents
		}
	],

	RequiredTogetherTest[packet,
		{
			Standards,
			StandardCompositions,
			StandardSerialDilution,
			StandardDiluents,
			StandardDilutionMixVolumes,
			StandardDilutionNumberOfMixes,
			StandardDilutionMixRates,
			StandardLoadingVolumes
		}
	],

	If[!MatchQ[packet[Standards],Null|{}],
		{
			RequiredWhenCompleted[packet,{StandardData}],
			AnyInformedTest[packet,{StandardDilutionAssayVolumes,StandardDilutionCurves,StandardSerialDilutionAssayVolumes,StandardSerialDilutionCurves}]
		},
		NullFieldTest[packet,{StandardData}]
	],

	RequiredTogetherTest[packet,{StandardDilutionAssayVolumes,StandardStartingDilutionFactors,StandardDilutionFactorIncrements,StandardNumberOfDilutions}],

	RequiredTogetherTest[packet,{StandardSerialDilutionAssayVolumes,StandardSerialDilutionFactors,StandardNumberOfSerialDilutions}],

	If[(!MatchQ[packet[Standards],Null|{}])&&(MatchQ[packet[CartridgeType],Customizable]),
		NotNullFieldTest[packet,{StandardCaptureAntibodies,StandardDetectionAntibodies,StandardCaptureAntibodyLoadingVolumes,StandardDetectionAntibodyLoadingVolumes}],
		NullFieldTest[packet,{StandardResuspensions,StandardResuspensionConcentrations,StandardResuspensionDiluents,StandardStorageConditions,StandardResuspensionDiluentVolumes,StandardCaptureAntibodies,StandardDetectionAntibodies,StandardCaptureAntibodyLoadingVolumes,StandardDetectionAntibodyLoadingVolumes}]
	],

	RequiredTogetherTest[packet,
		{
			StandardCaptureAntibodyResuspensionConcentrations,
			StandardCaptureAntibodyResuspensionDiluents
		}
	],

	RequiredTogetherTest[packet,
		{
			StandardCaptureAntibodyVolumes,
			StandardDigoxigeninReagents,
			StandardDigoxigeninReagentVolumes,
			StandardCaptureAntibodyConjugationBuffers,
			StandardCaptureAntibodyConjugationBufferVolumes,
			StandardCaptureAntibodyConjugationContainers,
			StandardCaptureAntibodyPurificationColumns,
			StandardCaptureAntibodyColumnWashBuffers,
			StandardCaptureAntibodyConjugationStorageConditions
		}
	],

	RequiredTogetherTest[packet,
		{
			StandardCaptureAntibodyTargetConcentrations,
			StandardCaptureAntibodyDiluents
		}
	],

	RequiredTogetherTest[packet,
		{
			StandardDetectionAntibodyResuspensionConcentrations,
			StandardDetectionAntibodyResuspensionDiluents
		}
	],

	RequiredTogetherTest[packet,
		{
			StandardDetectionAntibodyVolumes,
			StandardBiotinReagents,
			StandardBiotinReagentVolumes,
			StandardDetectionAntibodyConjugationBuffers,
			StandardDetectionAntibodyConjugationBufferVolumes,
			StandardDetectionAntibodyConjugationContainers,
			StandardDetectionAntibodyPurificationColumns,
			StandardDetectionAntibodyColumnWashBuffers,
			StandardDetectionAntibodyConjugationStorageConditions
		}
	],

	RequiredTogetherTest[packet,
		{
			StandardDetectionAntibodyTargetConcentrations,
			StandardDetectionAntibodyDiluents
		}
	]

};

(* ::Subsection::Closed:: *)
(*validProtocolELISAQTests*)


validProtocolELISAQTests[packet:PacketP[Object[Protocol,ELISA]]]:={

	(* Shared field shaping - Not Null *)
	NotNullFieldTest[packet,{
		SamplesIn
	}],

	(* Shared field - Null *)
	NullFieldTest[packet,{
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure,
		SamplesOut,
		ContainersOut
	}],

	(* Non-shared fields - Not Null *)
	NotNullFieldTest[packet,{
		Instrument,
		Method,
		Coating,
		Blocking,
		WashingBuffer,
		PrimaryAntibodies,
		PrimaryAntibodyStorageConditions,
		SubstrateSolutions,
		SubstrateSolutionVolumes,
		SubstrateIncubationTime,
		SubstrateIncubationTemperature,
		AbsorbanceWavelengths,
		SignalCorrection,
		ELISAPlate,
		ELISAPlateAssignment
	}],

	RequiredWhenCompleted[packet,{
		MethodFilePath,
		MethodFileName,
		MethodFile,
		DataFilePath,
		DataFileNames,
		DataFiles,
		Data,
		ELISAPrimitives
	}],

	(*Required antibodies based on methods*)
	Switch[packet[Method],

		IndirectELISA|IndirectSandwichELISA|IndirectCompetitiveELISA,
		NotNullFieldTest[packet,{SecondaryAntibodies,SecondaryAntibodyStorageConditions}],

		FastELISA,
		NotNullFieldTest[packet,{CaptureAntibodies,CaptureAntibodyStorageConditions}]
	],
	(* Preread data and data file names *)
	If[And[MatchQ[packet[PrereadTimepoints],Except[(Null|{})]],MatchQ[packet[PrereadAbsorbanceWavelengths],Except[(Null|{})]]],
		RequiredWhenCompleted[packet,{PrereadDataFileNames,PrereadDataFiles,PrereadData}],
		NullFieldTest[packet,{PrereadDataFileNames,PrereadDataFiles,PrereadData}]
	],
	
	
	RequiredTogetherTest[packet,{Standards,StandardPrimaryAntibodies,StandardSubstrateSolutions,StandardSubstrateSolutionVolumes}],
	RequiredTogetherTest[packet,{Blanks,BlankPrimaryAntibodies,BlankSubstrateSolutions,BlankSubstrateSolutionVolumes}],
	RequiredTogetherTest[packet,{CoatingTime,CoatingWashVolume,CoatingNumberOfWashes}],
	RequiredTogetherTest[packet,{BlockingBuffer,BlockingVolumes,BlockingTime,BlockingTemperature,BlockingWashVolume,BlockingNumberOfWashes}],
	RequiredTogetherTest[packet,{StopSolutions,StopSolutionVolumes}],
	RequiredTogetherTest[packet,{PrereadTimepoints,PrereadAbsorbanceWavelengths}]

};

(* ::Subsection::Closed:: *)
(*Shared plate reader tests*)


validPlateReaderProtocolTests[packet:PacketP[{Object[Protocol,FluorescenceIntensity],Object[Protocol,FluorescenceKinetics],Object[Protocol,FluorescenceSpectroscopy],Object[Protocol,FluorescencePolarization],Object[Protocol,FluorescencePolarizationKinetics],Object[Protocol,LuminescenceIntensity],Object[Protocol,LuminescenceKinetics],Object[Protocol,LuminescenceSpectroscopy]}]]:={
	(* shared fields *)
	NullFieldTest[packet,{
		SamplesOut,
		ContainersOut,
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	(* unique fields *)
	Test["If the protocol is completed, the length of Data should be equal to the length of SamplesIn:",
		{Status,Length[DeleteCases[Lookup[packet,Data],Null]]},
		{Completed,Length[DeleteCases[Lookup[packet,SamplesIn],Null]]}|{Except[Completed],_}
	],

	NotNullFieldTest[packet,{
		(* unique fields *)
		Instrument,
		ReadLocation
	}],

	Test["SamplesIn and ContainersIn must be populated unless they are being prepared with the PreparatoryUnitOperations option:",
		If[MatchQ[Lookup[packet,PreparatoryUnitOperations],{}],
			MatchQ[Lookup[packet,{SamplesIn,ContainersIn}],{{ObjectP[]..},{ObjectP[]..}}],
			True
		],
		True
	],

	(* One or none can be filled out *)
	Test["Both FocalHeight and AutoFocalHeight are not populated:",
		Lookup[packet,{FocalHeight,AutoFocalHeight}],
		{Null,Null}|{Null,Except[Null]}|{Except[Null],Null}
	],

	RequiredTogetherTest[packet, {PrimaryInjections,PrimaryInjectionFlowRate,PrimaryFlushingSolvent,PrimaryPreppingSolvent}],
	RequiredTogetherTest[packet, {MoatBuffer,MoatSize,MoatVolume}],


	Test["If there is no mixing, no mixing parameters are set:",
		If[MatchQ[Lookup[packet,PlateReaderMix],False|Null],
			MatchQ[Lookup[packet,{
				PlateReaderMixMode,
				PlateReaderMixRate,
				PlateReaderMixTime
			}],NullP],
			True
		],
		True
	],

	RequiredTogetherTest[packet, {PlateReaderMixMode,PlateReaderMixRate,PlateReaderMixTime}],

	Test["If AutoFocalHeight is informed, AdjustmentSample is populated:",
		Lookup[packet,{AutoFocalHeight,AdjustmentSample}],
		{Except[NullP],Except[NullP]}|{NullP,_}
	]
};

(* ::Subsection::Closed:: *)
(*validProtocolCapillaryIsoelectricFocusingQTests*)

validProtocolCapillaryIsoelectricFocusingQTests[packet:PacketP[Object[Protocol,CapillaryIsoelectricFocusing]]]:={

	(* Shared field shaping - Not Null *)
	NotNullFieldTest[packet,{
		SamplesIn,
		ContainersIn
	}],

	(* Shared field - Null *)
	NullFieldTest[packet,{
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure,
		SamplesOut,
		ContainersOut
	}],

	(* Unique fields - Not Null *)
	NotNullFieldTest[packet,{
		Instrument,
		Cartridge,
		SampleTemperature,
		Anolyte,
		Catholyte,
		ElectroosmoticConditioningBuffer,
		FluorescenceCalibrationStandard,
		WashSolution,
		TotalVolumes,
		OnBoardMixing,
		LoadTimes,
		VoltageDurationProfiles,
		ImagingMethods
	}],

	RequiredWhenCompleted[packet,{
		MethodFilePath,
		MethodFileName,
		MethodFile,
		InjectionListFilePath,
		InjectionListFileName,
		InjectionListFile,
		DataFilePath,
		DataFileName,
		DataFile
	}],

	(* If PremadeMasterMixReagents informed, its diluent, dilution factor and volumes are also informed. if not, make sure that mastermix components are informed. This still allows for both mastermix AND components to be informed together so user can tweak mastermixes as they see fit. *)
	If[!NullQ[packet[PremadeMasterMixReagents]],
		RequiredTogetherTest[packet,{
			PremadeMasterMixDiluents,
			PremadeMasterMixReagentDilutionFactors,
			PremadeMasterMixVolumes
		}],
		NotNullFieldTest[packet,{
			Ampholytes,
			AmpholyteVolumes,
			IsoelectricPointMarkers,
			IsoelectricPointMarkersVolumes,
			ElectroosmoticFlowBlockers,
			ElectroosmoticFlowBlockerMarkersVolumes
		}]
	],

	(* if spacers, denaturation are informed, make sure volume is informed (require together) *)
	RequiredTogetherTest[packet,{
		DenaturationReagents,
		DenaturationReagentVolumes
	}],
	RequiredTogetherTest[packet,{
		AnodicSpacers,
		AnodicSpacerVolumes
	}],
	RequiredTogetherTest[packet,{
		CathodicSpacers,
		CathodicSpacerVolumes
	}],

	(* if standards are informed, require tests as above*)
	If[!MatchQ[packet[Standards],Null|{}],
		{
			If[!NullQ[packet[StandardPremadeMasterMixReagents]],
				RequiredTogetherTest[packet,{
					StandardPremadeMasterMixDiluents,
					StandardPremadeMasterMixReagentDilutionFactors,
					StandardPremadeMasterMixVolumes
				}],
				NotNullFieldTest[packet,{
					StandardAmpholytes,
					StandardAmpholyteVolumes,
					StandardIsoelectricPointMarkers,
					StandardIsoelectricPointMarkersVolumes,
					StandardElectroosmoticFlowBlockers,
					StandardElectroosmoticFlowBlockerMarkersVolumes
				}]
			],
			NotNullFieldTest[packet,{
				StandardLoadTimes,
				StandardVoltageDurationProfiles,
				StandardImagingMethods
			}],
			RequiredTogetherTest[packet,{
				StandardDenaturationReagents,
				StandardDenaturationReagentVolumes
			}],
			RequiredTogetherTest[packet,{
				StandardAnodicSpacers,
				StandardAnodicSpacerVolumes
			}],
			RequiredTogetherTest[packet,{
				StandardCathodicSpacers,
				StandardCathodicSpacerVolumes
			}]
		}],
	(* if blanks are informed, require tests as above *)
	If[!MatchQ[packet[Blanks],Null|{}],
		{
			If[!NullQ[packet[BlankPremadeMasterMixReagents]],
				RequiredTogetherTest[packet,{
					BlankPremadeMasterMixDiluents,
					BlankPremadeMasterMixReagentDilutionFactors,
					BlankPremadeMasterMixVolumes
				}],
				NotNullFieldTest[packet,{
					BlankAmpholytes,
					BlankAmpholyteVolumes,
					BlankIsoelectricPointMarkers,
					BlankIsoelectricPointMarkersVolumes,
					BlankElectroosmoticFlowBlockers,
					BlankElectroosmoticFlowBlockerMarkersVolumes
				}]
			],
			NotNullFieldTest[packet,{
				BlankLoadTimes,
				BlankVoltageDurationProfiles,
				BlankImagingMethods
			}],
			RequiredTogetherTest[packet,{
				BlankDenaturationReagents,
				BlankDenaturationReagentVolumes
			}],
			RequiredTogetherTest[packet,{
				BlankAnodicSpacers,
				BlankAnodicSpacerVolumes
			}],
			RequiredTogetherTest[packet,{
				BlankCathodicSpacers,
				BlankCathodicSpacerVolumes
			}]
		}]

};

(* ::Subsection::Closed:: *)
(*validProtocolFragmentAnalysisQTests*)

validProtocolFragmentAnalysisQTests[packet:PacketP[Object[Protocol,FragmentAnalysis]]]:={

	(* Shared field shaping - Not Null *)
	NotNullFieldTest[packet,{
		SamplesIn,
		ContainersIn
	}],

	(* Shared field - Null *)
	NullFieldTest[packet,{
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure,
		SamplesOut,
		ContainersOut
	}],

	(* Unique fields - Not Null *)
	NotNullFieldTest[packet,{
		Instrument,
		CapillaryArray,
		SampleRunningBuffers,
		SeparationGel,
		Dye,
		ConditioningSolution,
		AnalysisMethod,
		CapillaryEquilibration,
		PreMarkerRinse,
		MarkerInjection,
		PreSampleRinse,
		SampleInjectionTime,
		SampleInjectionVoltage,
		SeparationTime,
		SeparationVoltage
	}],

	RequiredWhenCompleted[packet,{
		SeparationMethodFilePath,
		SeparationFileName,
		RawDataFilePath,
		RawDataFileName,
		ProcessedDataDirectoryFilePath,
		ProcessedSizeDataDirectoryFilePath,
		ProcessedTimeDataDirectoryFilePath
	}],

	RequiredTogetherTest[packet,{
		SampleLoadingBuffers,
		SampleLoadingBufferVolumes
	}],

	(* if Ladders are informed, make sure associated fields are informed*)
	If[!MatchQ[packet[Ladders],Null|{}],
		{
			NotNullFieldTest[packet,{
				LadderRunningBuffers
			}],
			RequiredTogetherTest[packet,{
				LadderLoadingBuffers,
				LadderLoadingBufferVolumes
			}]
		}
	],

	(* if Blanks is informed, make sure associated fields are informed *)
	RequiredTogetherTest[packet,{
		Blanks,
		BlankRunningBuffers
	}],

	(* if PrimaryCapillaryFlushSolution is informed, make sure associated fields are informed *)
	RequiredTogetherTest[packet,{
		PrimaryCapillaryFlushSolution,
		PrimaryCapillaryFlushPressure,
		PrimaryCapillaryFlushFlowRate,
		PrimaryCapillaryFlushTime
	}],

	(* if SecodaryCapillaryFlushSolution is informed, make sure associated fields are informed *)
	RequiredTogetherTest[packet,{
		SecondaryCapillaryFlushSolution,
		SecondaryCapillaryFlushPressure,
		SecondaryCapillaryFlushFlowRate,
		SecondaryCapillaryFlushTime
	}],

	(* if TertiaryCapillaryFlushSolution is informed, make sure associated fields are informed *)
	RequiredTogetherTest[packet,{
		TertiaryCapillaryFlushSolution,
		TertiaryCapillaryFlushPressure,
		TertiaryCapillaryFlushFlowRate,
		TertiaryCapillaryFlushTime
	}],

	(* if Equilibration parameters are informed, make sure associated fields are informed *)
	RequiredTogetherTest[packet,{
		EquilibrationTime,
		EquilibrationVoltage
	}],

	(* if PreMarkerRinse parameters are informed, make sure associated fields are informed *)
	RequiredTogetherTest[packet,{
		NumberOfPreMarkerRinses,
		PreMarkerRinseBuffer
	}],

	(* if MarkerInjection parameters are informed, make sure associated fields are informed *)
	RequiredTogetherTest[packet,{
		MarkerInjectionTime,
		MarkerInjectionVoltage
	}],

	(* if PreSampleRinse parameters are informed, make sure associated fields are informed *)
	RequiredTogetherTest[packet,{
		NumberOfPreSampleRinses,
		PreSampleRinseBuffer
	}]


};

(* ::Subsection::Closed:: *)
(*validProtocolFlashFreezeQTests*)

validProtocolFlashFreezeQTests[packet:PacketP[Object[Protocol,FlashFreeze]]]:={

	(*Shared fields not null *)
	NotNullFieldTest[packet,{
		ContainersIn,
		SamplesIn,
		(* Fields specific to object *)
		Instrument,
		LiquidNitrogenDoser,
		LiquidNitrogenDoseTime,
		Tweezer,
		FlashFreezeLengths,
		FlashFreezeParameters
	}],

	(*Shared fields that should be Null*)
	NullFieldTest[packet,{
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	(* UPON COMPLETION *)
	RequiredWhenCompleted[packet,{
		SamplesIn,
		FreezingStartTimes,
		FreezingEndTimes,
		TotalFreezingTimes
	}]

};


(* ::Subsection::Closed:: *)
(*validProtocolDegasQTests*)

validProtocolDegasQTests[packet:PacketP[Object[Protocol,Degas]]]:={

	(*Shared fields not null *)
	NotNullFieldTest[packet,{
		ContainersIn,
		SamplesIn,
		(* Fields specific to object *)
		Instrument,
		DegasType,
		SchlenkLine,
		SchlenkAdapter,
		BatchLengths,
		BatchedSampleLengths,
		BatchedContainerIndexes,
		BatchedSampleIndexes,
		BatchedDegasParameters
	}],

	RequiredWhenCompleted[packet,{
		BatchedContainers,
		BatchedSamples
	}],

	RequiredTogetherTest[packet,{
		Dewar,
		LiquidNitrogenDoser,
		HeatBlock,
		Septum,
		FreezePumpThawContainer
	}],

	RequiredTogetherTest[packet,{
		VacuumUntilBubbleless,
		MaxVacuumTime
	}],

	RequiredTogetherTest[packet,{
		Mixer,
		Impeller,
		ImpellerGuide
	}],

	Test[
		"If any samples are undergoing degas on a FreezePumpThawApparatus, the following fields must not be Null at those sample indexes {FreezeTime, PumpTime, ThawTime,ThawTemperature,NumberOfCycles}:",
		Module[{fptIndexes},
			fptIndexes = Position[Lookup[packet,DegasType],FreezePumpThaw];
			Extract[Lookup[packet,#],fptIndexes]&/@{
				FreezeTime,
				PumpTime,
				ThawTime,
				ThawTemperature,
				NumberOfCycles
			}
		],
		{}|{Repeated[Except[Null]]}
	],
	Test[
		"If any samples are undergoing degas on a SpargingApparatus, the following fields must not be Null at those sample indexes {SpargingGas,SpargingTime}:",
		Module[{fptIndexes},
			fptIndexes = Position[Lookup[packet,DegasType],Sparging];
			Extract[Lookup[packet,#],fptIndexes]&/@{
				SpargingGas,
				SpargingTime
			}
		],
		{}|{Repeated[Except[Null]]}
	],
	Test[
		"If any samples are undergoing degas on a VacuumDegasser, the following fields must not be Null at those sample indexes {VacuumTime, VacuumPressure, VacuumSonicate}:",
		Module[{fptIndexes},
			fptIndexes = Position[Lookup[packet,DegasType],VacuumDegas];
			Extract[Lookup[packet,#],fptIndexes]&/@{
				VacuumTime,
				VacuumPressure,
				VacuumSonicate
			}
		],
		{}|{Repeated[Except[Null]]}
	]
};


(* ::Subsection::Closed:: *)
(*validProtocolDesiccateQTests*)


validProtocolDesiccateQTests[packet:PacketP[Object[Protocol,Desiccate]]]:={

	(* shared fields not null *)
	NotNullFieldTest[packet,
		{
			SamplesIn,
			ContainersIn,
			ContainersOut,
			Amount,
			Desiccant,
			Desiccator,
			Time,
			ContainerOut,
			SamplesOutStorageConditions
		}
	],

	NullFieldTest[packet,{
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],


	(*Required when completed*)

	Test["If the protocol is completed, PressureLog must be informed if Method is set to Vacuum or DesiccantUnderVacuum and SampleType is set to Open:",
		If[
			And[
				MatchQ[Lookup[packet,Status],Completed],
				MatchQ[Lookup[packet,Method], Or[Vacuum, DesiccantUnderVacuum]],
				MatchQ[Lookup[packet, SampleType], Open]
			],
			!MatchQ[Lookup[packet,PressureLog],NullP|{}],
			True
		],
		True
	],


	Test["If the protocol is completed, DesiccationVideo must be informed if SampleType is Open:",
		If[
			And[
				MatchQ[Lookup[packet,Status],Completed],
				MatchQ[Lookup[packet,SampleType], Open]
			],
			!MatchQ[Lookup[packet,DesiccationVideo],NullP|{}],
			True
		],
		True
	]

};



(* ::Subsection::Closed:: *)


(*validProtocolCapillaryGelElectrophoresisSDSQTests*)

validProtocolCapillaryGelElectrophoresisSDSQTests[packet:PacketP[Object[Protocol,CapillaryGelElectrophoresisSDS]]]:={

	(* Shared field shaping - Not Null *)
	NotNullFieldTest[packet,{
		SamplesIn,
		ContainersIn
	}],

	(* Shared field - Null *)
	NullFieldTest[packet,{
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure,
		SamplesOut,
		ContainersOut
	}],

	(* Unique fields - Not Null *)
	NotNullFieldTest[packet,{
		Instrument,
		Cartridge,
		SampleTemperature,
		ConditioningAcid,
		ConditioningBase,
		ConditioningWashSolution,
		SeperationMatrix,
		SystemWashSolution,
		TotalVolumes,
		InternalReferences,
		InternalReferenceVolumes,
		RunningBuffer,
		InjectionVoltageDurationProfiles,
		SeparationVoltageDurationProfiles,
		Diluents
	}],

	RequiredWhenCompleted[packet,{
		MethodFilePath,
		MethodFileName,
		MethodFile,
		InjectionListFilePath,
		InjectionListFileName,
		InjectionListFile,
		DataFilePath,
		DataFileName,
		DataFile
			(* add primitives *)
	}],

	(* Either ConcentratedSDSBuffers or SDSBuffers must be informed, along with their associated volumes *)
	AnyInformedTest[packet,{
		ConcentratedSDSBuffers,
		SDSBuffers
	}],

	If[!NullQ[packet[ConcentratedSDSBuffers]],
		RequiredTogetherTest[packet,{
			ConcentratedSDSBuffers,
			ConcentratedSDSBufferVolumes
		}],
		RequiredTogetherTest[packet,{
			SDSBuffers,
			SDSBufferVolumes
		}]
	],
	(* If Using premade mix *)
	RequiredTogetherTest[packet,{
		PremadeMasterMixReagents,
		PremadeMasterMixDiluents,
		PremadeMasterMixVolumes
	}],

	(* if reduction, alkylation, denaturation, centrifugation are informed, make sure associated fields are informed *)
	RequiredTogetherTest[packet,{
		ReducingAgents,
		ReducingAgentVolumes
	}],
	RequiredTogetherTest[packet,{
		AlkylatingAgents,
		AlkylatingAgentVolumes
	}],
	RequiredTogetherTest[packet,{
		DenaturingTemperatures,
		DenaturingTimes,
		CoolingTemperatures,
		CoolingTimes
	}],
	RequiredTogetherTest[packet,{
		SedimentationCentrifugationForce,
		SedimentationCentrifugationTimes,
		SedimentationCentrifugationTemperatures,
		SedimentationSupernatantVolumes
	}],

	(* if Ladders are informed, require tests as above*)
	If[!MatchQ[packet[Ladders],Null|{}],
		{
			RequiredTogetherTest[packet,{
				LadderAnalyteMolecularWeights,
				LadderTotalVolumes,
				LadderDiluents,
				LadderVolumes
			}]
		}],

	(* if standards are informed, require tests as above*)
	If[!MatchQ[packet[Standards],Null|{}],
		{
			AnyInformedTest[packet,{
				StandardConcentratedSDSBuffers,
				StandardSDSBuffers
			}],
			If[!NullQ[packet[StandardConcentratedSDSBuffers]],
				RequiredTogetherTest[packet,{
					StandardConcentratedSDSBuffers,
					StandardConcentratedSDSBufferVolumes
				}],
				RequiredTogetherTest[packet,{
					StandardSDSBuffers,
					StandardSDSBufferVolumes,
					StandardDiluents
				}]
			],
			RequiredTogetherTest[packet,{
				StandardReducingAgents,
				StandardReducingAgentVolumes
			}],
			RequiredTogetherTest[packet,{
				StandardAlkylatingAgents,
				StandardAlkylatingAgentVolumes
			}],
			RequiredTogetherTest[packet,{
				StandardDenaturingTemperatures,
				StandardDenaturingTimes,
				StandardCoolingTemperatures,
				StandardCoolingTimes
			}],
			RequiredTogetherTest[packet,{
				StandardSedimentationCentrifugationForce,
				StandardSedimentationCentrifugationTimes,
				StandardSedimentationCentrifugationTemperatures,
				StandardSedimentationSupernatantVolumes
			}],
			NotNullFieldTest[packet,{
				StandardTotalVolumes,
				StandardInternalReferences,
				StandardInternalReferenceVolumes,
				StandardRunningBuffer,
				StandardInjectionVoltageDurationProfiles,
				StandardSeparationVoltageDurationProfiles
			}],
			RequiredTogetherTest[packet,{
				StandardPremadeMasterMixReagents,
				StandardPremadeMasterMixDiluents,
				StandardPremadeMasterMixVolumes
			}]
		}],
	(* if blanks are informed, require tests as above *)
	If[!MatchQ[packet[Blanks],Null|{}],
		{
			AnyInformedTest[packet,{
				BlankConcentratedSDSBuffers,
				BlankSDSBuffers
			}],
			If[!NullQ[packet[StandardConcentratedSDSBuffers]],
				RequiredTogetherTest[packet,{
					BlankConcentratedSDSBuffers,
					BlankConcentratedSDSBufferVolumes
				}],
				RequiredTogetherTest[packet,{
					BlankSDSBuffers,
					BlankSDSBufferVolumes,
					BlankDiluents
				}]
			],
			RequiredTogetherTest[packet,{
				BlankReducingAgents,
				BlankReducingAgentVolumes
			}],
			RequiredTogetherTest[packet,{
				BlankAlkylatingAgents,
				BlankAlkylatingAgentVolumes
			}],
			RequiredTogetherTest[packet,{
				BlankDenaturingTemperatures,
				BlankDenaturingTimes,
				BlankCoolingTemperatures,
				BlankCoolingTimes
			}],
			RequiredTogetherTest[packet,{
				BlankSedimentationCentrifugationForce,
				BlankSedimentationCentrifugationTimes,
				BlankSedimentationCentrifugationTemperatures,
				BlankSedimentationSupernatantVolumes
			}],
			NotNullFieldTest[packet,{
				BlankTotalVolumes,
				BlankInternalReferences,
				BlankInternalReferenceVolumes,
				BlankRunningBuffer,
				BlankInjectionVoltageDurationProfiles,
				BlankSeparationVoltageDurationProfiles
			}],
			RequiredTogetherTest[packet,{
				BlankPremadeMasterMixReagents,
				BlankPremadeMasterMixDiluents,
				BlankPremadeMasterMixVolumes
			}]
		}]
};
(* ::Subsection::Closed:: *)

(* ::Subsection::Closed:: *)
(*validProtocolMeasureOsmolalityQTests*)

validProtocolMeasureOsmolalityQTests[packet:PacketP[Object[Protocol,MeasureOsmolality]]]:={

	(*Fields not null *)
	NotNullFieldTest[packet,{
		ContainersIn,
		SamplesIn,
		(* Fields specific to object *)
		Instrument,
		OsmolalityMethod,
		SampleVolumes,
		NumberOfReadings,
		CleaningSolution,
		Calibrants,
		CalibrantOsmolalities,
		CalibrantVolume,
		CalibrantStorage,
		CalibrantPipettes,
		CalibrantPipetteTips,
		CalibrantInoculationPapers,
		InstrumentModes,
		MeasurementTimes,
		MaxNumberOfCalibrations
	}],

	(*Shared fields that should be Null*)
	NullFieldTest[packet,{
		ContainersOut,
		SamplesOut,
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	(*If pipette specified, it also requires the pipette tips*)
	RequiredTogetherTest[packet,{
		Pipettes,
		PipetteTips
	}],

	RequiredTogetherTest[packet,{
		CalibrantPipettes,
		CalibrantPipetteTips
	}],

	RequiredTogetherTest[packet,{
		ControlPipettes,
		ControlPipetteTips
	}],

	(*Require all the following for calibration*)
	RequiredTogetherTest[packet,{
		Calibrants,
		CalibrantOsmolalities,
		CalibrantVolume,
		CalibrantTweezers,
		CalibrantInoculationPapers,
		CalibrantPipettes,
		CalibrantPipetteTips,
		CalibrantTolerances
	}],

	(*Require all the following for a control check*)
	RequiredTogetherTest[packet,{
		Controls,
		ControlOsmolalities,
		ControlVolumes
	}],

	(* Equilibration times must only be informed by one field*)
	Test["For each member of SamplesIn, EquilibrationTimes and InternalDefaultEquilibrationTimes are uniquely informed:",
		Transpose[Lookup[packet,{EquilibrationTimes,InternalDefaultEquilibrationTimes}]],
		{Alternatives[{Null,True},{Except[Null],False}]..}
	],

	(* Vapro 5600 specific limitations *)
	(* If instrument is the Vapro 5600, InstrumentModes must be informed *)
	Test["If the instrument is the Vapro 5600, Instrument Modes must be informed:",
		Module[{instrument,modes},
			{instrument,modes}=Lookup[packet,{Instrument,InstrumentModes}];
			If[MatchQ[instrument,ObjectP[Object[Instrument,Osmometer]]],{instrument[Model],modes},{instrument,modes}]
		],
		Alternatives[
			{ObjectP[Model[Instrument,Osmometer,"Vapro 5600"]],{Alternatives[Normal,ProcessDelay,AutoRepeat]..}},
			{Except[ObjectP[Model[Instrument,Osmometer,"Vapro 5600"]]],_}
		]
	],

	(* Make sure the measurement mode is compatible with the equilibration times *)
	Test["For each member of SamplesIn, EquilibrationTimes are compatible with the InstrumentMode:",
		Transpose[Lookup[packet,{EquilibrationTimes,InternalDefaultEquilibrationTimes,InstrumentModes}]],
		{Alternatives[{Null,True,Alternatives[Normal,AutoRepeat]},{Except[Null],False,ProcessDelay}]..}
	],

	(* Make sure the number of readings is compatible with the measurement mode *)
	Test["For each member of SamplesIn, the number of readings are compatible with the InstrumentMode:",
		Transpose[Lookup[packet,{NumberOfReadings,InstrumentModes}]],
		{Alternatives[{1,Normal},{_,ProcessDelay},{10,AutoRepeat}]..}
	],


	(* UPON COMPLETION *)
	RequiredWhenCompleted[packet,{
		SamplesIn,
		Data,
		DataFiles,
		RawDataFiles,
		DataFilePath,
		FileNames
	}]

};

(* ::Subsection::Closed:: *)
(*validProtocolCircularDichroismQTests*)

validProtocolCircularDichroismQTests[packet:PacketP[Object[Protocol,CircularDichroism]]]:={

	(*Fields not null *)
	NotNullFieldTest[packet,{
		ContainersIn,
		SamplesIn,
		Instrument,
		PreparedPlate,
		Instrument,
		ReadPlate,
		SampleVolumes,
		ReadDirection,
		RetainCover,
		AverageTime,
		SamplesInWells,
		NitrogenPurge,
		EstimatedProcessingTime
	}],


	(* Min and max wavelengths are required together *)
	RequiredTogetherTest[packet,{
		MinWavelengths,
		MaxWavelengths
	}],

	(*Shared fields that should be Null*)
	NullFieldTest[packet,{
		NitrogenPressureLog,
		CO2PressureLog,
		ArgonPressureLog,
		InitialNitrogenPressure,
		InitialArgonPressure,
		InitialCO2Pressure
	}],

	RequiredTogetherTest[packet,{
		MinWavelengths,
		MaxWavelengths
	}],

	RequiredTogetherTest[packet, {MoatBuffer,MoatVolume}],

	RequiredTogetherTest[packet, {Blank,BlankVolume,UniqueBlankVolumes,	BlankWells}],

	If[Lookup[packet,EnantiomericExcessMeasurement],
		NotNullFieldTest[packet,{EnantiomericExcessWavelengths,EnantiomericExcessStandards,EnantiomericExcessStandardValues,EnantiomericExcessStandardWells}],
		Nothing
	],

	If[Lookup[packet,EnantiomericExcessMeasurement],
		RequiredWhenCompleted[packet,{EnantiomericExcessStandardTable}],
		Nothing
	],

	(* UPON COMPLETION *)
	RequiredWhenCompleted[packet,{
		SamplesIn,
		SamplesOut,
		Data,
		If[Length[Lookup[packet,BlankWells]]>0,BlankData,Nothing],
		If[Length[Lookup[packet,EmptyWells]]>0,EmptyData,Nothing],
		MethodFileName,
		MethodFile,
		ExportScriptFilePath,
		ImportScriptFilePath
	}]

};


(* ::Subsection::Closed:: *)
(*validProtocolCountLiquidParticlesQTests*)

validProtocolCountLiquidParticlesQTests[packet:PacketP[Object[Protocol,CountLiquidParticles]]]:={
	
	(*Fields not null *)
	NotNullFieldTest[packet,{
		ContainersIn,
		SamplesIn,
		Instrument,
		PreparedPlate,
		Instrument,
		Methods,
		ParticleSizes,
		SyringeSize,
		Instrument,
		Sensor,
		Syringe,
		PrimeSolutions,
		PrimeSolutionTemperatures,
		NumberOfPrimes,
		PrimeIndexes,
		ReadingVolumes,
		SampleTemperatures,
		NumberOfReadings,
		DiscardFirstRuns,
		WashSolutions,
		WashSolutionTemperatures,
		NumberOfWashes,
		WashIndexes,
		RinsingSolution,
		FillLiquid
	}],
	
	RequiredTogetherTest[packet,{
		PreRinseVolumes,
		PreRinseVolumeStrings
	}],
	
	RequiredTogetherTest[packet,{
		AcquisitionMixes,
		StirBars,
		AcquisitionMixRates
	}],
	RequiredTogetherTest[packet,{
		AdjustMixRates,
		MinAcquisitionMixRates,
		MaxAcquisitionMixRates,
		AcquisitionMixRateIncrements,
		MaxStirAttempts
	}],
	
	
	If[Or[MatchQ[Lookup[packet,Dilutions],Except[Null|{}]],MatchQ[Lookup[packet,SerialDilutions],Except[Null|{}]]],
		NotNullFieldTest[packet,{Diluents,SampleLoadingVolumes,DilutionContainers,DilutionContainerResouces,DilutionMixVolumes,DilutionNumberOfMixes,DilutionMixRates,DilutionStorageConditions}],
		Nothing
	],
	
	(* UPON COMPLETION *)
	RequiredWhenCompleted[packet,{
		SamplesIn,
		Data,
		PrimeSolutionsContainerPlacements,
		WashSolutionRackPlacements,
		WashSolutionContainerPlacements,
		RinsingSolutionRackPlacements,
		RinsingSolutionContainerPlacements,
		ProbeStorageContainerPlacements,
		SyringePlacements,
		SampleQueueNames,
		MethodFileNames,
		ExportScriptFilePath,
		ImportScriptFilePath
	}]
	
};


(* ::Subsection::Closed:: *)
(*validProtocolDynamicFoamAnalysisQTests*)

validProtocolDynamicFoamAnalysisQTests[packet:PacketP[Object[Protocol,DynamicFoamAnalysis]]]:={

	(*Shared fields not null *)
	NotNullFieldTest[packet,{
		ContainersIn,
		SamplesIn,
		(* Fields specific to object *)
		Instrument,
		Temperature,
		DetectionMethod,
		TemperatureMonitoring,
		FoamColumn,
		Agitation,
		AgitationTime,
		DecayTime,
		DecaySamplingFrequency,
		Wavelength,
		HeightIlluminationIntensity,
		NumberOfWashes,
		FoamAgitationModule
	}],

	RequiredTogetherTest[packet,{
		CameraHeight,
		StructureIlluminationIntensity,
		FieldOfView
	}],

	RequiredTogetherTest[packet,{
		SpargeFilter,
		SpargeGas,
		SpargeFlowRate
	}],

	(* check for the sparge filter cleaner only if sparge gas is not a list of Nulls*)
	If[MatchQ[Lookup[packet,SpargeGas],{Null...}],
		NullFieldTest[packet,SpargeFilterCleaner],
		Nothing
	],

	RequiredTogetherTest[packet,{
		StirBlade,
		StirRate,
		StirOscillationPeriod
	}]
};




(* ::Subsection::Closed:: *)
(*validProtocolICPMSQTests*)
validProtocolICPMSQTests[packet:PacketP[Object[Protocol,ICPMS]]] := {
	NotNullFieldTest[packet, {
		ContainersIn,
		SamplesIn,
		Instrument,
		Digestion,
		StandardType,
		Blank,
		Rinse,
		InjectionDuration,
		WarmUpTime,
		Elements,
		QuantifyConcentration,
		InternalStandardElement,
		NominalPlasmaPower,
		CollisionCellPressurization,
		CollisionCellGasFlowRate,
		CollisionCellBias,
		ConeDiameter,
		Cone,
		DwellTime,
		NumberOfReads,
		ReadSpacing,
		Bandpass,
		TuningStandard
	}],

	If[MatchQ[Lookup[packet, StandardType], External],
		NotNullFieldTest[packet, {ExternalStandard, ExternalStandardElements}],
		Nothing
	],

	If[MatchQ[Lookup[packet, StandardType], StandardAddition],
		NotNullFieldTest[packet, {StandardSpikedSamples, StandardAdditionElements}],
		Nothing
	],

	If[MatchQ[Lookup[packet, StandardType], StandardAddition],
		NullFieldTest[packet, {ExternalStandard, ExternalStandardElements}],
		Nothing
	],

	If[MatchQ[Lookup[packet, StandardType], External],
		NullFieldTest[packet, {StandardSpikedSamples, StandardAdditionElements}],
		Nothing
	]
};


(* ::Subsection:: *)
(*Test Registration *)


registerValidQTestFunction[Object[Protocol],validProtocolQTests];
registerValidQTestFunction[Object[Protocol, AbsorbanceQuantification],validProtocolAbsorbanceQuantificationQTests];
registerValidQTestFunction[Object[Protocol, AbsorbanceIntensity],validProtocolAbsorbanceIntensityQTests];
registerValidQTestFunction[Object[Protocol, AbsorbanceKinetics],validProtocolAbsorbanceKineticsQTests];
registerValidQTestFunction[Object[Protocol, AbsorbanceSpectroscopy],validProtocolAbsorbanceSpectroscopyQTests];
registerValidQTestFunction[Object[Protocol, AcousticLiquidHandling],validProtocolAcousticLiquidHandlingQTests];
registerValidQTestFunction[Object[Protocol, Bioconjugation],validProtocolBioconjugationQTests];
registerValidQTestFunction[Object[Protocol, AdjustpH],validProtocolAdjustpHQTests];
registerValidQTestFunction[Object[Protocol, UVMelting],validProtocolUVMeltingQTests];
registerValidQTestFunction[Object[Protocol, AgaroseGelElectrophoresis],validProtocolAgaroseGelElectrophoresisQTests];
registerValidQTestFunction[Object[Protocol, Autoclave],validProtocolAutoclaveQTests];
registerValidQTestFunction[Object[Protocol, AlphaScreen],validProtocolAlphaScreenQTests];
registerValidQTestFunction[Object[Protocol, Bioconjugation],validProtocolBioconjugationQTests];
registerValidQTestFunction[Object[Protocol, BioLayerInterferometry], validProtocolBioLayerInterferometryQTests];
registerValidQTestFunction[Object[Protocol, CapillaryIsoelectricFocusing],validProtocolCapillaryIsoelectricFocusingQTests];
registerValidQTestFunction[Object[Protocol, CapillaryGelElectrophoresisSDS],validProtocolCapillaryGelElectrophoresisSDSQTests];
registerValidQTestFunction[Object[Protocol, cDNAPrep],validProtocolcDNAPrepQTests];
registerValidQTestFunction[Object[Protocol, CellFreeze],validProtocolCellFreezeQTests];
registerValidQTestFunction[Object[Protocol, CellMediaChange],validProtocolCellMediaChangeQTests];
registerValidQTestFunction[Object[Protocol, CellSplit],validProtocolCellSplitQTests];
registerValidQTestFunction[Object[Protocol, Centrifuge],validProtocolCentrifugeQTests];
registerValidQTestFunction[Object[Protocol, CoulterCount],validProtocolCoulterCountQTests];
registerValidQTestFunction[Object[Protocol, COVID19Test],validProtocolCOVID19TestQTests];
registerValidQTestFunction[Object[Protocol, CrossFlowFiltration],validProtocolCrossFlowFiltrationQTests];
registerValidQTestFunction[Object[Protocol, CyclicVoltammetry],validProtocolCyclicVoltammetryQTests];
registerValidQTestFunction[Object[Protocol, Degas],validProtocolDegasQTests];
registerValidQTestFunction[Object[Protocol, Desiccate],validProtocolDesiccateQTests];
registerValidQTestFunction[Object[Protocol, Dialysis],validProtocolDialysisQTests];
registerValidQTestFunction[Object[Protocol, DifferentialScanningCalorimetry],validProtocolDifferentialScanningCalorimetryQTests];
registerValidQTestFunction[Object[Protocol, DNASynthesis],validProtocolDNASynthesisQTests];
registerValidQTestFunction[Object[Protocol, DNASequencing],validProtocolDNASequencingQTests];
registerValidQTestFunction[Object[Protocol, DynamicFoamAnalysis],validProtocolDynamicFoamAnalysisQTests];
registerValidQTestFunction[Object[Protocol, DynamicLightScattering],validProtocolDynamicLightScatteringQTests];
registerValidQTestFunction[Object[Protocol, LuminescenceIntensity],validProtocolLuminescenceIntensityQTests];
registerValidQTestFunction[Object[Protocol, LuminescenceKinetics],validProtocolLuminescenceIntensityQTests];
registerValidQTestFunction[Object[Protocol, LuminescenceSpectroscopy],validProtocolLuminescenceSpectroscopyQTests];
registerValidQTestFunction[Object[Protocol, ELISA],validProtocolELISAQTests];
registerValidQTestFunction[Object[Protocol, Filter],validProtocolFilterQTests];
registerValidQTestFunction[Object[Protocol, FlashFreeze],validProtocolFlashFreezeQTests];
registerValidQTestFunction[Object[Protocol, FlowCytometry],validProtocolFlowCytometryQTests];
registerValidQTestFunction[Object[Protocol, FluorescenceIntensity],validProtocolFluorescenceIntensityQTests];
registerValidQTestFunction[Object[Protocol, FluorescenceKinetics],validProtocolFluorescenceIntensityQTests];
registerValidQTestFunction[Object[Protocol, FluorescencePolarization],validProtocolFluorescenceIntensityQTests];
registerValidQTestFunction[Object[Protocol, FluorescencePolarizationKinetics],validProtocolFluorescenceIntensityQTests];
registerValidQTestFunction[Object[Protocol, FluorescenceSpectroscopy],validProtocolFluorescenceSpectroscopyQTests];
registerValidQTestFunction[Object[Protocol, FluorescenceThermodynamics],validProtocolFluorescenceThermodynamicsQTests];
registerValidQTestFunction[Object[Protocol, FPLC],validProtocolFPLCQTests];
registerValidQTestFunction[Object[Protocol, FreezeCells],validProtocolFreezeCellsQTests];
registerValidQTestFunction[Object[Protocol, FragmentAnalysis], validProtocolFragmentAnalysisQTests];
registerValidQTestFunction[Object[Protocol, FlashChromatography],validProtocolFlashChromatographyQTests];
registerValidQTestFunction[Object[Protocol, GasChromatography],validProtocolGasChromatographyQTests];
registerValidQTestFunction[Object[Protocol, Grind],validProtocolGrindQTests];
registerValidQTestFunction[Object[Protocol, HPLC],validProtocolHPLCQTests];
registerValidQTestFunction[Object[Protocol, ICPMS],validProtocolICPMSQTests];
registerValidQTestFunction[Object[Protocol, ImageSample],validProtocolImageSampleQTests];
registerValidQTestFunction[Object[Protocol, IncubateCells],validProtocolIncubateCellsQTests];
registerValidQTestFunction[Object[Protocol, IonChromatography],validProtocolIonChromatographyQTests];
registerValidQTestFunction[Object[Protocol, IRSpectroscopy],validProtocolIRSpectroscopyQTests];
registerValidQTestFunction[Object[Protocol, LCMS],validProtocolLCMSQTests];
registerValidQTestFunction[Object[Protocol, Lyophilize],validProtocolLyophilizeQTests];
registerValidQTestFunction[Object[Protocol, MagneticBeadSeparation],validProtocolMagneticBeadSeparationQTests];
registerValidQTestFunction[Object[Protocol, ManualSamplePreparation],validProtocolManualSamplePreparationQTests];
registerValidQTestFunction[Object[Protocol, MassSpectrometry],validProtocolMassSpectrometryQTests];
registerValidQTestFunction[Object[Protocol, MeasureConductivity],validProtocolMeasureConductivityQTests];
registerValidQTestFunction[Object[Protocol, MeasureContactAngle],validProtocolMeasureContactAngleQTests];
registerValidQTestFunction[Object[Protocol, MeasureCount],validProtocolMeasureCountQTests];
registerValidQTestFunction[Object[Protocol, MeasureDensity],validProtocolMeasureDensityQTests];
registerValidQTestFunction[Object[Protocol, MeasureDissolvedOxygen],validProtocolMeasureDissolvedOxygenQTests];
registerValidQTestFunction[Object[Protocol, MeasureMeltingPoint],validProtocolMeasureMeltingPointQTests];
registerValidQTestFunction[Object[Protocol, MeasureOsmolality],validProtocolMeasureOsmolalityQTests];
registerValidQTestFunction[Object[Protocol, MeasurepH],validProtocolMeasurepHQTests];
registerValidQTestFunction[Object[Protocol, MeasureRefractiveIndex],validProtocolMeasureRefractiveIndexQTests];
registerValidQTestFunction[Object[Protocol, MeasureSurfaceTension],validProtocolMeasureSurfaceTensionQTests];
registerValidQTestFunction[Object[Protocol, MeasureViscosity],validProtocolMeasureViscosityQTests];
registerValidQTestFunction[Object[Protocol, MeasureVolume],validProtocolMeasureVolumeQTests];
registerValidQTestFunction[Object[Protocol, MeasureWeight],validProtocolMeasureWeightQTests];
registerValidQTestFunction[Object[Protocol, Microscope],validProtocolMicroscopeQTests];
registerValidQTestFunction[Object[Protocol, MicrowaveDigestion],validProtocolMicrowaveDigestionQTests];
registerValidQTestFunction[Object[Protocol, MitochondrialIntegrityAssay],validProtocolMitochondrialIntegrityAssayQTests];
registerValidQTestFunction[Object[Protocol, Nephelometry],validProtocolNephelometryQTests];
registerValidQTestFunction[Object[Protocol, NephelometryKinetics],validProtocolNephelometryKineticsQTests];
registerValidQTestFunction[Object[Protocol, NMR],validProtocolNMRQTests];
registerValidQTestFunction[Object[Protocol, NMR2D],validProtocolNMR2DQTests];
registerValidQTestFunction[Object[Protocol, PAGE],validProtocolPAGEQTests];
registerValidQTestFunction[Object[Protocol, PCR],validProtocolPCRQTests];
registerValidQTestFunction[Object[Protocol, PNASynthesis],validProtocolPNASynthesisQTests];
registerValidQTestFunction[Object[Protocol, PrepareReferenceElectrode],validProtocolPrepareReferenceElectrodeQTests];
registerValidQTestFunction[Object[Protocol, PowderXRD],validProtocolPowderXRDQTests];
registerValidQTestFunction[Object[Protocol, ProteinPrep],validProtocolProteinPrepQTests];
registerValidQTestFunction[Object[Protocol, qPCR],validProtocolqPCRQTests];
registerValidQTestFunction[Object[Protocol, DigitalPCR],validProtocolDigitalPCRQTests];
registerValidQTestFunction[Object[Protocol, RamanSpectroscopy], validProtocolRamanSpectroscopyQTests];
registerValidQTestFunction[Object[Protocol, RNASynthesis],validProtocolRNASynthesisQTests];
registerValidQTestFunction[Object[Protocol, RoboticCOVID19Test], validProtocolRoboticCOVID19TestQTests];
registerValidQTestFunction[Object[Protocol, RoboticSamplePreparation], validProtocolRoboticSamplePreparationQTests];
registerValidQTestFunction[Object[Protocol, RoboticCellPreparation], validProtocolRoboticCellPreparationQTests];
registerValidQTestFunction[Object[Protocol, SampleManipulation],validProtocolSampleManipulationQTests];
registerValidQTestFunction[Object[Protocol, SampleManipulation,Aliquot],validProtocolSampleManipulationAliquotQTests];
registerValidQTestFunction[Object[Protocol, SampleManipulation,Dilute],validProtocolSampleManipulationDiluteQTests];
registerValidQTestFunction[Object[Protocol, SampleManipulation,Resuspend],validProtocolSampleManipulationResuspendQTests];
registerValidQTestFunction[Object[Protocol, SolidPhaseExtraction],validProtocolSolidPhaseExtractionQTests];
registerValidQTestFunction[Object[Protocol, StockSolution],validProtocolStockSolutionQTests];
registerValidQTestFunction[Object[Protocol, SupercriticalFluidChromatography],validProtocolSFCQTests];
registerValidQTestFunction[Object[Protocol, IncubateOld],validProtocolIncubateQTests];
registerValidQTestFunction[Object[Protocol, ThermalShift],validProtocolThermalShiftQTests];
registerValidQTestFunction[Object[Protocol, TotalProteinDetection],validProtocolTotalProteinDetectionQTests];
registerValidQTestFunction[Object[Protocol, TotalProteinQuantification],validProtocolTotalProteinQuantificationQTests];
registerValidQTestFunction[Object[Protocol, Transfection],validProtocolTransfectionQTests];
registerValidQTestFunction[Object[Protocol, Evaporate],validProtocolEvaporateQTests];
registerValidQTestFunction[Object[Protocol, Western],validProtocolWesternQTests];
registerValidQTestFunction[Object[Protocol, CapillaryELISA],validProtocolCapillaryELISAQTests];
registerValidQTestFunction[Object[Protocol, CircularDichroism],validProtocolCircularDichroismQTests];
registerValidQTestFunction[Object[Protocol, CountLiquidParticles],validProtocolCountLiquidParticlesQTests];

