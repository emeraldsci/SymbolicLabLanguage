(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*validModelPartQTests*)


validModelPartQTests[packet:PacketP[Model[Part]]] := {

	(* General fields filled in *)
	NotNullFieldTest[packet,{
		Authors,
		Name,
		Dimensions,
		DefaultStorageCondition
	}],

	(* If Expires \[Equal] True, then either ShelfLife or UnsealedShelfLife must be informed. If either ShelfLife or UnsealedShelfLife is informed, then Expires must \[Equal] True. *)
	Test["Either ShelfLife or UnsealedShelfLife must be informed if Expires == True; if either ShelfLife or UnsealedShelfLife is informed, Expires must equal True:",
		Lookup[packet,{Expires, ShelfLife,UnsealedShelfLife}],
		Alternatives[{True, Except[NullP|{}],NullP|{}},{True, NullP|{},Except[NullP|{}]},{True, Except[NullP|{}],Except[NullP|{}]},{Except[True],NullP|{},NullP|{}}]
	],


	Test["If StickerPositionOnReceiving is populated, PositionStickerPlacementImage is also populated and vise versa",
		Lookup[packet,{StickerPositionOnReceiving,PositionStickerPlacementImage}],
		Alternatives[
			{Null,Null},
			{Except[Null],Except[Null]}
		]
	],

	Test["If StickerConnectionOnReceiving is populated, ConnectionStickerPlacementImage is also populated and vise versa",
		Lookup[packet,{StickerConnectionOnReceiving,ConnectionStickerPlacementImage}],
		Alternatives[
			{Null,Null},
			{Except[Null],Except[Null]}
		]
	],


	(* Products *)
	Test["If Deprecated is True, Products must also be Inactive:",
		If[
			MatchQ[
				Lookup[packet,Deprecated],
				True
			],
			Download[Lookup[packet,Products], Status],
			Null
		],
		{Inactive..}|_?NullQ|{}
	],

	Test["A part of this model cannot be obtained by both a normal product and a kit product (i.e., Products and KitProducts cannot both be populated):",
		Lookup[packet, {Products, KitProducts}],
		Alternatives[
			{{}, {}},
			{{ObjectP[Object[Product]]..}, {}},
			{{}, {ObjectP[Object[Product]]..}}
		]
	],
	Test["If the StorageOrientation is Side|Face StorageOrientationImage must be populated:",
		Lookup[packet, {StorageOrientation, StorageOrientationImage}],
		Alternatives[
			{(Side|Face), ObjectP[]},
			{Except[(Side|Face)], _}
		]
	],

	Test["If the StorageOrientation is Upright StorageOrientationImage or ImageFile must be populated:",
		Lookup[packet, {StorageOrientation, StorageOrientationImage, ImageFile}],
		Alternatives[
			{Upright, ObjectP[], _},
			{Upright, _, ObjectP[]},
			{Except[Upright], _, _}
		]
	]
};



(* ::Subsection::Closed:: *)
(*validModelPartCrimpingJigQTests*)


