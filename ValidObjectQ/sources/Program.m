(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*validProgramQTests*)


validProgramQTests[packet:ObjectP[Object[Program]]] := {

	(* big three test - conditional until protocols are made for all programs *)
	If[
		Or[
			MatchQ[Lookup[packet,Type],TypeP[{Object[Program, CellStaining], Object[Program, cDNAPrep]}]],
			MatchQ[Lookup[packet,FillToVolumeTransferType,Null],Placeholder]
		],
		{},
		UniquelyInformedTest[packet,{Protocol,Qualification,Maintenance}]
	],

	(* General fields filled in *)
	NotNullFieldTest[packet,{
		DateCreated
	}],


	(* dates *)
	Test["If DateCreated is informed, it is in the past:",
		Lookup[packet, DateCreated],
		Alternatives[
			Null,{},
			_?(#<=Now&)
		]
	]

};


(* ::Subsection:: *)
(*validProgramcDNAPrepQTests*)


validProgramcDNAPrepQTests[packet:PacketP[Object[Program,cDNAPrep]]]:={
(* Indiviudal Fields Tests *)


	NotNullFieldTest[packet,{
	(* Key parameters *)
		MediaVolume,
		WashVolume,
		NumberOfWashes,
		LysisSolutionVolume,
		LysisMixVolume,
		NumberOfLysisMixes,
		LysisTime,
		DNaseVolume,
		StopSolutionVolume,
		StopSolutionMixVolume,
		NumberOfStopMixes,
		StopTime,
	(* Key robot sequences*)
		LidLocations,
		SampleWells,
		RNAPlateStamps
	}],

(* cDNA information  *)
	RequiredTogetherTest[packet,{
		RTBufferVolume,
		RTEnzymeVolume,
		ReactionVolume,
		cDNAReagentVolumes,
		cDNAReagentLocations,
		cDNAReagentDestinations,
		cDNAMasterMixTransfers,
		cDNAWells,
		ReactionVolume,
		RNAVolumes,
		RNAWells
	}], (* cDNA master mix *)

(* instrument should be filled once the protocol is done *)
	Test[
		"Instrument is informed if the associated protocol, qualification or maintenance is completed:",
		{Download[DeleteCases[Lookup[packet,{Protocol,Qualification,Maintenance}],Null], Status], Lookup[packet,Instrument]},
		Alternatives[
			{Completed,Except[NullP]},
			{Except[Completed],_}
		]
	]
};


(* ::Subsection:: *)
(*validProgramCellMediaChangeQTests*)


validProgramCellMediaChangeQTests[packet:PacketP[Object[Program,CellMediaChange]]]:={
(* Indiviudal Fields Tests *)
	NotNullFieldTest[packet,{
	(* Key parameters *)
		MediaVolume,
		PlateFormat,
	(* Key robot sequences*)
		LidPositions,
		MediaWells
	}],

	(* instrument should be filled once the protocol is done *)
	Test[
		"Instrument is informed if the associated protocol, qualification or maintenance is completed:",
		{Download[DeleteCases[Lookup[packet,{Protocol,Qualification,Maintenance}],Null], Status], Lookup[packet,Instrument]},
		Alternatives[
			{Completed,Except[NullP]},
			{Except[Completed],_}
		]
	]
};


(* ::Subsection:: *)
(*validProgramCellSplitQTests*)


validProgramCellSplitQTests[packet:PacketP[Object[Program,CellSplit]]]:={
(* Indiviudal Fields Tests *)

	NotNullFieldTest[packet,{
	(* Key parameters *)
		CellType,
		PlateFormat,
		WashVolume,
		NumberOfWashes,
	(* Key robot sequences*)
		ContainersInLidLocations,
		ContainersOutLidLocations,
		CellTransfers
	}],

	(* All trypsinization parameters are required together *)
	RequiredTogetherTest[packet,{
		TrypsinVolume,
		InactivationVolume,
		TrypsinizationTime,
		TrypsinLocations
	}],

	Test[
		"If the cells are being bleached, all bleaching information is supplied:",
		If[
			MatchQ[Lookup[packet,Bleach],1],
			!NullQ[Lookup[packet,BleachVolume]] && !NullQ[Lookup[packet,AspirationVolume]] && !NullQ[Lookup[packet,BleachTime]],
			True
		],
		True
	],

(* instrument should be filled once the protocol is done *)
	Test[
		"Instrument is informed if the associated protocol, qualification or maintenance is completed:",
		{Download[DeleteCases[Lookup[packet,{Protocol,Qualification,Maintenance}],Null], Status], Lookup[packet,Instrument]},
		Alternatives[
			{Completed,Except[NullP]},
			{Except[Completed],_}
		]
	]

};


(* ::Subsection:: *)
(*validProgramCellStainingQTests*)


validProgramCellStainingQTests[packet:PacketP[Object[Program,CellStaining]]]:={
(* Indiviudal Fields Tests *)

	NotNullFieldTest[packet,{
	(* Key parameters *)
		PlateFormat,
	(* Key robot sequences*)
		LidPositions,
		StainingWells,
		StainPosition,
		StainTransfers
	}],

(* instrument should be filled once the protocol is done *)
	Test[
		"Instrument is informed if the associated protocol, qualification or maintenance is completed:",
		{Download[DeleteCases[Lookup[packet,{Protocol,Qualification,Maintenance}],Null], Status], Lookup[packet,Instrument]},
		Alternatives[
			{Completed,Except[NullP]},
			{Except[Completed],_}
		]
	]
};



(* ::Subsection::Closed:: *)
(*validProgramCleavageQTests*)


validProgramCleavageQTests[packet:PacketP[Object[Program,Cleavage]]]:={

	NotNullFieldTest[packet, {
		CleavageSolution,
		CleavageSolutionVolume,
		CleavageTime,
		CleavageTemperature,
		CleavedStrands
	}]

};



(* ::Subsection:: *)
(*validProgramMitochondrialIntegrityAssayQTests*)


validProgramMitochondrialIntegrityAssayQTests[packet:PacketP[Object[Program,MitochondrialIntegrityAssay]]]:={
(* Indiviudal Fields Tests *)

	NotNullFieldTest[packet,{
	(* Key parameters *)
		CellType,
		StainingTime,
		StainingTemperature,
	(* Key robot sequences*)
		NumberOfWells,
		PlateLidLocations,
		ReactionBufferLocation,
		WellsToMix
	}],


	(* Tip: If specified, required together.. else all can be null *)
	RequiredTogetherTest[packet, {
		TipLoad,
		TipUnload,
		TipLocation,
		TipAdapterLocation
	}],

(* If the volumes to be transfered are informed, associated transfers/repetitions must be informed *)
	RequiredTogetherTest[packet,{
		MitochondrialDetectorVolume,
		MitochondrialDetectorLocation
	}],
	RequiredTogetherTest[packet,{
		FilterVolume,
		NumberOfFilterings
	}],
	RequiredTogetherTest[packet,{
		FiltrationWells,
		ResuspensionWells,
		CellSourcePositions,
		ReadWells
	}],
	RequiredTogetherTest[packet,{
		WashVolume,
		NumberOfReactionWashes
	}],
	RequiredTogetherTest[packet,{
		BufferVolume,
		NumberOfBufferWashes
	}],

(* Sensible Volume Transfers *)
	FieldComparisonTest[packet,{TrypsinizedVolume,FilterVolume},GreaterEqual],
	FieldComparisonTest[packet,{FilterVolume,ResuspensionVolume}, GreaterEqual],

(* instrument should be filled once the protocol is done *)
	Test[
		"Instrument is informed if the associated protocol, qualification or maintenance is completed:",
		{Download[DeleteCases[Lookup[packet,{Protocol,Qualification,Maintenance}],Null], Status], Lookup[packet,Instrument]},
		Alternatives[
			{Completed,Except[NullP]},
			{Except[Completed],_}
		]
	]

};


(* ::Subsection:: *)
(*validProgramFluorescenceThermodynamicsQTests*)


validProgramFluorescenceThermodynamicsQTests[packet:PacketP[Object[Program,FluorescenceThermodynamics]]]:={
(* Required fields *)
	NotNullFieldTest[packet,{
		Aliquots,
		SampleLocations,
		MixingLocations,
		DilutionVolumes
	}],

(* instrument should be filled once the protocol is done *)
	Test[
		"Instrument is informed if the associated protocol, qualification or maintenance is completed:",
		{Download[DeleteCases[Lookup[packet,{Protocol,Qualification,Maintenance}],Null], Status], Lookup[packet,Instrument]},
		Alternatives[
			{Completed,Except[NullP]},
			{Except[Completed],_}
		]
	]
};



(* ::Subsection::Closed:: *)
(*validProgramMeasureVolumeQTests*)


validProgramMeasureVolumeQTests[packet:PacketP[Object[Program,MeasureVolume]]]:={

	NotNullFieldTest[packet,
		{
			ContainersIn,
			SamplesIn,
			Protocol,
			LiquidLevelDetector,
			DateCreated
		}
	],

	Test["If SensorArmHeight is Null, TubeRack and TubeRackPlacements are required together:",
		Lookup[packet,{SensorArmHeight,TubeRack,TubeRackPlacements}],
		{Except[Null],_,_}|{Null,Null,{}}|{Null,Except[Null],Except[{}]}
	],

	Test["If SensorArmHeight is filled out, PlateLayoutFileName and DataFileNames are empty:",
		Lookup[packet,{SensorArmHeight,PlateLayoutFileName,DataFileNames}],
		{Except[Null],Null,{}}|{Null,_,_}
	],

	Test["If SensorArmHeight is filled out, TareDistance is filled out if the Protocol is completed:",
		{Download[packet,Protocol[Status]],Lookup[packet,{SensorArmHeight,TareDistance}]},
		{Completed,{Except[Null],Except[Null]}|{Null,Null}}|{_,{_,_}}
	],

	Test["PlatePlatform is only filled out if SensorArmHeight is Null:",
		Lookup[packet,{SensorArmHeight,PlatePlatform}],
		{Except[Null],Null}|{Null,_}
	]

};



(* ::Subsection::Closed:: *)
(*validProgramMeasureWeightQTests*)


validProgramMeasureWeightQTests[packet:PacketP[Object[Program,MeasureWeight]]]:={

	NotNullFieldTest[packet, {
	(* shared fields not null *)
		ContainerIn,
	(* unique fields not null *)
		NumberOfWeighings,
		CalibrateContainer
	}],

(* check only if status of Protocol is completed *)
	RequiredWhenCompleted[packet,{
		Balance,
		BalanceType,
		Weight,
		WeightData,
		WeightStandardDeviation,
		WeightDistribution
	}],

	(* Required together tests. *)
	RequiredTogetherTest[packet,{Pipette, PipetteTips}],

	If[
		MatchQ[Download[Lookup[packet,Protocol], Status], Completed],
		{
			RequiredTogetherTest[packet,{ScoutBalance, ScoutData}],
			RequiredTogetherTest[packet,{TransferContainer, TareData}],
			RequiredTogetherTest[packet,{WeighBoat, ResidueWeightData}]
		},
		{}
	]
};



(* ::Subsection:: *)
(*validProgramMix*)


validProgramMixQTests[packet:PacketP[Object[Program,Mix]]]:={
(*No shaped field tests necessary*)

(*Specific field tests*)
	NotNullFieldTest[packet, {
		ContainerBatch,
		MixingType,
		MixingTime,
		MixingRate
	}],

(* instrument should be filled once the protocol is done *)
	Test[
		"Instrument is informed if the associated protocol, qualification or maintenance is completed:",
		{Download[DeleteCases[Lookup[packet,{Protocol,Qualification,Maintenance}],Null], Status], Lookup[packet,Instrument]},
		Alternatives[
			{Completed,Except[NullP]},
			{Except[Completed],_}
		]
	]

};



(* ::Subsection:: *)
(*validProgramPAGEQTests*)


validProgramPAGEQTests[packet:PacketP[Object[Program,PAGE]]]:={

(* instrument should be filled once the protocol is done *)
	Test[
		"Instrument is informed if the associated protocol, qualification or maintenance is completed:",
		{Download[DeleteCases[Lookup[packet,{Protocol,Qualification,Maintenance}],Null], Status], Lookup[packet,Instrument]},
		Alternatives[
			{Completed,Except[NullP]},
			{Except[Completed],_}
		]
	]
};



(* ::Subsection:: *)
(*validProgramPipettingLinearityQTests*)


validProgramPipettingLinearityQTests[packet:PacketP[Object[Program,PipettingLinearity]]]:={
(* not null *)
	NotNullFieldTest[packet,{
		Source,
		Destination,
		Volume
	}],

(* instrument should be filled once the protocol is done *)
	Test[
		"Instrument is informed if the associated protocol, qualification or maintenance is completed:",
		{Download[DeleteCases[Lookup[packet,{Protocol,Qualification,Maintenance}],Null], Status], Lookup[packet,Instrument]},
		Alternatives[
			{Completed,Except[NullP]},
			{Except[Completed],_}
		]
	]
};



(* ::Subsection:: *)
(*validProgramProcedureEventQTests*)


validProgramProcedureEventQTests[packet:PacketP[Object[Program,ProcedureEvent]]]:={
(* Shared Field Shaping *)
	NullFieldTest[packet,{
		Instrument
	}],

(* Always required *)
	NotNullFieldTest[packet,{
		DateCreated,
		EventType,
		ProtocolStatus
	}],

	Test["The fields associated with the event type are informed:",
		Lookup[packet,{EventType,BranchObjects,ErrorMessage,CheckpointName,TaskJSON,LegacySessionZipFile,SessionZipFile}],
		Alternatives[
			{Branch,{LinkP[{Object[Protocol], Object[Qualification], Object[Maintenance]}]..},Null,Null,Null,Null,Null},
			{Error,{},Except[Null],Null,_,_,_},
			{CheckpointStart|CheckpointEnd,{},Null,Except[Null],Null,Null,Null},
			{ProcessingStart|ProcessingEnd,{},Null,Null,Except[Null],Excep,Null,Null,Null},
			{TaskEnd,{},Null,Null,Except[Null],Null,Null},
			{TaskStart,{},Null,Null,Null,Null,Null},
			{LogFile,{},Null,Null,Null,Null|EmeraldCloudFileP,Null|ObjectP[Object[EmeraldCloudFile]]},
			{Exit,{},Null,Null,Null,Null|EmeraldCloudFileP,Null|ObjectP[Object[EmeraldCloudFile]]},
			{_,{},Null,Null,Null,Null,Null}
		]
	],

	Test["Iteration <= TotalIterations or both are Null:",
		Lookup[packet, {Iteration, TotalIterations}],
		{Null, Null} | _?(#[[1]] <= #[[2]]&)
	]
};



(* ::Subsection:: *)
(*validProgramProteinPrepQTests*)


validProgramProteinPrepQTests[packet:PacketP[Object[Program,ProteinPrep]]]:={
(*No shaped field tests necessary*)

(*Specific field tests*)
	NotNullFieldTest[packet, {
		CellSourceLocations,
		FiltrationLocations,
		LysisBufferDestinationLocations,
		AliquotVolume,
		MediaVolume,
		WashBufferVolume,
		LysisVolume,
		LysisTime,
		LysisTemperature,
		PlateLidPositions,
		CellType,
		PlateFormat,
		NumberOfAliquots,
		WellsToMix
	}],


(*Logical Tests*)
	RequiredTogetherTest[packet, {
		ProteinQuantification,
		ProteinQuantificationID}],

(* instrument should be filled once the protocol is done *)
	Test[
		"Instrument is informed if the associated protocol, qualification or maintenance is completed:",
		{Download[DeleteCases[Lookup[packet,{Protocol,Qualification,Maintenance}],Null], Status], Lookup[packet,Instrument]},
		Alternatives[
			{Completed,Except[NullP]},
			{Except[Completed],_}
		]
	]
};



(* ::Subsection:: *)
(*validProgramqPCRQTests*)


validProgramqPCRQTests[packet:PacketP[Object[Program,qPCR]]]:={
(*No shaped field tests necessary*)

(*Specific field tests*)
	NotNullFieldTest[packet, {
		MasterMixIngredientLocations,
		MasterMixLocations,
		MasterMixVolumes,
		qPCRMixAliquots,
		qPCRPlateStamps,
		MasterMixDestinationWells
	}],


(* instrument should be filled once the protocol is done *)
	Test[
		"Instrument is informed if the associated protocol, qualification or maintenance is completed:",
		{Download[DeleteCases[Lookup[packet,{Protocol,Qualification,Maintenance}],Null], Status], Lookup[packet,Instrument]},
		Alternatives[
			{Completed,Except[NullP]},
			{Except[Completed],_}
		]
	]
};


(* ::Subsection:: *)
(*validProgramEngineBenchmarkTests*)


validProgramEngineBenchmarkTests[packet:PacketP[Object[Program,EngineBenchmark]]]:={
	NotNullFieldTest[packet, {SelectedInstruments,Containers}],
	RequiredTogetherTest[packet,{PDUTime,PDUPoweredInstrument}]

};


(* Tests to ensure fields in the model were used appropriately in the qualification *)
qualificationAndModelEngineBenchmarkSyncTests[programPacket:PacketP[Object[Program,EngineBenchmark]]]:=Module[
	{qualificationPacket},

	qualificationPacket = Download[
		programPacket[Qualification]
	];

	(* If there's no qualification associated with the program or if the qualification is not complete, we shouldn't do any completion tests *)
	If[
		Or[
			Not[MatchQ[qualificationPacket,PacketP[]]],
			Not[MatchQ[qualificationPacket[Status],Completed]]
		],
		Return[{}]
	];

	(* Check that once associated qualification is completed, program fields are appropriately populated *)
	{
		(* TwinCat software used by sensornet doesn't support Macs, so qualification skips sensor tasks *)
		Test["Sensor data should be recorded when the qualification is run on Windows:",
			If[MatchQ[qualificationPacket[OperatingSystem],Alternatives[Windows7 | Windows10 | WindowsXP]],
				MatchQ[programPacket[RecordedSensorData],{ObjectP[Object[Data]]..}],
				True
			],
			True
		],

		Test["PDUPoweredInstrument, Container, and SelectedInstrument were resolved during the qualification:",
			MatchQ[
				Lookup[programPacket,{PDUPoweredInstrument, Container,SelectedInstrument}],
				{ObjectP[]..}
			]
		]
	}
];



(* ::Subsection::Closed:: *)
(*validProgramReceiveInventoryTests*)


validProgramReceiveInventoryTests[packet:PacketP[Object[Program, ReceiveInventory]]]:={

	(* specific field tests *)
	NotNullFieldTest[packet, {
		BatchNumber,
		QuantityReceived,
		ProductName,
		Maintenance
	}]
};



(* ::Subsection:: *)
(*validProgramAbsorbanceQuantificationPrepQTests*)


validProgramAbsorbanceQuantificationPrepQTests[packet:PacketP[Object[Program,AbsorbanceQuantificationPrep]]]:={
(*No shaped field tests necessary*)

(*Specific field tests*)
	NotNullFieldTest[packet, {
		SampleAliquots,
		MixVolume,
		MixSourceVolume,
		NumberOfMixes,
		BufferAliquots,
		SampleSource,
		SampleDestination,
		SampleVolumes,
		NumberOfSourcePlates,
		NumberOfDestinationPlates,
		DiluteSamples
	}],


(*Logical Tests*)
	RequiredTogetherTest[packet, {DilutionSource, DilutionDestination, DilutionVolumes}],
	RequiredTogetherTest[packet, {SampleDilutionSource, SampleDilutionVolumes}],
	RequiredTogetherTest[packet, {BufferDiluentSource, BufferDiluentDestination, BufferDiluentVolumes}],

(* instrument should be filled once the protocol is done *)
	Test[
		"Instrument is informed if the associated protocol, qualification or maintenance is completed:",
		{Download[DeleteCases[Lookup[packet,{Protocol,Qualification,Maintenance}],Null], Status], Lookup[packet,Instrument]},
		Alternatives[
			{Completed,Except[NullP]},
			{Except[Completed],_}
		]
	]
};



(* ::Subsection:: *)
(*validProgramSampleManipulationQTests*)


validProgramSampleManipulationQTests[packet:PacketP[Object[Program,SampleManipulation]]]:={
(*No shaped field tests necessary*)

	(*Specific field tests*)
	NotNullFieldTest[packet, {
		FilePath,
		SamplesIn,
		ContainersIn,
		PortNames,
		SampleOut,
		ContainerOut,
		DispensingHead,
		DispensingTime
	}],

	(* cleaning fields required together *)
	RequiredTogetherTest[packet,{
		WashFilePath,
		CleaningSolvent,
		CleaningWasteContainer,
		CleaningSyringe,
		DryingSyringe,
		DirtyDipTubeContainer,
		CleanDipTubeContainer,
		FumeHood
	}],

	(* instrument should be filled once the protocol is done *)
	Test[
		"Instrument is informed if the associated protocol, qualification or maintenance is completed:",
		{Download[DeleteCases[Lookup[packet,{Protocol,Qualification,Maintenance}],Null], Status], Lookup[packet,Instrument]},
		Alternatives[
			{Completed,Except[NullP]},
			{Except[Completed],_}
		]
	]
};



(* ::Subsection:: *)
(*validProgramStainCellsFlowQTests*)


validProgramStainCellsFlowQTests[packet:PacketP[Object[Program,StainCellsFlow]]]:={
(*No shaped field tests necessary*)

(*Specific field tests*)
	NotNullFieldTest[packet, {
		FlowCytometry,
		Stain
	}],

(* instrument should be filled once the protocol is done *)
	Test[
		"Instrument is informed if the associated protocol, qualification or maintenance is completed:",
		{Download[DeleteCases[Lookup[packet,{Protocol,Qualification,Maintenance}],Null], Status], Lookup[packet,Instrument]},
		Alternatives[
			{Completed,Except[NullP]},
			{Except[Completed],_}
		]
	]
};



(* ::Subsection:: *)
(*validProgramTransfectionQTests*)


validProgramTransfectionQTests[packet:PacketP[Object[Program,Transfection]]]:={
(*No shaped field tests necessary*)

(*Specific field tests*)
	NotNullFieldTest[packet, {
		PlateFormat,
		PlateLidLocations,
		TransfectionMixtureIngredientLocations,
		TransfectionMixtureLocations,
		TransfectionMixtureIngredientVolumes,
		TransfectionAliquots,
		TransfectionSamples,
		TransfectionReagentSamples,
		BufferSamples
	}],

	(* instrument should be filled once the protocol is done *)
	Test[
		"Instrument is informed if the associated protocol, qualification or maintenance is completed:",
		{Download[DeleteCases[Lookup[packet,{Protocol,Qualification,Maintenance}],Null], Status], Lookup[packet,Instrument]},
		Alternatives[
			{Completed,Except[NullP]},
			{Except[Completed],_}
		]
	]
};



(* ::Subsection::Closed:: *)
(*validProgramTransferQTests*)


validProgramTransferQTests[packet:PacketP[Object[Program,Transfer]]]:={
(*Specific field tests*)

	Test["ContainerOut, DestinationWell, and Amount are required if the transfer is not a mix, incubate, filter, centrifuge or wait:",
		Lookup[packet,{Manipulations,ContainerOut,DestinationWell,Amount,FillToVolumeTransferType}],
		Alternatives[
			{_,Null,Null,Null,Placeholder},
			{{(_Filter|_Mix|_Incubate|_Wait|_Centrifuge)..},Null,Null,Null,Null},
			{_,ObjectP[],WellP,Except[Null],Except[Placeholder]}
		]
	],

	RequiredTogetherTest[packet,{Syringe,Needle}],

	Test["Only one measuring device can be informed per transfer:",
		Lookup[packet,{Pipette,Balance,Syringe,GraduatedCylinder}],
		Alternatives[
			{ObjectP[],Null,Null,Null},
			{Null,ObjectP[],Null,Null},
			{Null,Null,ObjectP[],Null},
			{Null,Null,Null,ObjectP[]},
			NullP
		]
	],

	Test["ContainerIn and SourceWell are required unless water is being used directly from a purifier or the program is a mix, incubate, filter, centrifuge or wait:",
		Lookup[packet,{Manipulations,WaterPurifier,ContainerIn,SourceWell,FillToVolumeTransferType}],
		Alternatives[
			{_,Null,Null,Null,Placeholder},
			{{(_Filter|_Mix|_Incubate|_Wait|_Centrifuge)..},Null,Null,Null,Null},
			{_,Null,ObjectP[],WellP,Except[Placeholder]}
		]
	],

(* When using large amounts of water, fill graduated cylinder using water purifier and directly pour into destination *)
	Test["If WaterPurifier is informed, GraduatedCylinder must also be informed:",
		Lookup[packet,{WaterPurifier,GraduatedCylinder}],
		Alternatives[
			{ObjectP[],ObjectP[]},
			{NullP,_}
		]
	],

	Test["Balance is only informed when Amount is a solid:",
		Lookup[packet,{Amount,Balance}],
		Alternatives[
			{_?MassQ|_Integer,ObjectP[{Model[Instrument, Balance], Object[Instrument, Balance]}]},
			{Except[_?MassQ|_Integer],Null}
		]
	],

	Test["WeighBoat is only informed when using a balance:",
		Lookup[packet,{WeighBoat,Balance}],
		Alternatives[
			{Except[NullP],ObjectP[{Model[Instrument, Balance], Object[Instrument, Balance]}]},
			{NullP,_}
		]
	],

	Test["When Amount and ScaledAmount are populated, they are greater than or equal to 0:",
		Unitless[Lookup[packet,{Amount,ScaledAmount}]],
		{Null|GreaterEqualP[0],Null|GreaterEqualP[0]}
	],


	Test["SamplesOut is only informed in filter primitives:",
		Lookup[packet,{Manipulations,SamplesOut}],
		Alternatives[
			{{_Filter..},{ObjectP[Object[Sample]]..}},
			{_,{}}
		]
	],

	Test["If the program has been completed FiltrationTypes and FilterProtocols must both be populated or both be Null:",
		If[MatchQ[Lookup[packet,DateCompleted],Null],
			True,
			MatchQ[Lookup[packet,{FiltrationTypes,FilterProtocols}],{{},{}}|{{FiltrationTypeP..},{ObjectP[Object[Protocol]]..}}]
		],
		True
	],

	Test["If an incubate program has been completed MixBooleans and IncubateProtocols must all be populated:",
		If[MatchQ[Lookup[packet,DateCompleted],Null]||!MatchQ[Lookup[packet,Manipulations],{_Incubate..}],
			True,
			MatchQ[Lookup[packet,{MixBooleans,IncubateProtocols}],{{BooleanP..},{ObjectP[Object[Protocol]]..}}]
		],
		True
	],

	Test["If a centrifuge program has been completed Times, Temperatures, Instruments, Speeds, CentrifugeProtocols must all be populated or all be Null:",
		If[MatchQ[Lookup[packet,DateCompleted],Null]||!MatchQ[Lookup[packet,Manipulations],{_Centrifuge..}],
			True,
			MatchQ[
				Lookup[packet,{Times, Temperatures, Speeds, Instruments, CentrifugeProtocols}],
				{{UnitsP[]..},{UnitsP[]..},{UnitsP[]..},{ObjectP[{Object[Instrument,Centrifuge],Model[Instrument,Centrifuge]}]..},{ObjectP[Object[Protocol]]..}}
			]
		],
		True
	],
	
	Test["Duration is only informed in wait primitives:",
		Lookup[packet,{Manipulations,Duration}],
		Alternatives[
			{{_Wait..},TimeP},
			{_,Null}
		]
	]


};


(* ::Subsection:: *)
(* Test Registration *)


registerValidQTestFunction[Object[Program],validProgramQTests];
registerValidQTestFunction[Object[Program, AbsorbanceQuantificationPrep],validProgramAbsorbanceQuantificationPrepQTests];
registerValidQTestFunction[Object[Program, cDNAPrep],validProgramcDNAPrepQTests];
registerValidQTestFunction[Object[Program, CellMediaChange],validProgramCellMediaChangeQTests];
registerValidQTestFunction[Object[Program, CellSplit],validProgramCellSplitQTests];
registerValidQTestFunction[Object[Program, CellStaining],validProgramCellStainingQTests];
registerValidQTestFunction[Object[Program, Cleavage],validProgramCleavageQTests];
registerValidQTestFunction[Object[Program, FluorescenceThermodynamics],validProgramFluorescenceThermodynamicsQTests];
registerValidQTestFunction[Object[Program, MeasureWeight],validProgramMeasureWeightQTests];
registerValidQTestFunction[Object[Program, MeasureVolume],validProgramMeasureVolumeQTests];
registerValidQTestFunction[Object[Program, MitochondrialIntegrityAssay],validProgramMitochondrialIntegrityAssayQTests];
registerValidQTestFunction[Object[Program, Mix],validProgramMixQTests];
registerValidQTestFunction[Object[Program, PipettingLinearity],validProgramPipettingLinearityQTests];
registerValidQTestFunction[Object[Program, ProcedureEvent],validProgramProcedureEventQTests];
registerValidQTestFunction[Object[Program, ProteinPrep],validProgramProteinPrepQTests];
registerValidQTestFunction[Object[Program, qPCR],validProgramqPCRQTests];
registerValidQTestFunction[Object[Program, EngineBenchmark],validProgramEngineBenchmarkTests];
registerValidQTestFunction[Object[Program, ReceiveInventory],validProgramReceiveInventoryTests];
registerValidQTestFunction[Object[Program, SampleManipulation],validProgramSampleManipulationQTests];
registerValidQTestFunction[Object[Program, Transfection],validProgramTransfectionQTests];
registerValidQTestFunction[Object[Program, Transfer],validProgramTransferQTests];