validModelPartCrimpingJigQTests[packet:PacketP[Model[Part,CrimpingJig]]]:={
	NotNullFieldTest[packet,
		{
			VialHeight,
			VialFootprint
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelPartCrimpingHeadQTests*)


validModelPartCrimpingHeadQTests[packet:PacketP[Model[Part,CrimpingHead]]]:={
	NotNullFieldTest[packet,
		{
			CoverFootprint,
			CrimpType
		}
	]
};



(* ::Subsection::Closed:: *)
(*validModelPartDecrimpingHeadQTests*)


validModelPartDecrimpingHeadQTests[packet:PacketP[Model[Part,DecrimpingHead]]]:={
	NotNullFieldTest[packet,
		{
			CoverFootprint
		}
	]
};



(* ::Subsection::Closed:: *)
(*validModelPartAlignmentToolQTests*)


validModelPartAlignmentToolQTests[packet:PacketP[Model[Part,AlignmentTool]]] := {};



(* ::Subsection::Closed:: *)
(*validModelPartHexKeyQTests*)


validModelPartHexKeyQTests[packet:PacketP[Model[Part,HexKey]]] := {};


(* ::Subsection::Closed:: *)
(*validModelPartAspiratorAdapterQTests*)


validModelPartAspiratorAdapterQTests[packet:PacketP[Model[Part,AspiratorAdapter]]] := {};


(* ::Subsection:: *)
(*validModelPartApertureTubeQTests*)


validModelPartApertureTubeQTests[packet:PacketP[Model[Part,ApertureTube]]]:={

	(* fields that should not be null *)
	NotNullFieldTest[packet,{
		(* Shared fields *)
		SupportedInstruments,
		Footprint,
		WettedMaterials,
		(* Unique fields *)
		ApertureDiameter,
		MaxCurrent,
		MinParticleSize,
		MaxParticleSize
	}],

	(* fields that should be null *)
	NullFieldTest[packet,{
		WiringConnectors,
		WiringLength,
		WiringDiameters
	}],

	(* sensible Min/Max fields *)
	FieldComparisonTest[packet,{MinParticleSize,MaxParticleSize},LessEqual]

};

(* ::Subsection::Closed:: *)
(*validModelPartBalanceQTests*)


validModelPartBalanceQTests[packet:PacketP[Model[Part,Balance]]]:={

	NotNullFieldTest[packet,{
		Manufacturer,
		UserManualFiles,
		Resolution,
		MaxWeight,
		MinWeight
	}]
};


(* ::Subsection::Closed:: *)
(*validModelPartBarcodeReaderQTests*)


validModelPartBarcodeReaderQTests[packet:PacketP[Model[Part,BarcodeReader]]] := {

	(* Shared field that should be Null *)
	NullFieldTest[
		packet,
		{
			WettedMaterials,
			Expires,
			ShelfLife,
			UnsealedShelfLife
		}
	],

	(* Unique fields that cannot be Null *)
	NotNullFieldTest[
		packet,
		{
			BarcodeType,
			ConnectionMethod
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelPartBackdropQTests*)


validModelPartBackdropQTests[packet:PacketP[Model[Part,Backdrop]]]:={};



(* ::Subsection::Closed:: *)
(*validModelPartBeamStopQTests*)


validModelPartBeamStopQTests[packet:PacketP[Model[Part,BeamStop]]] := {};


(* ::Subsection::Closed:: *)
(*validModelPartBLIPlateCoverQTests*)


validModelPartBLIPlateCoverQTests[packet:PacketP[Model[Part, BLIPlateCover]]] := {
	NotNullFieldTest[packet,
		{
			Rows,
			Columns,
			Reusable,
			InternalDimensions,
			ExternalDimensions,
			SupportedInstruments,
			WettedMaterials
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelPartBristlePlateTests*)


validModelPartBristlePlateTests[packet:PacketP[Model[Part, BristlePlate]]] := {
	NotNullFieldTest[packet,
		{
			NumberOfBristles,
			WettedMaterials,
			FootPrint
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelPartCameraQTests*)


validModelPartCameraQTests[packet:PacketP[Model[Part,Camera]]]:={
	NullFieldTest[
		packet,
		{
			WettedMaterials
		}
	],

	(* Test for Sensor Array Cameras*)
	Test[
		"If the model instument is a Sensor Array Camera, TargetSize must be informed:",
		If[MemberQ[{Model[Part, Camera, "id:o1k9jAGlvqRx"], Model[Part, Camera, "id:KBL5DvwA0mWa"], Model[Part, Camera, "id:M8n3rx0dZmWM"]},Lookup[packet,Object]],
			!NullQ[Lookup[packet,TargetSize]],
			True
		],
		True
	],

	(* --- Tests for fields that aid in calculation of real-world image scale for variable focal length camera setups --- *)
	RequiredTogetherTest[packet, {SensorDimensions, ImagePixelDimensions}],

	Test[
		"If SensorDimensions and ImagePixelDimensions are populated, their X- to Y-dimension ratios are approximately the same:",
		If[And[!NullQ[Lookup[packet, SensorDimensions]], !NullQ[Lookup[packet, ImagePixelDimensions]]],
			Equal[
				Round[Divide@@Lookup[packet, SensorDimensions], 0.01],
				Round[Divide@@Lookup[packet, ImagePixelDimensions], 0.01]
			],
			True
		],
		True
	]
};


(* ::Subsection:: *)
(*validModelPartCapillaryArrayQTests*)


validModelPartCapillaryArrayQTests[packet:PacketP[Model[Part,CapillaryArray]]]:={

	NotNullFieldTest[packet,{NumberOfCapillaries,CapillaryArrayLength,CompatibleInstrument}],

	(* Sensible Min/Max field checks *)
	RequiredTogetherTest[packet,{MinpH,MaxpH}],
	FieldComparisonTest[packet,{MinpH,MaxpH},LessEqual],
	RequiredTogetherTest[packet,{MinVoltage,MaxVoltage}],
	FieldComparisonTest[packet,{MinVoltage,MaxVoltage},LessEqual],
	RequiredTogetherTest[packet,{MinDestinationPressure,MaxDestinationPressure}],
	FieldComparisonTest[packet,{MinDestinationPressure,MaxDestinationPressure},LessEqual],

	Test["NumberOfCapillaries should be a member of the SupportedNumberOfCapillaries of all members of CompatibleInstrument",
		Module[
			{
				numberOfCapillaries,
				compatibleInstruments,
				compatibleInstrumentsNumberOfCapillaries
			},

			compatibleInstruments=Lookup[packet,CompatibleInstrument];

			numberOfCapillaries=Lookup[packet,NumberOfCapillaries];

			compatibleInstrumentsNumberOfCapillaries=Download[compatibleInstruments,SupportedNumberOfCapillaries];

			AllTrue[compatibleInstrumentsNumberOfCapillaries,MemberQ[#,numberOfCapillaries]&]
		],
		True
	],

	Test["CapillaryArrayLength should be a member of the SupportedCapillaryArrayLength of all members of CompatibleInstrument",
		Module[
			{
				capillaryArrayLength,
				compatibleInstruments,
				compatibleInstrumentsCapillaryArrayLength
			},

			compatibleInstruments=Lookup[packet,CompatibleInstrument];

			capillaryArrayLength=Lookup[packet,CapillaryArrayLength];

			compatibleInstrumentsCapillaryArrayLength=Download[compatibleInstruments,SupportedCapillaryArrayLength];

			AllTrue[compatibleInstrumentsCapillaryArrayLength,MemberQ[#,capillaryArrayLength]&]
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelPartCapillaryELISATestCartridgeQTests*)


validModelPartCapillaryELISATestCartridgeQTests[packet:PacketP[Model[Part,CapillaryELISATestCartridge]]]:={

	NotNullFieldTest[packet,{SupportedInstrument}]

};


(* ::Subsection:: *)
(*validModelPartCalibrationCardQTests*)


validModelPartCalibrationCardQTests[packet:PacketP[Model[Part,CalibrationCard]]]:={};



(* ::Subsection::Closed:: *)
(*validModelPartCentrifugeAdapterQTests*)


validModelPartCentrifugeAdapterQTests[packet:PacketP[Model[Part,CentrifugeAdapter]]] := {
	NotNullFieldTest[packet, {Footprint,AdapterFootprint}]
};



(* ::Subsection::Closed:: *)
(*validModelPartCheckValveQTests*)


validModelPartCheckValveQTests[packet:PacketP[Model[Part,CheckValve]]] := {
	NotNullFieldTest[packet, {SupportedInstruments}]
};



(* ::Subsection::Closed:: *)
(*validModelPartChillerQTests*)


validModelPartChillerQTests[packet:PacketP[Model[Part,Chiller]]] := {
	NotNullFieldTest[packet, {Instrument}]
};



(* ::Subsection::Closed:: *)
(*validModelPartComputerQTests*)


validModelPartComputerQTests[packet:PacketP[Model[Part,Computer]]] := {
	Test["Is ComputerType informed?", MatchQ[Lookup[packet, ComputerType], ComputerTypeP], True],

	Test["Is OS informed?", MatchQ[Lookup[packet, OperatingSystem], OperatingSystemP], True]
};


(* ::Subsection::Closed:: *)
(*validModelPartConductivityProbeQTests*)


validModelPartConductivityProbeQTests[packet:PacketP[Model[Part,ConductivityProbe]]]:={

	NotNullFieldTest[packet,{ProbeType, MinConductivity, MaxConductivity}],

	RequiredTogetherTest[packet, {MinConductivity, MaxConductivity}],FieldComparisonTest[packet, {MinConductivity, MaxConductivity}, LessEqual],

	RequiredTogetherTest[packet, {MinTemperature, MaxTemperature}],
	FieldComparisonTest[packet, {MinTemperature, MaxTemperature}, LessEqual],

	Test["NumberOfElectrodes should be informed if the ProbeType is not a Contacting:",
		Lookup[packet,{ProbeType,NumberOfElectrodes}],
		Alternatives[
			{Contacting,Except[Null]},
			{Except[Contacting],_}
		]
	]
};



(* ::Subsection::Closed:: *)
(*validModelPartConductivitySensorQTests*)


validModelPartConductivitySensorQTests[packet:PacketP[Model[Part,ConductivitySensor]]]:={

	NotNullFieldTest[packet,{MinConductivity,MaxConductivity,Connectors}],

	RequiredTogetherTest[packet,{MinConductivity,MaxConductivity}],FieldComparisonTest[packet,{MinConductivity,MaxConductivity},LessEqual],

	RequiredTogetherTest[packet,{MinTemperature,MaxTemperature}],
	FieldComparisonTest[packet,{MinTemperature,MaxTemperature},LessEqual]

};


(* ::Subsection::Closed:: *)
(*validModelPartDialysisClipQTests*)


validModelPartDialysisClipQTests[packet:PacketP[Model[Part,DialysisClip]]]:={
	NotNullFieldTest[
		packet,
		{
			WettedMaterials,
			MaxWidth,
			LengthOffset,
			MembraneTypes,
			Weighted,
			Hanging,
			MinTemperature,
			MaxTemperature
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelPartElectrochemicalReactionVesselHolderQTests*)


validModelPartElectrochemicalReactionVesselHolderQTests[packet:PacketP[Model[Part, ElectrochemicalReactionVesselHolder]]] := {
	(* Shared Fields *)
	NotNullFieldTest[packet,{NumberOfReactionVessels}]
};


(* ::Subsection::Closed:: *)
(*validModelPartElectrodePolishingPlateQTests*)


validModelPartElectrodePolishingPlateQTests[packet:PacketP[Model[Part, ElectrodePolishingPlate]]] := {
};



(* ::Subsection::Closed:: *)
(*validModelPartShakerAdapterQTests*)


validModelPartShakerAdapterQTests[packet:PacketP[Model[Part, ShakerAdapter]]] := {
};


(* ::Subsection::Closed:: *)
(*validModelPartElectrodeRackQTests*)


validModelPartElectrodeRackQTests[packet:PacketP[Model[Part, ElectrodeRack]]] := {
};


(* ::Subsection::Closed:: *)
(*validModelPartEluentGeneratorQTests*)


validModelPartEluentGeneratorQTests[packet:PacketP[Model[Part,EluentGenerator]]]:={
	NotNullFieldTest[
		packet,
		{
			Eluent,
			IonChromatographySystem,
			MinConcentration,
			MaxConcentration
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelPartFanQTests*)


validModelPartFanQTests[packet:PacketP[Model[Part, Fan]]] := {};


(* ::Subsection::Closed:: *)
(*validModelPartFerruleQTests*)


validModelPartFerruleQTests[packet:PacketP[Model[Part, Ferrule]]] := {
	NotNullFieldTest[packet,InnerDiameter]
};


(* ::Subsection::Closed:: *)
(*validModelPartFilterQTests*)


validModelPartFilterQTests[packet:PacketP[Model[Part, Filter]]] := {
	NotNullFieldTest[packet,{FilterType,SampleType,MembraneMaterial,CrossSectionalShape}],

	Test["If SampleType is Liquid, WettedMaterials must also be filled:",
		If[
			MatchQ[
				Lookup[packet,SampleType],
				Liquid
			],
			MatchQ[Lookup[packet,WettedMaterials],{(FilterMembraneMaterialP|PlasticP)..}],
			True
		],
		True
	],
	Test["If SampleType is Liquid, MaxFlowRate and MaxPressure must also be filled:",
		If[
			MatchQ[
				Lookup[packet,SampleType],
				Liquid
			],
			MatchQ[Lookup[packet,{MaxFlowRate,MaxPressure}],{FlowRateP,PressureP}],
			True
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelPartFilterAdapterQTests*)


validModelPartFilterAdapterQTests[packet:PacketP[Model[Part, FilterAdapter]]] := {
	NotNullFieldTest[packet,{InnerDiameter, OuterDiameter, Thickness, WettedMaterials}]
};


(* ::Subsection::Closed:: *)
(*validModelPartFlowCellQTests*)


validModelPartFlowCellQTests[packet:PacketP[Model[Part,FlowCell]]] := {
	NotNullFieldTest[packet, {MaxPressure, PathLength, Volume,SupportedInstruments}]
};



(* ::Subsection::Closed:: *)
(*validModelPartFlowRestrictorQTests*)


validModelPartFlowRestrictorQTests[packet:PacketP[Model[Part,FlowRestrictor]]] := {};


(* ::Subsection::Closed:: *)
(*validModelPartFunnelQTests*)


validModelPartFunnelQTests[packet:PacketP[Model[Part, Funnel]]] := {
	NotNullFieldTest[
		packet,
		{
			FunnelMaterial,
			FunnelType,
			StemLength,
			StemDiameter,
			MouthDiameter
		}
	],

	Test["If FunnelType -> Filter, then MaxVolume must be populated:",
		If[MatchQ[Lookup[packet, FunnelType], Filter],
			VolumeQ[Lookup[packet, MaxVolume]],
			True
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelPartFurnitureEquipmentQTests*)


validModelPartFurnitureEquipmentQTests[packet:PacketP[Model[Part, FurnitureEquipment]]] := {

	NullFieldTest[
		packet,
		{
			WettedMaterials,
			Expires,
			ShelfLife,
			UnsealedShelfLife
		}
	]

};


(* ::Subsection::Closed:: *)
(*validModelPartHeatExchangerQTests*)


validModelPartHeatExchangerQTests[packet:PacketP[Model[Part,HeatExchanger]]]:={
	NotNullFieldTest[packet, {FluidVolume, FillFluid,WettedMaterials}]
};


(* ::Subsection::Closed:: *)
(*validModelPartHexKeyQTests*)


validModelPartHexKeyQTests[packet:PacketP[Model[Part,HexKey]]]:={
};



(* ::Subsection::Closed:: *)
(*validModelPartInformationTechnologyQTests*)


validModelPartInformationTechnologyQTests[packet:PacketP[Model[Part,InformationTechnology]]]:={
	NullFieldTest[
		packet,
		{
			WettedMaterials
		}
	]
};



(* ::Subsection::Closed:: *)
(*validModelPartHandPumpQTests*)


validModelPartHandPumpQTests[packet:PacketP[Model[Part,HandPump]]]:={
	NotNullFieldTest[packet,{DispenseHeight,WettedMaterials}]
};


(* ::Subsection::Closed:: *)
(*validModelPartLampQTests*)


validModelPartLampQTests[packet:PacketP[Model[Part,Lamp]]] := {

	(* Fields that SHOULD be informed, ie should NOT be Null*)
	NotNullFieldTest[packet, LampType],

	Test["If LampType is not Fiber or LED, then WindowMaterial and LampOperationMode must be informed, else they are Null:",
		Lookup[packet, {LampType, WindowMaterial, LampOperationMode}],
		Alternatives[
			{Except[Fiber|LED], Except[NullP], Except[NullP]},
			{Fiber|LED, NullP, NullP}
		]
	],

	(* Required Together *)
	RequiredTogetherTest[packet, {MinWavelength, MaxWavelength}],

	(* MaxWavelength \[GreaterEqual] MinWavelength if both are not Null *)
	FieldComparisonTest[packet,{MaxWavelength,MinWavelength},GreaterEqual],

	Test[
		"If LampOperationMode is Flash, MaxFlashes has to be informed; else MaxLifeTime should be informed:",
		Lookup[packet, {LampOperationMode,MaxLifeTime, MaxFlashes}],
		Alternatives[
			{Flash, Null, Except[NullP]},
			{Except[Flash],Except[NullP], NullP}
		]
	],

	NullFieldTest[
		packet,
		{
			WettedMaterials
		}
	]

};


(* ::Subsection::Closed:: *)
(*validModelPartLaserQTests*)


validModelPartLaserQTests[packet:PacketP[Model[Part,Laser]]]:={

	(* Fields that SHOULD be informed, ie should NOT be Null*)
	NotNullFieldTest[packet,
		{
			LaserType,
			LaserClass,
			Wavelengths
		}
	],

	(* Fields that should be Null *)
	NullFieldTest[packet,
		{
			WettedMaterials
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelPartLaserOpticModuleQTests*)


validModelPartLaserOpticModuleQTests[packet:PacketP[Model[Part,LaserOpticModule]]] := {

	(* Fields that SHOULD be informed, ie should NOT be Null*)
	NotNullFieldTest[packet,{
		ChannelName,
		Laser,
		EmissionFilterWavelength,
		EmissionFilterBandwidth
	}],

	(* ExcitationFilterWavelength \[LessEqual]  EmissionFilterWavelength if both are not Null *)
	FieldComparisonTest[packet,{Laser,EmissionFilterWavelength},LessEqual],

	NullFieldTest[
		packet,
		{
			WettedMaterials
		}
	]
};



(* ::Subsection::Closed:: *)
(*validModelPartMixerQTests*)


validModelPartMixerQTests[packet:PacketP[Model[Part,Mixer]]] := {
	NotNullFieldTest[packet, {MaxPressure, MinpH, MaxpH, Volume,SupportedInstruments}]
};


(* ::Subsection::Closed:: *)
(*validModelPartNeedleLockingScrew*)


validModelPartNeedleLockingScrew[packet:PacketP[Model[Part,NeedleLockingScrew]]] := {};


(* ::Subsection::Closed:: *)
(*validModelPartNMRDepthGaugeQTests*)


validModelPartNMRDepthGaugeQTests[packet:PacketP[Model[Part,NMRDepthGauge]]] := {

	(* Fields that SHOULD be informed, ie should NOT be Null*)
	NotNullFieldTest[packet,{
		TubeDiameters,
		MaxBaseDepth,
		AdjustableBase
	}]
};


(* ::Subsection::Closed:: *)
(*validModelPartPeristalticPumpQTests*)


validModelPartPeristalticPumpQTests[packet:PacketP[Model[Part,PeristalticPump]]]:={

	NotNullFieldTest[packet,{
		Manufacturer,
		UserManualFiles,
		TubingType,
		MinFlowRate,
		MaxFlowRate
	}]
};


(* ::Subsection::Closed:: *)
(*validModelPartVacuumPumpQTests*)


validModelPartVacuumPumpQTests[packet:PacketP[Model[Part,VacuumPump]]]:={

	NotNullFieldTest[packet,{
		Manufacturer
	}]
};






(* ::Subsection::Closed:: *)
(*validModelPartStirBarQTests*)


validModelPartStirBarQTests[packet:PacketP[Model[Part,StirBar]]]:={
	NotNullFieldTest[
		packet,
		{
			WettedMaterials,
			StirBarLength,
			StirBarWidth,
			MinTemperature,
			MaxTemperature
		}
	]
};



(* ::Subsection::Closed:: *)
(*validModelPartStirBarQTests*)


validModelPartStirBarRetrieverQTests[packet:PacketP[Model[Part,StirBarRetriever]]]:={
	NotNullFieldTest[
		packet,
		{
			WettedMaterials,
			RetrieverLength,
			RetrieverDiameter,
			MinTemperature,
			MaxTemperature
		}
	]
};



(* ::Subsection::Closed:: *)
(*validModelPartNutQTests*)


validModelPartNutQTests[packet:PacketP[Model[Part, Nut]]] := {
	NotNullFieldTest[packet,{Gender, ConnectionType, ThreadType, OuterDiameter, InnerDiameter}],

	FieldComparisonTest[packet,{OuterDiameter,InnerDiameter},Greater]
};


(* ::Subsection::Closed:: *)
(*validModelPartMeterModuleQTests*)


validModelPartMeterModuleQTests[packet:PacketP[Model[Part,MeterModule]]] := {
	(* Fields that SHOULD be informed, ie should NOT be Null*)
	NotNullFieldTest[packet,{
		MeasurementParameters
	}]
};


(* ::Subsection::Closed:: *)
(*validModelPartpHProbeQTests*)


validModelPartpHProbeQTests[packet:PacketP[Model[Part,pHProbe]]]:={

	NotNullFieldTest[packet,{ProbeType, MinpH, MaxpH}],

	RequiredTogetherTest[packet, {MinpH, MaxpH}],FieldComparisonTest[packet, {MinpH, MaxpH}, LessEqual],

	RequiredTogetherTest[packet, {MinTemperature, MaxTemperature}],
	FieldComparisonTest[packet, {MinTemperature, MaxTemperature}, LessEqual],

	Test["NumberOfElectrodes should be informed if the ProbeType is not a Contacting:",
		Lookup[packet,{ProbeType,NumberOfElectrodes}],
		Alternatives[
			{Contacting,Except[Null]},
			{Except[Contacting],_}
		]
	]
};



(* ::Subsection::Closed:: *)
(*validModelPartPistonQTests*)


validModelPartPistonQTests[packet:PacketP[Model[Part,Piston]]] := {
	NotNullFieldTest[packet, {SupportedInstruments}]
};



(* ::Subsection::Closed:: *)
(*validModelPartPressureSensorQTests*)


validModelPartPressureSensorQTests[packet:PacketP[Model[Part,PressureSensor]]]:={

	NotNullFieldTest[packet,{MinPressure,MaxPressure,Connectors}],

	RequiredTogetherTest[packet,{MinPressure,MaxPressure}],FieldComparisonTest[packet,{MinPressure,MaxPressure},LessEqual]

};




(* ::Subsection::Closed:: *)
(*validModelPartStirrerShaftQTests*)


validModelPartStirrerShaftQTests[packet:PacketP[Model[Part,StirrerShaft]]]:={
	NotNullFieldTest[
		packet,
		{
			WettedMaterials,
			StirrerLength,
			ShaftDiameter,
			ImpellerDiameter,
			MaxDiameter
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelPartSonicationHornQTests*)


validModelPartSonicationHornQTests[packet:PacketP[Model[Part,SonicationHorn]]]:={
	NotNullFieldTest[
		packet,
		{
			HornLength,
			HornDiameter,
			MaxDiameter
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelPartSuppressorQTests*)


validModelPartSuppressorQTests[packet:PacketP[Model[Part,Suppressor]]]:={
	NotNullFieldTest[
		packet,
		{
			IonChromatographySystem,
			FactoryRecommendedVoltage,
			MinCurrent,
			MaxCurrent,
			MinVoltage,
			MaxVoltage,
			SuppressorSpecificFactor
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelPartDispensingHeadQTests*)


validModelPartDispensingHeadQTests[packet:PacketP[Model[Part,DispensingHead]]]:={

	NotNullFieldTest[
		packet,
		{
			AllowedTubingDiameter,
			MaxBottleDiameter,
			MaxContainerDepth,
			MinContainerDepth
		}
	],

	FieldComparisonTest[packet,{MaxContainerDepth,MinContainerDepth},GreaterEqual],

	NullFieldTest[
		packet,
		{
			WettedMaterials
		}
	]

};



(* ::Subsection::Closed:: *)
(*validModelPartNozzleQTests*)


validModelPartNozzleQTests[packet:PacketP[Model[Part,Nozzle]]] := {

	NotNullFieldTest[packet,{
		NozzleLength,MinDiameter,MaxDiameter,WettedMaterials
	}],

	NullFieldTest[packet,{
		Expires,ShelfLife,UnsealedShelfLife
	}],

	RequiredTogetherTest[packet, {MinShaftLength,MaxShaftLength}],

	(* MaxDiameter should be greater than or equal to MinDiameter *)
	FieldComparisonTest[packet, {MaxDiameter,MinDiameter},GreaterEqual],

	(* MaxDiameter should be greater than or equal to MinDiameter *)
	FieldComparisonTest[packet, {MaxShaftLength,MinShaftLength},GreaterEqual]
};


(* ::Subsection::Closed:: *)
(*validModelPartInverterQTests*)


validModelPartInverterQTests[packet:PacketP[Model[Part,Inverter]]] := {

	NotNullFieldTest[
		packet,
		{
			InputVoltage,
			OutputVoltage,
			OutputWaveform,
			OutputFrequency,
			MaxPower
		}
	],

	NullFieldTest[
		packet,
		{
			WettedMaterials
		}
	]

};


(* ::Subsection::Closed:: *)
(*validModelPartObjectiveQTests*)


validModelPartObjectiveQTests[packet:PacketP[Model[Part,Objective]]] := {

	(* Fields that SHOULD be informed, ie should NOT be Null*)
	NotNullFieldTest[packet,{
		Magnification,
		NumericalAperture,
		CoverGlassAdjustmentGauge,
		MinCoverGlassThickness,
		MaxCoverGlassThickness,
		RetractiveStopper,
		PhaseContrast,
		PhaseRing,
		DifferentialInterferenceContrast,
		BrightField,
		Fluorescence,
		FlatFieldCorrection,
		AberrationCorrection,
		SpringLoaded,
		ImmersionMedium,
		MinWorkingDistance,
		MaxWorkingDistance
	}],

	(* only one should be informed *)
	UniquelyInformedTest[packet,{TubeLength,InfinityCorrectedTube}],

	(* Inequalities *)
	FieldComparisonTest[packet,{MinWorkingDistance,MaxWorkingDistance},LessEqual],
	FieldComparisonTest[packet,{MinCoverGlassThickness,MaxCoverGlassThickness},LessEqual],

	NullFieldTest[packet,{
		WettedMaterials
	}]
};


(* ::Subsection::Closed:: *)
(*validModelPartOpticalFilterQTests*)


validModelPartOpticalFilterQTests[packet:PacketP[Model[Part,OpticalFilter]]]:={

	(* Fields that SHOULD be informed, ie should NOT be Null*)
	NotNullFieldTest[packet,
		{
			BandpassFilterType
		}
	],

	NullFieldTest[packet,
		{
			WettedMaterials
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelPartOpticModuleQTests*)


validModelPartOpticModuleQTests[packet:PacketP[Model[Part,OpticModule]]] := {

	(* Fields that SHOULD be informed, ie should NOT be Null*)
	NotNullFieldTest[packet,ExcitationFilterWavelength],

	(* ExcitationFilterWavelength \[LessEqual]  EmissionWavelength if both are not Null *)
	FieldComparisonTest[packet,{ExcitationFilterWavelength,EmissionFilterWavelength},LessEqual],
	FieldComparisonTest[packet,{ExcitationFilterWavelength,SecondaryEmissionFilterWavelength},LessEqual],

	NullFieldTest[
		packet,
		{
			WettedMaterials
		}
	]

};



(* ::Subsection::Closed:: *)
(*validModelPartUniversalInterfaceConverter*)


validModelPartUniversalInterfaceConverterQTests[packet:PacketP[Model[Part,UniversalInterfaceConverter]]] := {};



(* ::Subsection::Closed:: *)
(*validModelPartPowerDistributionUnitQTests*)


validModelPartPowerDistributionUnitQTests[packet:PacketP[Model[Part,PowerDistributionUnit]]] := {

	RequiredTogetherTest[packet, {NumberOfPorts, PortIDs}],
	Test[
		"The length of PortIDs should be NumberOfPorts informed:",
		Length[Lookup[packet, PortIDs]] == Lookup[packet, NumberOfPorts],
		True
	],

	NullFieldTest[
		packet,
		{
			WettedMaterials
		}
	]

};



(* ::Subsection::Closed:: *)
(*validModelPartSealQTests*)


validModelPartSealQTests[packet:PacketP[Model[Part,Seal]]] := {
	NotNullFieldTest[packet, {SupportedInstruments}]
};



(* ::Subsection::Closed:: *)
(*validModelPartSensornetQTests*)


validModelPartSensornetQTests[packet:PacketP[Model[Part,Sensornet]]] := {
	NullFieldTest[
		packet,
		{
			WettedMaterials
		}
	]
};





(* ::Subsection::Closed:: *)
(*validModelPartSpectrophotometerQTests*)


validModelPartSpectrophotometerQTests[packet:PacketP[Model[Part,Spectrophotometer]]]:={
	NotNullFieldTest[
		packet,
		{
			LampType,
			LightSourceType,
			BeamOffset,
			MinMonochromator,
			MaxMonochromator,
			MonochromatorBandpass,
			MinAbsorbance,
			MaxAbsorbance,
			ElectromagneticRange
		}
	]
};




(* ::Subsection::Closed:: *)
(*validModelPartReferenceElectrodeQTests*)


validModelPartReferenceElectrodeQTests[packet:PacketP[Model[Part,ReferenceElectrode]]]:={
	NotNullFieldTest[
		packet,
		{
			ReferenceElectrodeType,
			DefaultStorageSolution
		}
	]
};



(* ::Subsection:: *)
(*validModelPartRefrigerationUnitQTests*)


validModelPartRefrigerationUnitQTests[packet:PacketP[Model[Part,RefrigerationUnit]]]:={};


(* ::Subsection::Closed:: *)
(*validModelPartEmbeddedPCQTests*)


validModelPartEmbeddedPCQTests[packet:PacketP[Model[Part,EmbeddedPC]]] := {
	NullFieldTest[
		packet,
		{
			WettedMaterials
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelPartSyringeQTests*)


validModelPartSyringeQTests[packet:PacketP[Model[Part,Syringe]]] := {

	(* Fields that SHOULD be informed, ie should NOT be Null*)
	NotNullFieldTest[packet,{
		BarrelMaterial,
		PlungerMaterial,
		MinVolume,
		MaxVolume,
		MaxNumberOfUses,
		WettedMaterials
	}]
};


(* ::Subsection::Closed:: *)
(*validModelPartTemperatureProbeQTests*)


validModelPartTemperatureProbeQTests[packet:PacketP[Model[Part,TemperatureProbe]]] := {

	NotNullFieldTest[packet, {
		MinTemperature,
		MaxTemperature,
		TemperatureStandardDeviation,
		WettedMaterials
	}],
	FieldComparisonTest[packet,{MinTemperature,MaxTemperature},LessEqual]

};


(* ::Subsection::Closed:: *)
(*validModelPartTensiometerProbeQTests*)


validModelPartTensiometerProbeQTests[packet:PacketP[Model[Part,TensiometerProbe]]] := {

	NotNullFieldTest[packet, {
		LifeTime,
		Diameter,
		WettedMaterials
	}],

	NullFieldTest[packet,{
		Expires,
		ShelfLife,
		UnsealedShelfLife
	}]

};


(* ::Subsection::Closed:: *)
(*validModelPartTensiometerProbeCleanerQTests*)


validModelPartTensiometerProbeCleanerQTests[packet:PacketP[Model[Part,TensiometerProbeCleaner]]] := {

	NotNullFieldTest[packet, {
		LifeTime
	}],

	NullFieldTest[packet,{
		Expires,
		ShelfLife,
		UnsealedShelfLife
	}]
};


(* ::Subsection::Closed:: *)
(*validModelPartThermalBlockQTests*)


validModelPartThermalBlockQTests[packet:PacketP[Model[Part,ThermalBlock]]]:={};


(* ::Subsection::Closed:: *)
(*validModelPartViscometerChipQTests*)


validModelPartViscometerChipQTests[packet:PacketP[Model[Part,ViscometerChip]]] := {

	NotNullFieldTest[packet, {
		MaxPressure,
		ChannelHeight,
		ChannelWidth,
		ChannelLength,
		WettedMaterials
	}],

	NullFieldTest[packet,{
		Expires,
		ShelfLife,
		UnsealedShelfLife
	}]
};


(* ::Subsection::Closed:: *)
(*validModelPartHeatSinkQTests*)


validModelPartHeatSinkQTests[packet:PacketP[Model[Part,HeatSink]]] := {

	(* Fields that SHOULD be informed, ie should NOT be Null*)
	NotNullFieldTest[packet,{
		FinShape,
		CrossSectionalShape
	}],

	NullFieldTest[packet,{
		Expires,
		ShelfLife,
		UnsealedShelfLife
	}]
};



(* ::Subsection::Closed:: *)
(*validModelPartNMRProbeQTests*)


validModelPartNMRProbeQTests[packet:PacketP[Model[Part,NMRProbe]]]:={
	(* Fields that SHOULD be informed, ie should NOT be Null*)
	NotNullFieldTest[packet,{
		TubeDiameter,
		Nuclei,
		InnerCoilNuclei,
		OuterCoilNuclei,
		LockNucleus
	}],

	NullFieldTest[
		packet,
		{
			WettedMaterials,
			Expires,
			ShelfLife,
			UnsealedShelfLife
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelPartAmpouleOpenerQTests*)


validModelPartAmpouleOpenerQTests[packet:PacketP[Model[Part,AmpouleOpener]]]:={
	(* Fields that SHOULD be informed, ie should NOT be Null*)
	NotNullFieldTest[
		packet,
		{
		MinBulbDiameter,
		MaxBulbDiameter
		}
	],

	NullFieldTest[
	packet,
		{
			WettedMaterials,
			Expires,
			ShelfLife,
			UnsealedShelfLife
		}
	],

	FieldComparisonTest[packet, {MaxBulbDiameter,MinBulbDiameter},GreaterEqual]
};


(* ::Subsection::Closed:: *)
(*validModelPartBackfillVentQTests*)


validModelPartBackfillVentQTests[packet:PacketP[Model[Part, BackfillVent]]]:={};


(* ::Subsection::Closed:: *)
(*validModelPartPressureRegulatorQTests*)


validModelPartPressureRegulatorQTests[packet:PacketP[Model[Part,PressureRegulator]]]:={
	(* Fields that SHOULD be informed, ie should NOT be Null*)
	NotNullFieldTest[packet,{
		MinPressure,
		MaxPressure
	}]
};


(* ::Subsection::Closed:: *)
(*validModelPartFoamImagingModuleQTests*)


validModelPartFoamImagingModuleQTests[packet:PacketP[Model[Part,FoamImagingModule]]]:={
	(*fields that should be informed*)
	NotNullFieldTest[packet,{FieldOfView,Wavelength}],
	(*sanity check tests*)
	FieldComparisonTest[packet,{MinCameraHeight,MaxCameraHeight},LessEqual],
	FieldComparisonTest[packet,{MinImageSamplingFrequency,MaxImageSamplingFrequency},LessEqual]
};



(* ::Subsection::Closed:: *)
(*validModelPartLiquidConductivityModuleQTests*)


validModelPartLiquidConductivityModuleQTests[packet:PacketP[Model[Part,LiquidConductivityModule]]]:={
	(*fields that should be informed*)
	NotNullFieldTest[packet,{SensorHeights}],
	(*sanity check tests*)
	FieldComparisonTest[packet,{MinResistanceMeasurement,MaxResistanceMeasurement},LessEqual],
	FieldComparisonTest[packet,{MinResistanceSamplingFrequency,MaxResistanceSamplingFrequency},LessEqual],
	FieldComparisonTest[packet,{MinColumnHeight,MaxColumnHeight},LessEqual]
};



(* ::Subsection::Closed:: *)
(*validModelPartDiodeArrayModuleQTests*)


validModelPartDiodeArrayModuleQTests[packet:PacketP[Model[Part,DiodeArrayModule]]]:={
	(*fields that should be informed*)
	NotNullFieldTest[packet,IlluminationWavelength]
};



(* ::Subsection::Closed:: *)
(*validModelPartORingQTests*)


validModelPartORingQTests[packet:PacketP[Model[Part,ORing]]]:={
	(*fields that should be informed*)
	NotNullFieldTest[packet,Reusable]
};



(* ::Subsection::Closed:: *)
(*validModelPartSpargeFilterQTests*)


validModelPartSpargeFilterQTests[packet:PacketP[Model[Part,SpargeFilter]]]:={
	(*fields that should be informed*)
	NotNullFieldTest[packet,{CrossSectionalShape,Diameter}],
	(*sanity check tests*)
	FieldComparisonTest[packet,{MinPoreSize,MaxPoreSize},LessEqual]
};



(* ::Subsection::Closed:: *)
(*validModelPartStirBladeQTests*)


validModelPartStirBladeQTests[packet:PacketP[Model[Part,StirBlade]]]:={
	(*fields that should be informed*)

};



(* ::Subsection::Closed:: *)
(*validModelPartFillRodQTests*)


validModelPartFillRodQTests[packet:PacketP[Model[Part,FillRod]]]:={

	NotNullFieldTest[packet,{
		IndicatorColor
	}]
};


(* ::Subsection::Closed:: *)
(*validModelPartFanFilterUnitQTests*)


validModelPartFanFilterUnitQTests[packet:PacketP[Model[Part,FanFilterUnit]]]:={

};


(* ::Subsection:: *)
(*validModelPartGauzeHolderQTests*)


validModelPartGauzeHolderQTests[packet:PacketP[Model[Part,GauzeHolder]]]:={

};


(* ::Subsection:: *)
(*validModelPartGrinderClampAssemblyQTests*)


validModelPartGrinderClampAssemblyQTests[packet:PacketP[Model[Part, GrinderClampAssembly]]]:={
	NotNullFieldTest[packet, {
		(* Shared *)
		SupportedInstruments
	}]
};


(* ::Subsection::Closed:: *)
(*validModelPartGravityRackPlatformQTests*)


validModelPartGravityRackPlatformQTests[packet:PacketP[Model[Part,GravityRackPlatform]]]:={
	NotNullFieldTest[packet,{
		GravityRackPlatformType
	}]
};


(* ::Subsection::Closed:: *)
(*validModelPartSolenoidValveQTests*)


validModelPartSolenoidValveQTests[packet:PacketP[Model[Part,SolenoidValve]]]:={

};



(* ::Subsection::Closed:: *)
(*validModelPartLighterQTests*)


validModelPartLighterQTests[packet:PacketP[Model[Part,Lighter]]]:={

	NotNullFieldTest[packet,{
		LighterType,IgnitionSourceType,FuelType,Refillable
	}]

};


(* ::Subsection::Closed:: *)
(*validModelPartLightObscurationSensorQTests*)


validModelPartLightObscurationSensorQTests[packet:PacketP[Model[Part,LightObscurationSensor]]]:={

};


(* ::Subsection::Closed:: *)
(*validModelPartSmokeGeneratorQTests*)


validModelPartSmokeGeneratorQTests[packet:PacketP[Model[Part,SmokeGenerator]]]:={

	NotNullFieldTest[packet,{
		GenerationMethod,FuelType,SelfIgniting
	}]

};


(* ::Subsection::Closed:: *)
(*validModelPartBatteryQTests*)


validModelPartBatteryQTests[packet:PacketP[Model[Part,Battery]]]:={

	NotNullFieldTest[packet,{
		BatteryMaterials,MaximumCharge,Voltage
	}]

};



(* ::Subsection::Closed:: *)
(*validModelPartBrakeQTests*)


validModelPartBrakeQTests[packet:PacketP[Model[Part,Brake]]]:={

	NotNullFieldTest[packet,{
		EngagementMethod,BrakeHeight
	}]

};


(* ::Subsection::Closed:: *)
(*validModelPartCartridgeCapQTests*)


validModelPartCartridgeCapQTests[packet:PacketP[Model[Part,CartridgeCap]]]:={

	NotNullFieldTest[packet,{MaxPressure,MinBedWeight,MaxBedWeight}],

	FieldComparisonTest[packet,{MinBedWeight,MaxBedWeight},LessEqual]

};


(* ::Subsection::Closed:: *)
(*validModelPartRefractometerToolQTests*)


validModelPartRefractometerToolQTests[packet:PacketP[Model[Part,RefractometerTool]]]:={
	NotNullFieldTest[packet,{
		WettedMaterials
	}],
	
	NullFieldTest[packet,{
		Expires,
		ShelfLife
	}]
};



(* ::Subsection::Closed:: *)
(*validModelPartDryingCartridgeQTests*)


validModelPartDryingCartridgeQTests[packet:PacketP[Model[Part,DryingCartridge]]]:={};


(* ::Subsection::Closed:: *)
(*validModelPartAlarmQTests*)


validModelPartAlarmQTests[packet:PacketP[Model[Part,Alarm]]]:={};


(* ::Subsection::Closed:: *)
(*validModelPartFireAlarmActivatorQTests*)


validModelPartFireAlarmActivatorQTests[packet:PacketP[Model[Part,FireAlarmActivator]]]:={};


(* ::Subsection::Closed:: *)
(*validModelPartFireExtinguisherQTests*)


validModelPartFireExtinguisherQTests[packet:PacketP[Model[Part,FireExtinguisher]]]:={};


(* ::Subsection::Closed:: *)
(*validModelPartFirstAidKitQTests*)


validModelPartFirstAidKitQTests[packet:PacketP[Model[Part,FirstAidKit]]]:={};


(* ::Subsection::Closed:: *)
(*validModelPartFloodLightQTests*)


validModelPartFloodLightQTests[packet:PacketP[Model[Part,FloodLight]]]:={};


(* ::Subsection::Closed:: *)
(*validModelPartSafetyWashStationQTests*)


validModelPartSafetyWashStationQTests[packet:PacketP[Model[Part,SafetyWashStation]]]:={};


(* ::Subsection::Closed:: *)
(*validModelPartRespiratorQTests*)


validModelPartRespiratorQTests[packet:PacketP[Model[Part,Respirator]]]:={};


(* ::Subsection::Closed:: *)
(*validModelPartRespiratorFilterQTests*)


validModelPartRespiratorFilterQTests[packet:PacketP[Model[Part,RespiratorFilter]]]:={};


(* ::Subsection::Closed:: *)
(*validModelPartDryingCartridgeQTests*)


validModelPartCuttingJigQTests[packet:PacketP[Model[Part, CuttingJig]]]:={
	NotNullFieldTest[packet,{
		TubingCutters
	}]
};



(* ::Subsection::Closed:: *)
(*validModelPartStickerPrinterQTests*)


validModelPartStickerPrinterQTests[packet:PacketP[Model[Part,StickerPrinter]]]:={};


(* ::Subsection::Closed:: *)
(*validModelPartSamplingProbeQTests*)


validModelPartSamplingProbeQTests[packet:PacketP[Model[Part,SamplingProbe]]]:={
	NotNullFieldTest[
		packet,
		{
			ProbeLength
		}
	]
};

(* ::Subsection::Closed:: *)
(*validModelPartClampQTests*)


validModelPartClampQTests[packet:PacketP[Model[Part,Clamp]]]:={
	NotNullFieldTest[
		packet,
		{
			InnerDiameter
		}
	]
};



(* ::Subsection:: *)
(*validModelPartFlaskRingQTests*)


validModelPartFlaskRingQTests[packet:PacketP[Model[Part,FlaskRing]]]:={
	NotNullFieldTest[packet,{Aperture}]
};



(* ::Subsection:: *)
(*validModelPartPositioningPinQTests*)


validModelPartPositioningPinQTests[packet:PacketP[Model[Part,PositioningPin]]]:={
	NotNullFieldTest[packet,{PinBodyLength}]
};


(* ::Subsection:: *)
(*validModelPartTybeBlockQTests*)


validModelPartTybeBlockQTests[packet:PacketP[Model[Part, TubeBlock]]]:={
	NotNullFieldTest[packet,{MaxNumberOfUses}]
};



(* ::Subsection:: *)
(* Test Registration *)


registerValidQTestFunction[Model[Part], validModelPartQTests];
registerValidQTestFunction[Model[Part, CrimpingJig],validModelPartCrimpingJigQTests];
registerValidQTestFunction[Model[Part, CrimpingHead],validModelPartCrimpingHeadQTests];
registerValidQTestFunction[Model[Part, DecrimpingHead],validModelPartDecrimpingHeadQTests];
registerValidQTestFunction[Model[Part, AlignmentTool],validModelPartAlignmentToolQTests];
registerValidQTestFunction[Model[Part, AspiratorAdapter],validModelPartAspiratorAdapterQTests];
registerValidQTestFunction[Model[Part, ApertureTube],validModelPartApertureTubeQTests];
registerValidQTestFunction[Model[Part, Balance],validModelPartBalanceQTests];
registerValidQTestFunction[Model[Part, BarcodeReader],validModelPartBarcodeReaderQTests];
registerValidQTestFunction[Model[Part, Backdrop],validModelPartBackdropQTests];
registerValidQTestFunction[Model[Part, Battery],validModelPartBatteryQTests];
registerValidQTestFunction[Model[Part, BackfillVent],validModelPartBackfillVentQTests];
registerValidQTestFunction[Model[Part, BeamStop],validModelPartBeamStopQTests];
registerValidQTestFunction[Model[Part, Brake],validModelPartBrakeQTests];
registerValidQTestFunction[Model[Part, BLIPlateCover],validModelPartBLIPlateCoverQTests];
registerValidQTestFunction[Model[Part, BristlePlate],validModelPartBristlePlateTests];
registerValidQTestFunction[Model[Part, Camera],validModelPartCameraQTests];
registerValidQTestFunction[Model[Part, CalibrationCard],validModelPartCalibrationCardQTests];
registerValidQTestFunction[Model[Part, CapillaryArray],validModelPartCapillaryArrayQTests];
registerValidQTestFunction[Model[Part, CapillaryELISATestCartridge],validModelPartCapillaryELISATestCartridgeQTests];
registerValidQTestFunction[Model[Part, CentrifugeAdapter],validModelPartCentrifugeAdapterQTests];
registerValidQTestFunction[Model[Part, CheckValve],validModelPartCheckValveQTests];
registerValidQTestFunction[Model[Part, Chiller],validModelPartChillerQTests];
registerValidQTestFunction[Model[Part, Computer],validModelPartComputerQTests];
registerValidQTestFunction[Model[Part, ConductivityProbe],validModelPartConductivityProbeQTests];
registerValidQTestFunction[Model[Part, ConductivitySensor],validModelPartConductivitySensorQTests];
registerValidQTestFunction[Model[Part, DialysisClip],validModelPartDialysisClipQTests];
registerValidQTestFunction[Model[Part, DiodeArrayModule],validModelPartDiodeArrayModuleQTests];
registerValidQTestFunction[Model[Part, ElectrochemicalReactionVesselHolder],validModelPartElectrochemicalReactionVesselHolderQTests];
registerValidQTestFunction[Model[Part, ElectrodePolishingPlate],validModelPartElectrodePolishingPlateQTests];
registerValidQTestFunction[Model[Part, ElectrodeRack],validModelPartElectrodeRackQTests];
registerValidQTestFunction[Model[Part, EluentGenerator],validModelPartEluentGeneratorQTests];
registerValidQTestFunction[Model[Part, EmbeddedPC],validModelPartEmbeddedPCQTests];
registerValidQTestFunction[Model[Part, Fan],validModelPartFanQTests];
registerValidQTestFunction[Model[Part, FanFilterUnit],validModelPartFanFilterUnitQTests];
registerValidQTestFunction[Model[Part, FillRod],validModelPartFillRodQTests];
registerValidQTestFunction[Model[Part, Filter],validModelPartFilterQTests];
registerValidQTestFunction[Model[Part, FilterAdapter],validModelPartFilterAdapterQTests];
registerValidQTestFunction[Model[Part, Ferrule],validModelPartFerruleQTests];
registerValidQTestFunction[Model[Part, FlowCell],validModelPartFlowCellQTests];
registerValidQTestFunction[Model[Part, FlowRestrictor],validModelPartFlowRestrictorQTests];
registerValidQTestFunction[Model[Part, FoamImagingModule],validModelPartFoamImagingModuleQTests];
registerValidQTestFunction[Model[Part, Funnel],validModelPartFunnelQTests];
registerValidQTestFunction[Model[Part, FurnitureEquipment],validModelPartFurnitureEquipmentQTests];
registerValidQTestFunction[Model[Part, GauzeHolder],validModelPartGauzeHolderQTests];
registerValidQTestFunction[Model[Part, GrinderClampAssembly],validModelPartGrinderClampAssemblyQTests];
registerValidQTestFunction[Model[Part, HandPump],validModelPartHandPumpQTests];
registerValidQTestFunction[Model[Part, HeatExchanger],validModelPartHeatExchangerQTests];
registerValidQTestFunction[Model[Part, HeatSink],validModelPartHeatSinkQTests];
registerValidQTestFunction[Model[Part, HexKey],validModelPartHexKeyQTests];
registerValidQTestFunction[Model[Part, InformationTechnology],validModelPartInformationTechnologyQTests];
registerValidQTestFunction[Model[Part, Inverter],validModelPartInverterQTests];
registerValidQTestFunction[Model[Part, Lamp],validModelPartLampQTests];
registerValidQTestFunction[Model[Part, LiquidConductivityModule],validModelPartLiquidConductivityModuleQTests];
registerValidQTestFunction[Model[Part, NeedleLockingScrew],validModelPartNeedleLockingScrew];
registerValidQTestFunction[Model[Part, NMRDepthGauge],validModelPartNMRDepthGaugeQTests];
registerValidQTestFunction[Model[Part, NMRProbe],validModelPartNMRProbeQTests];
registerValidQTestFunction[Model[Part, Nut],validModelPartNutQTests];
registerValidQTestFunction[Model[Part, Nozzle],validModelPartNozzleQTests];
registerValidQTestFunction[Model[Part, Laser],validModelPartLaserQTests];
registerValidQTestFunction[Model[Part, LaserOpticModule],validModelPartLaserOpticModuleQTests];
registerValidQTestFunction[Model[Part, MeterModule], validModelPartMeterModuleQTests];
registerValidQTestFunction[Model[Part, Mixer], validModelPartMixerQTests];
registerValidQTestFunction[Model[Part, Objective],validModelPartObjectiveQTests];
registerValidQTestFunction[Model[Part, OpticalFilter],validModelPartOpticalFilterQTests];
registerValidQTestFunction[Model[Part, OpticModule],validModelPartOpticModuleQTests];
registerValidQTestFunction[Model[Part, ORing],validModelPartORingQTests];
registerValidQTestFunction[Model[Part, PeristalticPump],validModelPartPeristalticPumpQTests];
registerValidQTestFunction[Model[Part, VacuumPump],validModelPartVacuumPumpQTests];
registerValidQTestFunction[Model[Part, pHProbe],validModelPartpHProbeQTests];
registerValidQTestFunction[Model[Part, Piston],validModelPartPistonQTests];
registerValidQTestFunction[Model[Part, PressureRegulator],validModelPartPressureRegulatorQTests];
registerValidQTestFunction[Model[Part, PressureSensor],validModelPartPressureSensorQTests];
registerValidQTestFunction[Model[Part, PowerDistributionUnit],validModelPartPowerDistributionUnitQTests];
registerValidQTestFunction[Model[Part, ReferenceElectrode],validModelPartReferenceElectrodeQTests];
registerValidQTestFunction[Model[Part, Seal],validModelPartSealQTests];
registerValidQTestFunction[Model[Part, Sensornet],validModelPartSensornetQTests];
registerValidQTestFunction[Model[Part, ShakerAdapter],validModelPartShakerAdapterQTests];
registerValidQTestFunction[Model[Part, SpargeFilter],validModelPartSpargeFilterQTests];
registerValidQTestFunction[Model[Part, Spectrophotometer],validModelPartSpectrophotometerQTests];
registerValidQTestFunction[Model[Part, StirBlade],validModelPartStirBladeQTests];
registerValidQTestFunction[Model[Part, Suppressor],validModelPartSuppressorQTests];
registerValidQTestFunction[Model[Part, Syringe],validModelPartSyringeQTests];
registerValidQTestFunction[Model[Part, TemperatureProbe],validModelPartTemperatureProbeQTests];
registerValidQTestFunction[Model[Part, TensiometerProbe],validModelPartTensiometerProbeQTests];
registerValidQTestFunction[Model[Part, TensiometerProbeCleaner],validModelPartTensiometerProbeCleanerQTests];
registerValidQTestFunction[Model[Part, ThermalBlock],validModelPartThermalBlockQTests];
registerValidQTestFunction[Model[Part, ViscometerChip],validModelPartViscometerChipQTests];
registerValidQTestFunction[Model[Part, StirBar],validModelPartStirBarQTests];
registerValidQTestFunction[Model[Part, StirBarRetriever],validModelPartStirBarRetrieverQTests];
registerValidQTestFunction[Model[Part, StirrerShaft],validModelPartStirrerShaftQTests];
registerValidQTestFunction[Model[Part, SolenoidValve],validModelPartSolenoidValveQTests];
registerValidQTestFunction[Model[Part, SonicationHorn],validModelPartSonicationHornQTests];
registerValidQTestFunction[Model[Part, DispensingHead],validModelPartDispensingHeadQTests];
registerValidQTestFunction[Model[Part, AmpouleOpener],validModelPartAmpouleOpenerQTests];
registerValidQTestFunction[Model[Part, UniversalInterfaceConverter],validModelPartUniversalInterfaceConverterQTests];
registerValidQTestFunction[Model[Part, Lighter],validModelPartLighterQTests];
registerValidQTestFunction[Model[Part, LightObscurationSensor],validModelPartLightObscurationSensorQTests];
registerValidQTestFunction[Model[Part, SmokeGenerator],validModelPartSmokeGeneratorQTests];
registerValidQTestFunction[Model[Part, RefrigerationUnit],validModelPartRefrigerationUnitQTests];
registerValidQTestFunction[Model[Part, CartridgeCap],validModelPartCartridgeCapQTests];
registerValidQTestFunction[Model[Part, RefractometerTool],validModelPartRefractometerToolQTests];
registerValidQTestFunction[Model[Part, DryingCartridge],validModelPartDryingCartridgeQTests];
registerValidQTestFunction[Model[Part, Alarm],validModelPartAlarmQTests];
registerValidQTestFunction[Model[Part, FireAlarmActivator],validModelPartFireAlarmActivatorQTests];
registerValidQTestFunction[Model[Part, FireExtinguisher],validModelPartFireExtinguisherQTests];
registerValidQTestFunction[Model[Part, FirstAidKit],validModelPartFirstAidKitQTests];
registerValidQTestFunction[Model[Part, FloodLight],validModelPartFloodLightQTests];
registerValidQTestFunction[Model[Part, SafetyWashStation],validModelPartSafetyWashStationQTests];
registerValidQTestFunction[Model[Part, Respirator],validModelPartRespiratorQTests];
registerValidQTestFunction[Model[Part, RespiratorFilter],validModelPartRespiratorFilterQTests];
registerValidQTestFunction[Model[Part, StickerPrinter],validModelPartStickerPrinterQTests];
registerValidQTestFunction[Model[Part, SamplingProbe],validModelPartSamplingProbeQTests];
registerValidQTestFunction[Model[Part, CuttingJig],validModelPartCuttingJigQTests];
registerValidQTestFunction[Model[Part, GravityRackPlatform],validModelPartGravityRackPlatformQTests];
registerValidQTestFunction[Model[Part, FlaskRing],validModelPartFlaskRingQTests];
registerValidQTestFunction[Model[Part, PositioningPin],validModelPartPositioningPinQTests];
registerValidQTestFunction[Model[Part, TubeBlock],validModelPartTybeBlockQTests];
registerValidQTestFunction[Model[Part, Clamp],validModelPartClampQTests];



(* ::Section:: *)
(*End*)
